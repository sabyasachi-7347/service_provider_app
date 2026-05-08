import { Type } from 'class-transformer';
import {
  IsDateString,
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';

export class LoginDto {
  @IsString()
  @IsNotEmpty()
  userId!: string;

  @IsString()
  @IsOptional()
  password?: string;
}

export class AddressDto {
  @IsString()
  @IsOptional()
  flatNo?: string;

  @IsString()
  @IsOptional()
  sector?: string;

  @IsString()
  @IsOptional()
  floor?: string;

  @IsString()
  @IsOptional()
  landmark?: string;

  @IsString()
  @IsOptional()
  area?: string;

  @IsString()
  @IsOptional()
  plot?: string;

  @IsString()
  @IsOptional()
  city?: string;

  @IsString()
  @IsOptional()
  buildingName?: string;

  @IsString()
  @IsOptional()
  pincode?: string;
}

export class UpdateConsumerDto {
  @IsString()
  @IsOptional()
  name?: string;

  @ValidateNested()
  @Type(() => AddressDto)
  @IsOptional()
  address?: AddressDto;
}

export class CreateProviderDto {
  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsString()
  @IsNotEmpty()
  mobile!: string;

  @IsString()
  @IsNotEmpty()
  serviceType!: string;

  @IsString()
  @IsNotEmpty()
  fullAddressLine!: string;

  @IsString()
  @IsNotEmpty()
  city!: string;

  @IsString()
  @IsNotEmpty()
  state!: string;

  @IsString()
  @IsNotEmpty()
  pincode!: string;

  @IsString()
  @IsNotEmpty()
  businessType!: string;

  @IsNumber()
  @Min(0)
  @IsOptional()
  rating?: number;
}

export class CreateRequestDto {
  @IsString()
  @IsNotEmpty()
  consumerId!: string;

  @IsString()
  @IsNotEmpty()
  consumerName!: string;

  @IsString()
  @IsNotEmpty()
  mobile!: string;

  @IsString()
  @IsNotEmpty()
  category!: string;

  @IsString()
  @IsNotEmpty()
  description!: string;

  @IsDateString()
  preferredDate!: string;

  @ValidateNested()
  @Type(() => AddressDto)
  address!: AddressDto;
}

export class UpdateRequestStatusDto {
  @IsIn(['Open', 'In Progress', 'Closed'])
  status!: 'Open' | 'In Progress' | 'Closed';
}

export class CreateFeedbackDto {
  @IsString()
  @IsNotEmpty()
  requestId!: string;

  @IsString()
  @IsNotEmpty()
  serviceProviderId!: string;

  @IsString()
  @IsNotEmpty()
  message!: string;
}
