import { Entity, Column, PrimaryGeneratedColumn, Unique, OneToMany } from 'typeorm';
import { Product } from '../products/product.entity';

@Entity()
@Unique(["categoryName"])

export class Category {
  @PrimaryGeneratedColumn()
  categoryId: number;

  @Column()
  categoryName: string;

  @Column({ type: 'text' })
  categoryThumbnail: string;

  @Column({ type: 'text' })
  categoryDescription: string;

  @OneToMany(() => Product, product => product.category)
  products: Product[];
}