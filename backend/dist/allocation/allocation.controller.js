"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AllocationController = void 0;
const common_1 = require("@nestjs/common");
const allocation_agent_service_1 = require("./allocation-agent.service");
let AllocationController = class AllocationController {
    constructor(allocationAgent) {
        this.allocationAgent = allocationAgent;
    }
    suggest(id) {
        return this.allocationAgent.suggestForRequest(id);
    }
    allocateRequest(id, dryRun) {
        return this.allocationAgent.allocateRequest(id, {
            dryRun: dryRun === 'true',
        });
    }
    runBatch(dryRun) {
        return this.allocationAgent.runBatch({
            dryRun: dryRun === 'true',
        });
    }
};
exports.AllocationController = AllocationController;
__decorate([
    (0, common_1.Get)('requests/:id/allocation-suggestion'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AllocationController.prototype, "suggest", null);
__decorate([
    (0, common_1.Post)('requests/:id/allocate'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Query)('dryRun')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], AllocationController.prototype, "allocateRequest", null);
__decorate([
    (0, common_1.Post)('allocations/run'),
    __param(0, (0, common_1.Query)('dryRun')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AllocationController.prototype, "runBatch", null);
exports.AllocationController = AllocationController = __decorate([
    (0, common_1.Controller)(),
    __metadata("design:paramtypes", [allocation_agent_service_1.AllocationAgentService])
], AllocationController);
//# sourceMappingURL=allocation.controller.js.map