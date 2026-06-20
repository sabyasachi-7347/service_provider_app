import { Module } from '@nestjs/common';
import { AllocationAgentService } from './allocation/allocation-agent.service';
import { AllocationController } from './allocation/allocation.controller';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { FirebaseService } from './firebase.service';

@Module({
  imports: [],
  controllers: [AppController, AllocationController],
  providers: [AppService, FirebaseService, AllocationAgentService],
})
export class AppModule {}
