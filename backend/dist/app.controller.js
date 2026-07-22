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
exports.AppController = void 0;
const common_1 = require("@nestjs/common");
const app_service_1 = require("./app.service");
const dto_1 = require("./dto");
let AppController = class AppController {
    constructor(appService) {
        this.appService = appService;
    }
    health() {
        return { status: 'ok' };
    }
    login(body) {
        return this.appService.login(body);
    }
    metadata() {
        return this.appService.getMetadata();
    }
    adminSummary() {
        return this.appService.getAdminSummary();
    }
    consumers(city, sector, houseType, building, q) {
        return this.appService.getConsumers({ city, sector, houseType, building, q });
    }
    createConsumer(body) {
        return this.appService.createConsumer(body);
    }
    consumer(id) {
        return this.appService.getConsumer(id);
    }
    updateConsumer(id, body) {
        return this.appService.updateConsumer(id, body);
    }
    serviceProviders(city, category, minRating, q) {
        return this.appService.getServiceProviders({ city, category, minRating, q });
    }
    createServiceProvider(body) {
        return this.appService.createServiceProvider(body);
    }
    serviceProvider(id) {
        return this.appService.getServiceProvider(id);
    }
    serviceProviderDashboard(id) {
        return this.appService.getProviderDashboard(id);
    }
    requests(status, category, q) {
        return this.appService.getRequests({ status, category, q });
    }
    createRequest(body) {
        return this.appService.createRequest(body);
    }
    updateRequestStatus(id, body) {
        return this.appService.updateRequestStatus(id, body);
    }
    createFeedback(body) {
        return this.appService.createFeedback(body);
    }
};
exports.AppController = AppController;
__decorate([
    (0, common_1.Get)('health'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AppController.prototype, "health", null);
__decorate([
    (0, common_1.Post)('auth/login'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.LoginDto]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "login", null);
__decorate([
    (0, common_1.Get)('metadata'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AppController.prototype, "metadata", null);
__decorate([
    (0, common_1.Get)('admin/summary'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AppController.prototype, "adminSummary", null);
__decorate([
    (0, common_1.Get)('consumers'),
    __param(0, (0, common_1.Query)('city')),
    __param(1, (0, common_1.Query)('sector')),
    __param(2, (0, common_1.Query)('houseType')),
    __param(3, (0, common_1.Query)('building')),
    __param(4, (0, common_1.Query)('q')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, String, String]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "consumers", null);
__decorate([
    (0, common_1.Post)('consumers'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateConsumerDto]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "createConsumer", null);
__decorate([
    (0, common_1.Get)('consumers/:id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "consumer", null);
__decorate([
    (0, common_1.Patch)('consumers/:id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, dto_1.UpdateConsumerDto]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "updateConsumer", null);
__decorate([
    (0, common_1.Get)('service-providers'),
    __param(0, (0, common_1.Query)('city')),
    __param(1, (0, common_1.Query)('category')),
    __param(2, (0, common_1.Query)('minRating')),
    __param(3, (0, common_1.Query)('q')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, String]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "serviceProviders", null);
__decorate([
    (0, common_1.Post)('service-providers'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateProviderDto]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "createServiceProvider", null);
__decorate([
    (0, common_1.Get)('service-providers/:id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "serviceProvider", null);
__decorate([
    (0, common_1.Get)('service-providers/:id/dashboard'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "serviceProviderDashboard", null);
__decorate([
    (0, common_1.Get)('requests'),
    __param(0, (0, common_1.Query)('status')),
    __param(1, (0, common_1.Query)('category')),
    __param(2, (0, common_1.Query)('q')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "requests", null);
__decorate([
    (0, common_1.Post)('requests'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateRequestDto]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "createRequest", null);
__decorate([
    (0, common_1.Patch)('requests/:id/status'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, dto_1.UpdateRequestStatusDto]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "updateRequestStatus", null);
__decorate([
    (0, common_1.Post)('feedback'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateFeedbackDto]),
    __metadata("design:returntype", void 0)
], AppController.prototype, "createFeedback", null);
exports.AppController = AppController = __decorate([
    (0, common_1.Controller)(),
    __metadata("design:paramtypes", [app_service_1.AppService])
], AppController);
//# sourceMappingURL=app.controller.js.map