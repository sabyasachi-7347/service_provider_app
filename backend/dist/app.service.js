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
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppService = void 0;
const common_1 = require("@nestjs/common");
const firebase_service_1 = require("./firebase.service");
let AppService = class AppService {
    constructor(firebaseService) {
        this.firebaseService = firebaseService;
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
            {
                id: 'C001',
                name: 'Amit Sharma',
                mobile: '9876543210',
                city: 'Delhi',
                sector: '15',
                houseType: 'Apartment',
                building: 'Tower A',
                pincode: '110001',
                isAmcActive: true,
                address: {
                    flatNo: '1202',
                    sector: '15',
                    floor: '12',
                    landmark: 'Near Central Park',
                    area: 'Rohini',
                    plot: 'A-21',
                    city: 'Delhi',
                    buildingName: 'Tower A',
                    pincode: '110001',
                },
                assets: [
                    {
                        id: 'AS001',
                        name: 'Split AC',
                        category: 'Appliance',
                        subCategory: 'AC Service',
                        warrantyStart: '2025-01-01',
                        warrantyEnd: '2026-01-01',
                        warrantyStatus: 'Active',
                        lastServiceDate: '2025-07-01',
                        serviceDueDate: '2025-10-01',
                        location: 'Bedroom',
                        billImage: null,
                    },
                ],
                familyMembers: [
                    {
                        name: 'Riya Sharma',
                        mobile: '9876500000',
                        dob: '1998-03-20',
                        age: 27,
                        healthInsurance: 'HDFC Health',
                        insuranceExpiry: '2026-03-20',
                    },
                ],
                vehicles: [
                    {
                        number: 'DL01AB1234',
                        owner: 'Amit Sharma',
                        insurance: 'POL12345',
                        insuranceExpiry: '2026-05-01',
                        insuranceStatus: 'Valid',
                        puc: 'PUC12345',
                        pucExpiry: '2025-11-01',
                        pucStatus: 'Valid',
                        fines: 'None',
                    },
                ],
            },
            {
                id: 'C002',
                name: 'Priya Singh',
                mobile: '9123456789',
                city: 'Delhi',
                sector: '20',
                houseType: 'Villa',
                building: 'Green Villa',
                pincode: '110003',
                isAmcActive: false,
                address: {
                    flatNo: '22',
                    sector: '20',
                    landmark: 'Near Market',
                    area: 'Dwarka',
                    city: 'Delhi',
                    buildingName: 'Green Villa',
                    pincode: '110003',
                },
                assets: [],
                familyMembers: [],
                vehicles: [],
            },
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
    async login(dto) {
        const users = await this.getCollection('users');
        const user = users.find((item) => item.userId === dto.userId.trim());
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
    async getAdminSummary() {
        const [consumers, serviceProviders, requests] = await Promise.all([
            this.getCollection('consumers'),
            this.getCollection('serviceProviders'),
            this.getCollection('requests'),
        ]);
        return {
            consumers: consumers.length,
            serviceProviders: serviceProviders.length,
            openRequests: requests.filter((item) => item.status !== 'Closed').length,
            activeAmcConsumers: consumers.filter((item) => item.isAmcActive).length,
        };
    }
    async getConsumers(filters) {
        const consumers = await this.getCollection('consumers');
        const query = filters.q?.trim().toLowerCase();
        return consumers.filter((consumer) => {
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
    async getConsumer(id) {
        const consumer = await this.getDocument('consumers', id);
        if (!consumer) {
            throw new common_1.NotFoundException(`Consumer ${id} not found`);
        }
        return consumer;
    }
    async updateConsumer(id, dto) {
        const consumer = await this.getConsumer(id);
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
        await this.saveDocument('consumers', id, consumer);
        return consumer;
    }
    async getServiceProviders(filters) {
        const serviceProviders = await this.getCollection('serviceProviders');
        const query = filters.q?.trim().toLowerCase();
        const minRating = Number(filters.minRating ?? 0);
        return serviceProviders.filter((provider) => {
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
    async getServiceProvider(id) {
        const provider = await this.getDocument('serviceProviders', id);
        if (!provider) {
            throw new common_1.NotFoundException(`Service provider ${id} not found`);
        }
        return provider;
    }
    async createServiceProvider(dto) {
        const provider = {
            id: await this.nextFirestoreId('serviceProviders', 'SP'),
            rating: dto.rating ?? 0,
            ...dto,
        };
        await this.saveDocument('serviceProviders', provider.id, provider);
        return provider;
    }
    async getRequests(filters) {
        const requests = await this.getCollection('requests');
        const query = filters.q?.trim().toLowerCase();
        return requests.filter((request) => {
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
    async createRequest(dto) {
        const request = {
            id: await this.nextFirestoreId('requests', 'CR'),
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
        await this.saveDocument('requests', request.id, request);
        return request;
    }
    async updateRequestStatus(id, dto) {
        const request = await this.getDocument('requests', id);
        if (!request) {
            throw new common_1.NotFoundException(`Request ${id} not found`);
        }
        request.status = dto.status;
        await this.saveDocument('requests', id, request);
        return request;
    }
    async getProviderDashboard(id) {
        await this.getServiceProvider(id);
        const [requests, feedback] = await Promise.all([
            this.getCollection('requests'),
            this.getCollection('feedback'),
        ]);
        const providerRequests = requests.filter((request) => request.assignedProviderId === id);
        return {
            activeRequests: providerRequests.filter((request) => request.status !== 'Closed'),
            previousRequests: providerRequests.filter((request) => request.status === 'Closed'),
            feedback: feedback.filter((entry) => entry.serviceProviderId === id),
        };
    }
    async createFeedback(dto) {
        await this.getServiceProvider(dto.serviceProviderId);
        const entry = {
            id: await this.nextFirestoreId('feedback', 'FB'),
            requestId: dto.requestId,
            serviceProviderId: dto.serviceProviderId,
            message: dto.message,
            createdAt: new Date().toISOString(),
        };
        await this.saveDocument('feedback', entry.id, entry);
        return entry;
    }
    async ensureSeeded() {
        if (!this.seedPromise) {
            this.seedPromise = this.seedDatabase();
        }
        await this.seedPromise;
    }
    async seedDatabase() {
        await Promise.all([
            this.seedCollection('users', this.users),
            this.seedCollection('consumers', this.consumers),
            this.seedCollection('serviceProviders', this.serviceProviders),
            this.seedCollection('requests', this.requests),
            this.seedCollection('feedback', this.feedback),
        ]);
    }
    async seedCollection(name, items) {
        const collection = this.firebaseService.db.collection(name);
        const existing = await collection.limit(1).get();
        if (!existing.empty) {
            return;
        }
        const batch = this.firebaseService.db.batch();
        for (const item of items) {
            batch.set(collection.doc(item.id), item);
        }
        await batch.commit();
    }
    async getCollection(name) {
        await this.ensureSeeded();
        const snapshot = await this.firebaseService.db.collection(name).get();
        return snapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data(),
        }));
    }
    async getDocument(collectionName, id) {
        await this.ensureSeeded();
        const snapshot = await this.firebaseService.db
            .collection(collectionName)
            .doc(id)
            .get();
        if (!snapshot.exists) {
            return null;
        }
        return {
            id: snapshot.id,
            ...snapshot.data(),
        };
    }
    async saveDocument(collectionName, id, data) {
        await this.ensureSeeded();
        await this.firebaseService.db.collection(collectionName).doc(id).set(data);
    }
    async nextFirestoreId(collectionName, prefix) {
        const items = await this.getCollection(collectionName);
        return this.nextId(items, prefix);
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
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [firebase_service_1.FirebaseService])
], AppService);
//# sourceMappingURL=app.service.js.map