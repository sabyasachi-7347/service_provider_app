export type AllocationMethod = 'ai' | 'heuristic';

export interface AllocationDecision {
  requestId: string;
  providerId: string;
  providerName: string;
  reason: string;
  confidence: number;
  method: AllocationMethod;
  scores?: ProviderScore[];
}

export interface ProviderScore {
  providerId: string;
  providerName: string;
  serviceType: string;
  city: string;
  rating: number;
  activeJobs: number;
  score: number;
  eligible: boolean;
  ineligibleReason?: string;
}

export interface AllocationRunResult {
  processed: number;
  assigned: number;
  skipped: number;
  dryRun: boolean;
  decisions: AllocationDecision[];
}

export interface AllocationSuggestion {
  requestId: string;
  recommendation: AllocationDecision | null;
  eligibleProviders: ProviderScore[];
  message?: string;
}
