import {
  BadRequestException,
  Injectable,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import { AppService } from '../app.service';
import {
  AllocationDecision,
  AllocationRunResult,
  AllocationSuggestion,
  ProviderScore,
} from './allocation.types';

interface ProviderCandidate {
  id: string;
  name: string;
  serviceType: string;
  city: string;
  state: string;
  pincode: string;
  rating: number;
  activeJobs: number;
}

interface RequestContext {
  id: string;
  consumerId: string;
  consumerName: string;
  category: string;
  description: string;
  city?: string;
  sector?: string;
  pincode?: string;
  status: string;
}

/** Maps consumer request categories to provider serviceType values. */
const CATEGORY_TO_SERVICE_TYPES: Record<string, string[]> = {
  Electricity: ['Electrician'],
  Electrician: ['Electrician'],
  Plumbing: ['Plumber'],
  Plumber: ['Plumber'],
  'Water Supply': ['Plumber'],
  'AC Service': ['AC Service'],
  'Appliance Repair': ['Appliance Repair'],
  Carpenter: ['Carpenter'],
  Cleaning: ['Cleaning'],
  Maintenance: ['Maintenance', 'Electrician', 'Carpenter', 'Plumber'],
  Other: ['Other', 'Maintenance', 'Electrician', 'Plumber'],
};

@Injectable()
export class AllocationAgentService {
  constructor(private readonly appService: AppService) {}

  async suggestForRequest(requestId: string): Promise<AllocationSuggestion> {
    const request = await this.appService.getRequestForAllocation(requestId);
    const [providers, requests, consumer] = await Promise.all([
      this.appService.getAllServiceProviders(),
      this.appService.getAllRequests(),
      this.appService.getConsumer(request.consumerId).catch(() => null),
    ]);

    const workload = this.buildWorkloadMap(requests);
    const requestCity =
      request.address?.city ?? consumer?.city ?? consumer?.address?.city;
    const requestPincode =
      request.address?.pincode ?? consumer?.pincode ?? consumer?.address?.pincode;

    const scores = this.scoreProviders(
      request,
      providers.map((provider) => ({
        ...provider,
        activeJobs: workload.get(provider.id) ?? 0,
      })),
      requestCity,
      requestPincode,
    );

    const eligible = scores.filter((item) => item.eligible);
    if (eligible.length === 0) {
      return {
        requestId,
        recommendation: null,
        eligibleProviders: scores,
        message: 'No eligible service provider found for this request category and location.',
      };
    }

    const decision = await this.pickProvider(
      this.toRequestContext(request, requestCity, requestPincode),
      eligible,
      providers,
    );

    return {
      requestId,
      recommendation: decision,
      eligibleProviders: scores,
    };
  }

  async allocateRequest(
    requestId: string,
    options: { dryRun?: boolean } = {},
  ): Promise<AllocationDecision> {
    const suggestion = await this.suggestForRequest(requestId);

    if (!suggestion.recommendation) {
      throw new BadRequestException(
        suggestion.message ?? `Cannot allocate request ${requestId}`,
      );
    }

    if (options.dryRun) {
      return suggestion.recommendation;
    }

    await this.appService.assignProviderToRequest(
      requestId,
      suggestion.recommendation.providerId,
      {
        reason: suggestion.recommendation.reason,
        confidence: suggestion.recommendation.confidence,
        method: suggestion.recommendation.method,
      },
    );

    return suggestion.recommendation;
  }

  async runBatch(options: { dryRun?: boolean } = {}): Promise<AllocationRunResult> {
    const openRequests = await this.appService.getOpenUnassignedRequests();
    const decisions: AllocationDecision[] = [];
    let assigned = 0;
    let skipped = 0;

    const providers = await this.appService.getAllServiceProviders();
    let requests = await this.appService.getAllRequests();
    const workload = this.buildWorkloadMap(requests);

    for (const request of openRequests) {
      const consumer = await this.appService
        .getConsumer(request.consumerId)
        .catch(() => null);
      const requestCity =
        request.address?.city ?? consumer?.city ?? consumer?.address?.city;
      const requestPincode =
        request.address?.pincode ?? consumer?.pincode ?? consumer?.address?.pincode;

      const scores = this.scoreProviders(
        request,
        providers.map((provider) => ({
          ...provider,
          activeJobs: workload.get(provider.id) ?? 0,
        })),
        requestCity,
        requestPincode,
      );

      const eligible = scores.filter((item) => item.eligible);
      if (eligible.length === 0) {
        skipped += 1;
        continue;
      }

      const decision = await this.pickProvider(
        this.toRequestContext(request, requestCity, requestPincode),
        eligible,
        providers,
      );

      decisions.push(decision);

      if (!options.dryRun) {
        await this.appService.assignProviderToRequest(
          request.id,
          decision.providerId,
          {
            reason: decision.reason,
            confidence: decision.confidence,
            method: decision.method,
          },
        );
        workload.set(decision.providerId, (workload.get(decision.providerId) ?? 0) + 1);
        requests = await this.appService.getAllRequests();
      }

      assigned += 1;
    }

    return {
      processed: openRequests.length,
      assigned,
      skipped,
      dryRun: Boolean(options.dryRun),
      decisions,
    };
  }

  private toRequestContext(
    request: {
      id: string;
      consumerId: string;
      consumerName: string;
      category: string;
      description: string;
      status: string;
    },
    city?: string,
    pincode?: string,
    sector?: string,
  ): RequestContext {
    return {
      id: request.id,
      consumerId: request.consumerId,
      consumerName: request.consumerName,
      category: request.category,
      description: request.description,
      status: request.status,
      city,
      pincode,
      sector,
    };
  }

  private buildWorkloadMap(
    requests: Array<{ assignedProviderId?: string; status: string }>,
  ) {
    const workload = new Map<string, number>();

    for (const request of requests) {
      if (!request.assignedProviderId || request.status === 'Closed') {
        continue;
      }
      workload.set(
        request.assignedProviderId,
        (workload.get(request.assignedProviderId) ?? 0) + 1,
      );
    }

    return workload;
  }

  private scoreProviders(
    request: { id: string; category: string },
    providers: ProviderCandidate[],
    requestCity?: string,
    requestPincode?: string,
  ): ProviderScore[] {
    return providers
      .map((provider) => {
        const categoryMatch = this.matchesServiceCategory(
          request.category,
          provider.serviceType,
        );

        if (!categoryMatch) {
          return {
            providerId: provider.id,
            providerName: provider.name,
            serviceType: provider.serviceType,
            city: provider.city,
            rating: provider.rating,
            activeJobs: provider.activeJobs,
            score: 0,
            eligible: false,
            ineligibleReason: `Service type "${provider.serviceType}" does not match request category "${request.category}"`,
          };
        }

        let score = provider.rating * 10;
        const normalizedRequestCity = requestCity?.trim().toLowerCase();
        const normalizedProviderCity = provider.city.trim().toLowerCase();

        if (normalizedRequestCity && normalizedRequestCity === normalizedProviderCity) {
          score += 25;
        } else if (normalizedRequestCity) {
          score -= 8;
        }

        if (
          requestPincode &&
          provider.pincode &&
          requestPincode.slice(0, 3) === provider.pincode.slice(0, 3)
        ) {
          score += 8;
        }

        score -= provider.activeJobs * 6;
        score = Math.round(score * 10) / 10;

        return {
          providerId: provider.id,
          providerName: provider.name,
          serviceType: provider.serviceType,
          city: provider.city,
          rating: provider.rating,
          activeJobs: provider.activeJobs,
          score,
          eligible: true,
        };
      })
      .sort((left, right) => right.score - left.score);
  }

  private matchesServiceCategory(requestCategory: string, serviceType: string) {
    const request = requestCategory.trim().toLowerCase();
    const service = serviceType.trim().toLowerCase();

    if (request === service || request.includes(service) || service.includes(request)) {
      return true;
    }

    const mapped = CATEGORY_TO_SERVICE_TYPES[requestCategory] ?? [];
    return mapped.some((item) => item.toLowerCase() === service);
  }

  private async pickProvider(
    request: RequestContext,
    eligibleScores: ProviderScore[],
    providers: Array<{ id: string; name: string }>,
  ): Promise<AllocationDecision> {
    const apiKey = process.env.OPENAI_API_KEY?.trim();

    if (apiKey) {
      try {
        return await this.pickWithAi(request, eligibleScores, providers, apiKey);
      } catch (error) {
        const message = error instanceof Error ? error.message : 'AI allocation failed';
        console.warn(`[allocation-agent] Falling back to heuristic scoring: ${message}`);
      }
    }

    return this.pickWithHeuristic(request, eligibleScores);
  }

  private pickWithHeuristic(
    request: RequestContext,
    eligibleScores: ProviderScore[],
  ): AllocationDecision {
    const best = eligibleScores[0];

    return {
      requestId: request.id,
      providerId: best.providerId,
      providerName: best.providerName,
      reason: `Best match by rating, location, and workload (score ${best.score}, ${best.activeJobs} active jobs).`,
      confidence: Math.min(0.95, 0.55 + best.score / 100),
      method: 'heuristic',
      scores: eligibleScores,
    };
  }

  private async pickWithAi(
    request: RequestContext,
    eligibleScores: ProviderScore[],
    providers: Array<{ id: string; name: string }>,
    apiKey: string,
  ): Promise<AllocationDecision> {
    const model = process.env.OPENAI_MODEL?.trim() || 'gpt-4o-mini';
    const allowedIds = new Set(eligibleScores.map((item) => item.providerId));

    const payload = {
      request,
      candidates: eligibleScores,
      rules: [
        'Pick exactly one providerId from candidates.',
        'Prefer higher score, lower activeJobs, and same city when tied.',
        'Return strict JSON only.',
      ],
    };

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model,
        temperature: 0.2,
        response_format: { type: 'json_object' },
        messages: [
          {
            role: 'system',
            content:
              'You are a service dispatch agent. Assign one service provider to a consumer request. Respond with JSON: {"providerId":"...","reason":"...","confidence":0.0}',
          },
          {
            role: 'user',
            content: JSON.stringify(payload),
          },
        ],
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new ServiceUnavailableException(
        `OpenAI request failed (${response.status}): ${errorBody}`,
      );
    }

    const body = (await response.json()) as {
      choices?: Array<{ message?: { content?: string } }>;
    };
    const content = body.choices?.[0]?.message?.content;

    if (!content) {
      throw new ServiceUnavailableException('OpenAI returned an empty response');
    }

    const parsed = JSON.parse(content) as {
      providerId?: string;
      reason?: string;
      confidence?: number;
    };

    if (!parsed.providerId || !allowedIds.has(parsed.providerId)) {
      throw new BadRequestException('AI selected an invalid provider');
    }

    const provider = providers.find((item) => item.id === parsed.providerId);
    if (!provider) {
      throw new NotFoundException(`Provider ${parsed.providerId} not found`);
    }

    return {
      requestId: request.id,
      providerId: parsed.providerId,
      providerName: provider.name,
      reason: parsed.reason?.trim() || 'Selected by AI allocation agent.',
      confidence: Math.max(0, Math.min(1, Number(parsed.confidence ?? 0.75))),
      method: 'ai',
      scores: eligibleScores,
    };
  }
}
