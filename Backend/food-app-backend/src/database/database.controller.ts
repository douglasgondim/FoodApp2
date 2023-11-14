import { Controller, Post, HttpCode, HttpStatus, Delete } from '@nestjs/common';
import { DatabaseService } from './database.service';

@Controller('database')
export class DatabaseController {
  constructor(private readonly databaseService: DatabaseService) {}

  @Post('/restart')
  @HttpCode(HttpStatus.OK)
  async restartDatabase(): Promise<{ message: string }> {
    await this.databaseService.restartDatabase();
    return { message: 'Database restart successful.' };
  }

  @Delete('/clear')
  @HttpCode(HttpStatus.OK)
  async clearDatabase(): Promise<{ message: string }> {
    await this.databaseService.clearDatabase();
    return { message: 'Database clear successful.' };
  }
}
