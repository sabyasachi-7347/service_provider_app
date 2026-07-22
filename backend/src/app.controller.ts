import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { AppService } from './app.service';
import {
  CreateConsumerDto,
  CreateFeedbackDto,
  CreateProviderDto,
  CreateRequestDto,
  LoginDto,
  UpdateConsumerDto,
  UpdateRequestStatusDto,
} from './dto';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('health')
  health() {
    return { status: 'ok' };
  }

  @Post('auth/login')
  login(@Body() body: LoginDto) {
    return this.appService.login(body);
  }

  @Get('metadata')
  metadata() {
    return this.appService.getMetadata();
  }

  @Get('admin/summary')
  adminSummary() {
    return this.appService.getAdminSummary();
  }

  @Get('consumers')
  consumers(
    @Query('city') city?: string,
    @Query('sector') sector?: string,
    @Query('houseType') houseType?: string,
    @Query('building') building?: string,
    @Query('q') q?: string,
  ) {
    return this.appService.getConsumers({ city, sector, houseType, building, q });
  }

  @Post('consumers')
  createConsumer(@Body() body: CreateConsumerDto) {
    return this.appService.createConsumer(body);
  }

  @Get('consumers/:id')
  consumer(@Param('id') id: string) {
    return this.appService.getConsumer(id);
  }

  @Patch('consumers/:id')
  updateConsumer(@Param('id') id: string, @Body() body: UpdateConsumerDto) {
    return this.appService.updateConsumer(id, body);
  }

  @Get('service-providers')
  serviceProviders(
    @Query('city') city?: string,
    @Query('category') category?: string,
    @Query('minRating') minRating?: string,
    @Query('q') q?: string,
  ) {
    return this.appService.getServiceProviders({ city, category, minRating, q });
  }

  @Post('service-providers')
  createServiceProvider(@Body() body: CreateProviderDto) {
    return this.appService.createServiceProvider(body);
  }

  @Get('service-providers/:id')
  serviceProvider(@Param('id') id: string) {
    return this.appService.getServiceProvider(id);
  }

  @Get('service-providers/:id/dashboard')
  serviceProviderDashboard(@Param('id') id: string) {
    return this.appService.getProviderDashboard(id);
  }

  @Get('requests')
  requests(
    @Query('status') status?: 'Open' | 'In Progress' | 'Closed',
    @Query('category') category?: string,
    @Query('q') q?: string,
  ) {
    return this.appService.getRequests({ status, category, q });
  }

  @Post('requests')
  createRequest(@Body() body: CreateRequestDto) {
    return this.appService.createRequest(body);
  }

  @Patch('requests/:id/status')
  updateRequestStatus(
    @Param('id') id: string,
    @Body() body: UpdateRequestStatusDto,
  ) {
    return this.appService.updateRequestStatus(id, body);
  }

  @Post('feedback')
  createFeedback(@Body() body: CreateFeedbackDto) {
    return this.appService.createFeedback(body);
  }
}
