"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppService = void 0;
const common_1 = require("@nestjs/common");
let AppService = class AppService {
    constructor() {
        this.serviceCategories = [
            'Electrician',
            'Plumber',
            'AC Service',
            'Appliance Repair',
            'Carpenter',
            'Cleaning',
            'Maintenance',
            'Other',
        ];
        this.businessTypes = [
            'Individual',
            'Shop',
            'Workshop',
            'Company',
            'Franchise',
            'Partnership',
        ];
        this.users = [
            { id: 'A001', userId: 'admin', name: 'Admin', role: 'admin' },
            { id: 'SP001', userId: 'sp', name: 'Raj Electrician', role: 'service_provider' },
            { id: 'C001', userId: 'con', name: 'Amit Sharma', role: 'consumer' },
        ];
        this.consumers = [
            // {
            //     id: 'C001',
            //     name: 'Amit Sharma',
            //     mobile: '9876543210',
            //     city: 'Delhi',
            //     sector: '15',
            //     houseType: 'Apartment',
            //     building: 'Tower A',
            //     pincode: '110001',
            //     isAmcActive: true,
            //     address: {
            //         flatNo: '1202',
            //         sector: '15',
            //         floor: '12',
            //         landmark: 'Near Central Park',
            //         area: 'Rohini',
            //         plot: 'A-21',
            //         city: 'Delhi',
            //         buildingName: 'Tower A',
            //         pincode: '110001',
            //     },
            //     assets: [
            //         {
            //             id: 'AS001',
            //             name: 'Split AC',
            //             category: 'Appliance',
            //             subCategory: 'AC Service',
            //             warrantyStart: '2025-01-01',
            //             warrantyEnd: '2026-01-01',
            //             warrantyStatus: 'Active',
            //             lastServiceDate: '2025-07-01',
            //             serviceDueDate: '2025-10-01',
            //             location: 'Bedroom',
            //             billImage: null,
            //         },
            //     ],
            //     familyMembers: [
            //         {
            //             name: 'Riya Sharma',
            //             mobile: '9876500000',
            //             dob: '1998-03-20',
            //             age: 27,
            //             healthInsurance: 'HDFC Health',
            //             insuranceExpiry: '2026-03-20',
            //         },
            //     ],
            //     vehicles: [
            //         {
            //             number: 'DL01AB1234',
            //             owner: 'Amit Sharma',
            //             insurance: 'POL12345',
            //             insuranceExpiry: '2026-05-01',
            //             insuranceStatus: 'Valid',
            //             puc: 'PUC12345',
            //             pucExpiry: '2025-11-01',
            //             pucStatus: 'Valid',
            //             fines: 'None',
            //         },
            //     ],
            // },
            // {
            //     id: 'C002',
            //     name: 'Priya Singh',
            //     mobile: '9123456789',
            //     city: 'Delhi',
            //     sector: '20',
            //     houseType: 'Villa',
            //     building: 'Green Villa',
            //     pincode: '110003',
            //     isAmcActive: false,
            //     address: {
            //         flatNo: '22',
            //         sector: '20',
            //         landmark: 'Near Market',
            //         area: 'Dwarka',
            //         city: 'Delhi',
            //         buildingName: 'Green Villa',
            //         pincode: '110003',
            //     },
            //     assets: [],
            //     familyMembers: [],
            //     vehicles: [],
            // },
        ];
        this.serviceProviders = [
            {
                id: 'SP001',
                name: 'Raj Electrician',
                mobile: '9876543210',
                fullAddressLine: 'Block B, Shop 12',
                city: 'Delhi',
                state: 'Delhi',
                pincode: '110005',
                serviceType: 'Electrician',
                businessType: 'Shop',
                rating: 4.5,
            },
            {
                id: 'SP002',
                name: 'Neha Plumber',
                mobile: '9123456789',
                fullAddressLine: 'Service Plaza, Unit 4',
                city: 'Gurgaon',
                state: 'Haryana',
                pincode: '122001',
                serviceType: 'Plumber',
                businessType: 'Workshop',
                rating: 4.2,
            },
        ];
        this.requests = [
            {
                id: 'CR001',
                consumerId: 'C001',
                consumerName: 'Amit Sharma',
                mobile: '9876543210',
                category: 'Electricity',
                description: 'Frequent power cuts.',
                date: '2025-07-12',
                preferredDate: '2025-07-15',
                status: 'Open',
                assignedProviderId: 'SP001',
            },
            {
                id: 'CR002',
                consumerId: 'C002',
                consumerName: 'Priya Singh',
                mobile: '9123456789',
                category: 'Water Supply',
                description: 'Low water pressure in the morning.',
                date: '2025-07-10',
                preferredDate: '2025-07-12',
                status: 'In Progress',
                assignedProviderId: 'SP002',
            },
            {
                id: 'CR003',
                consumerId: 'C001',
                consumerName: 'Amit Sharma',
                mobile: '9876543210',
                category: 'Maintenance',
                description: 'Street light not working.',
                date: '2025-07-08',
                status: 'Closed',
                assignedProviderId: 'SP001',
            },
        ];
        this.feedback = [
            {
                id: 'FB001',
                requestId: 'CR001',
                serviceProviderId: 'SP001',
                message: 'Great service!',
                createdAt: '2025-07-16T10:00:00.000Z',
            },
            {
                id: 'FB002',
                requestId: 'CR003',
                serviceProviderId: 'SP001',
                message: 'Could be faster',
                createdAt: '2025-07-09T10:00:00.000Z',
            },
        ];
    }
    login(dto) {
        const user = this.users.find((item) => item.userId === dto.userId.trim());
        if (!user) {
            throw new common_1.UnauthorizedException('Invalid user ID');
        }
        return {
            token: `demo-token-${user.id}`,
            user,
        };
    }
    getMetadata() {
        return {
            serviceCategories: this.serviceCategories,
            businessTypes: this.businessTypes,
            requestStatuses: ['Open', 'In Progress', 'Closed'],
        };
    }
    getAdminSummary() {
        return {
            consumers: this.consumers.length,
            serviceProviders: this.serviceProviders.length,
            openRequests: this.requests.filter((item) => item.status !== 'Closed').length,
            activeAmcConsumers: this.consumers.filter((item) => item.isAmcActive).length,
        };
    }
    getConsumers(filters) {
        const query = filters.q?.trim().toLowerCase();
        return this.consumers.filter((consumer) => {
            const matchesQuery = !query ||
                consumer.id.toLowerCase().includes(query) ||
                consumer.name.toLowerCase().includes(query) ||
                consumer.mobile.includes(query);
            return (matchesQuery &&
                (!filters.city || consumer.city === filters.city) &&
                (!filters.sector || consumer.sector === filters.sector) &&
                (!filters.houseType || consumer.houseType === filters.houseType) &&
                (!filters.building || consumer.building === filters.building));
        });
    }
    getConsumer(id) {
        const consumer = this.consumers.find((item) => item.id === id);
        if (!consumer) {
            throw new common_1.NotFoundException(`Consumer ${id} not found`);
        }
        return consumer;
    }
    updateConsumer(id, dto) {
        const consumer = this.getConsumer(id);
        if (dto.name !== undefined) {
            consumer.name = dto.name;
        }
        if (dto.address !== undefined) {
            consumer.address = {
                ...consumer.address,
                ...dto.address,
            };
            consumer.city = dto.address.city ?? consumer.city;
            consumer.sector = dto.address.sector ?? consumer.sector;
            consumer.building = dto.address.buildingName ?? consumer.building;
            consumer.pincode = dto.address.pincode ?? consumer.pincode;
        }
        return consumer;
    }
    getServiceProviders(filters) {
        const query = filters.q?.trim().toLowerCase();
        const minRating = Number(filters.minRating ?? 0);
        return this.serviceProviders.filter((provider) => {
            const matchesQuery = !query ||
                provider.id.toLowerCase().includes(query) ||
                provider.name.toLowerCase().includes(query) ||
                provider.mobile.includes(query);
            return (matchesQuery &&
                (!filters.city || provider.city === filters.city) &&
                (!filters.category || provider.serviceType === filters.category) &&
                provider.rating >= minRating);
        });
    }
    getServiceProvider(id) {
        const provider = this.serviceProviders.find((item) => item.id === id);
        if (!provider) {
            throw new common_1.NotFoundException(`Service provider ${id} not found`);
        }
        return provider;
    }
    createServiceProvider(dto) {
        const provider = {
            id: this.nextId(this.serviceProviders, 'SP'),
            rating: dto.rating ?? 0,
            ...dto,
        };
        this.serviceProviders.push(provider);
        return provider;
    }
    getRequests(filters) {
        const query = filters.q?.trim().toLowerCase();
        return this.requests.filter((request) => {
            const matchesQuery = !query ||
                request.id.toLowerCase().includes(query) ||
                request.consumerName.toLowerCase().includes(query) ||
                request.mobile.includes(query) ||
                request.description.toLowerCase().includes(query);
            return (matchesQuery &&
                (!filters.status || request.status === filters.status) &&
                (!filters.category || request.category === filters.category));
        });
    }
    createRequest(dto) {
        const request = {
            id: this.nextId(this.requests, 'CR'),
            consumerId: dto.consumerId,
            consumerName: dto.consumerName,
            mobile: dto.mobile,
            category: dto.category,
            description: dto.description,
            date: new Date().toISOString().slice(0, 10),
            preferredDate: dto.preferredDate,
            status: 'Open',
            address: dto.address,
        };
        this.requests.unshift(request);
        return request;
    }
    updateRequestStatus(id, dto) {
        const request = this.requests.find((item) => item.id === id);
        if (!request) {
            throw new common_1.NotFoundException(`Request ${id} not found`);
        }
        request.status = dto.status;
        return request;
    }
    getProviderDashboard(id) {
        this.getServiceProvider(id);
        const providerRequests = this.requests.filter((request) => request.assignedProviderId === id);
        return {
            activeRequests: providerRequests.filter((request) => request.status !== 'Closed'),
            previousRequests: providerRequests.filter((request) => request.status === 'Closed'),
            feedback: this.feedback.filter((entry) => entry.serviceProviderId === id),
        };
    }
    createFeedback(dto) {
        this.getServiceProvider(dto.serviceProviderId);
        const entry = {
            id: this.nextId(this.feedback, 'FB'),
            requestId: dto.requestId,
            serviceProviderId: dto.serviceProviderId,
            message: dto.message,
            createdAt: new Date().toISOString(),
        };
        this.feedback.unshift(entry);
        return entry;
    }
    nextId(items, prefix) {
        const max = items.reduce((highest, item) => {
            const match = new RegExp(`^${prefix}(\\d+)$`).exec(item.id);
            const value = match ? Number(match[1]) : 0;
            return Math.max(highest, value);
        }, 0);
        return `${prefix}${String(max + 1).padStart(3, '0')}`;
    }
};
exports.AppService = AppService;
exports.AppService = AppService = __decorate([
    (0, common_1.Injectable)()
], AppService);
//# sourceMappingURL=app.service.js.map