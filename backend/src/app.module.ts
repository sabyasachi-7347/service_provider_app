import { Module } from '@nestjs/common';
import { AllocationAgentService } from './allocation/allocation-agent.service';
import { AllocationController } from './allocation/allocation.controller';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { FirebaseService } from './firebase.service';
import { OtpController } from './otp/otp.controller';
import { OtpService } from './otp/otp.service';

@Module({
  imports: [],
  controllers: [AppController, AllocationController, OtpController],
  providers: [AppService, FirebaseService, AllocationAgentService, OtpService],
})
export class AppModule {}
