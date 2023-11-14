import { Injectable, OnModuleInit, Logger, InternalServerErrorException } from '@nestjs/common';
import { CategoriesService } from 'src/categories/categories.service';
import { ProductsService } from 'src/products/products.service';

@Injectable()
export class DatabaseService implements OnModuleInit {
  private readonly logger = new Logger(CategoriesService.name);

  constructor(
    private readonly categoriesService: CategoriesService,
    private readonly productsService: ProductsService,
  ) { }

  // Only execute the first time the server is loaded and if the database is ot yet populated
  async onModuleInit(): Promise<void> {
    const isDatabaseInitialized = await this.categoriesService.isCategoriesPopulated()

    if (!isDatabaseInitialized) {
      await this.initializeDatabase();
    }
  }

  // Initialize database by downloading data from TheMealDB
  private async initializeDatabase(): Promise<void> {
    this.logger.log("Initializing Database.");
  
    try {
      const categories = await this.categoriesService.fetchAndSaveCategories();
  
      for (const category of categories) {
        try {
          await this.productsService.fetchAndSaveProductsByCategory(category);
        } catch (error) {
          this.logger.error(`Failed to fetch or save products for category ${category.categoryName}: ${error.message}`);
        }
      }
  
      this.logger.log("Database initialization complete.");
    } catch (error) {
      this.logger.error(`Failed to initialize the database: ${error.message}`);
      throw new InternalServerErrorException('Failed to initialize the database');
    }
  }
  
    // Delete everything from the database
  async clearDatabase(): Promise<void> {
    this.logger.log("Clearing Database.");
  
    try {
      await this.productsService.deleteAllProducts();
      await this.categoriesService.deleteAllCategories();
    } catch (error) {
      this.logger.error(`Failed to clear the database: ${error.message}`);
      throw new InternalServerErrorException('Failed to clear the database');
    }
  }
  
  // Delete everything from the database and then repopulate it
  async restartDatabase(): Promise<void> {
    try {
      await this.clearDatabase();
      await this.initializeDatabase();
    } catch (error) {
      this.logger.error(`Failed to restart the database: ${error.message}`);
      throw new InternalServerErrorException('Failed to restart the database');
    }
  }
  

}
