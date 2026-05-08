import { CreateFeedbackDto, CreateProviderDto, CreateRequestDto, LoginDto, UpdateConsumerDto, UpdateRequestStatusDto } from './dto';
type Role = 'admin' | 'service_provider' | 'consumer';
type RequestStatus = 'Open' | 'In Progress' | 'Closed';
interface Address {
    flatNo?: string;
    sector?: string;
    floor?: string;
    landmark?: string;
    area?: string;
    plot?: string;
    city?: string;
    buildingName?: string;
    pincode?: string;
}
interface Asset {
    id: string;
    name: string;
    category: string;
    subCategory: string;
    warrantyStart: string;
    warrantyEnd: string;
    warrantyStatus: string;
    lastServiceDate: string;
    serviceDueDate: string;
    location: string;
    billImage?: string | null;
}
interface FamilyMember {
    name: string;
    mobile: string;
    dob: string;
    age: number;
    healthInsurance: string;
    insuranceExpiry: string;
}
interface Vehicle {
    number: string;
    owner: string;
    insurance: string;
    insuranceExpiry: string;
    insuranceStatus: string;
    puc: string;
    pucExpiry: string;
    pucStatus: string;
    fines: string;
}
interface Consumer {
    id: string;
    name: string;
    mobile: string;
    city: string;
    sector: string;
    houseType: string;
    building: string;
    pincode: string;
    isAmcActive: boolean;
    address: Address;
    assets: Asset[];
    familyMembers: FamilyMember[];
    vehicles: Vehicle[];
}
interface ServiceProvider {
    id: string;
    name: string;
    mobile: string;
    serviceType: string;
    fullAddressLine: string;
    city: string;
    state: string;
    pincode: string;
    businessType: string;
    rating: number;
}
interface ServiceRequest {
    id: string;
    consumerId: string;
    consumerName: string;
    mobile: string;
    category: string;
    description: string;
    date: string;
    preferredDate?: string;
    status: RequestStatus;
    assignedProviderId?: string;
    address?: Address;
}
interface FeedbackEntry {
    id: string;
    requestId: string;
    serviceProviderId: string;
    message: string;
    createdAt: string;
}
interface AuthUser {
    id: string;
    userId: string;
    name: string;
    role: Role;
}
export declare class AppService {
    private readonly serviceCategories;
    private readonly businessTypes;
    private readonly users;
    private consumers;
    private serviceProviders;
    private requests;
    private feedback;
    login(dto: LoginDto): {
        token: string;
        user: AuthUser;
    };
    getMetadata(): {
        serviceCategories: string[];
        businessTypes: string[];
        requestStatuses: string[];
    };
    getAdminSummary(): {
        consumers: number;
        serviceProviders: number;
        openRequests: number;
        activeAmcConsumers: number;
    };
    getConsumers(filters: {
        city?: string;
        sector?: string;
        houseType?: string;
        building?: string;
        q?: string;
    }): Consumer[];
    getConsumer(id: string): Consumer;
    updateConsumer(id: string, dto: UpdateConsumerDto): Consumer;
    getServiceProviders(filters: {
        city?: string;
        category?: string;
        minRating?: string;
        q?: string;
    }): ServiceProvider[];
    getServiceProvider(id: string): ServiceProvider;
    createServiceProvider(dto: CreateProviderDto): ServiceProvider;
    getRequests(filters: {
        status?: RequestStatus;
        category?: string;
        q?: string;
    }): ServiceRequest[];
    createRequest(dto: CreateRequestDto): ServiceRequest;
    updateRequestStatus(id: string, dto: UpdateRequestStatusDto): ServiceRequest;
    getProviderDashboard(id: string): {
        activeRequests: ServiceRequest[];
        previousRequests: ServiceRequest[];
        feedback: FeedbackEntry[];
    };
    createFeedback(dto: CreateFeedbackDto): FeedbackEntry;
    private nextId;
}
export {};
