import { Controller, Get, Param, Post, Query } from '@nestjs/common';
import { AllocationAgentService } from './allocation-agent.service';

@Controller()
export class AllocationController {
  constructor(private readonly allocationAgent: AllocationAgentService) {}

  /** Preview allocation without saving. */
  @Get('requests/:id/allocation-suggestion')
  suggest(@Param('id') id: string) {
    return this.allocationAgent.suggestForRequest(id);
  }

  /** Assign the best provider to one open request. */
  @Post('requests/:id/allocate')
  allocateRequest(
    @Param('id') id: string,
    @Query('dryRun') dryRun?: string,
  ) {
    return this.allocationAgent.allocateRequest(id, {
      dryRun: dryRun === 'true',
    });
  }

  /** Assign providers to all open, unassigned requests. */
  @Post('allocations/run')
  runBatch(@Query('dryRun') dryRun?: string) {
    return this.allocationAgent.runBatch({
      dryRun: dryRun === 'true',
    });
  }
}
