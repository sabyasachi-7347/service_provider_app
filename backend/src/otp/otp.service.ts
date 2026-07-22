import { BadRequestException, Injectable } from '@nestjs/common';

const OTP_TTL_MS = 5 * 60 * 1000;

interface OtpEntry {
  code: string;
  expiresAt: number;
}

/**
 * No SMS gateway is wired up yet, so this stores/validates OTPs in memory
 * and hands the generated code back to the caller instead of texting it.
 * Swap `send()` for a real provider call before shipping this to production.
 */
@Injectable()
export class OtpService {
  private readonly pending = new Map<string, OtpEntry>();

  send(mobile: string): string {
    const code = Math.floor(1000 + Math.random() * 9000).toString();
    this.pending.set(mobile, { code, expiresAt: Date.now() + OTP_TTL_MS });
    return code;
  }

  verify(mobile: string, code: string): void {
    const entry = this.pending.get(mobile);

    if (!entry || entry.expiresAt < Date.now()) {
      this.pending.delete(mobile);
      throw new BadRequestException('OTP expired or not requested. Please resend.');
    }

    if (entry.code !== code) {
      throw new BadRequestException('Incorrect OTP');
    }

    this.pending.delete(mobile);
  }
}
