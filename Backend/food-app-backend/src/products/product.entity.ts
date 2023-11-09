import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn, Unique } from 'typeorm';
import { Category } from '../categories/category.entity';

@Entity()
@Unique(["productName", "categoryId"])
export class Product {
  @PrimaryGeneratedColumn()
  productId: number;

  @Column()
  productName: string;

  @Column({ type: 'text' })
  productThumbnail: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  price: number;


  @Column()
  categoryId: number;
  
  @ManyToOne(() => Category, category => category.products)
  @JoinColumn({ name: 'categoryId' }) 
  category: Category;

}