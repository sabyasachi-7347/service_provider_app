import { Body, Controller, Post } from '@nestjs/common';
import { SendOtpDto, VerifyOtpDto } from '../dto';
import { OtpService } from './otp.service';

@Controller('otp')
export class OtpController {
  constructor(private readonly otpService: OtpService) {}

  @Post('send')
  send(@Body() body: SendOtpDto) {
    const otp = this.otpService.send(body.mobile);
    // No SMS gateway configured yet — return the code so the demo flow is testable end-to-end.
    return { message: 'OTP sent', otp };
  }

  @Post('verify')
  verify(@Body() body: VerifyOtpDto) {
    this.otpService.verify(body.mobile, body.otp);
    return { verified: true };
  }
}
