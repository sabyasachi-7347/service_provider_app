"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.OtpService = void 0;
const common_1 = require("@nestjs/common");
const OTP_TTL_MS = 5 * 60 * 1000;
let OtpService = class OtpService {
    constructor() {
        this.pending = new Map();
    }
    send(mobile) {
        const code = Math.floor(1000 + Math.random() * 9000).toString();
        this.pending.set(mobile, { code, expiresAt: Date.now() + OTP_TTL_MS });
        return code;
    }
    verify(mobile, code) {
        const entry = this.pending.get(mobile);
        if (!entry || entry.expiresAt < Date.now()) {
            this.pending.delete(mobile);
            throw new common_1.BadRequestException('OTP expired or not requested. Please resend.');
        }
        if (entry.code !== code) {
            throw new common_1.BadRequestException('Incorrect OTP');
        }
        this.pending.delete(mobile);
    }
};
exports.OtpService = OtpService;
exports.OtpService = OtpService = __decorate([
    (0, common_1.Injectable)()
], OtpService);
//# sourceMappingURL=otp.service.js.map