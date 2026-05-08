export declare class LoginDto {
    userId: string;
    password?: string;
}
export declare class AddressDto {
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
export declare class UpdateConsumerDto {
    name?: string;
    address?: AddressDto;
}
export declare class CreateProviderDto {
    name: string;
    mobile: string;
    serviceType: string;
    fullAddressLine: string;
    city: string;
    state: string;
    pincode: string;
    businessType: string;
    rating?: number;
}
export declare class CreateRequestDto {
    consumerId: string;
    consumerName: string;
    mobile: string;
    category: string;
    description: string;
    preferredDate: string;
    address: AddressDto;
}
export declare class UpdateRequestStatusDto {
    status: 'Open' | 'In Progress' | 'Closed';
}
export declare class CreateFeedbackDto {
    requestId: string;
    serviceProviderId: string;
    message: string;
}
