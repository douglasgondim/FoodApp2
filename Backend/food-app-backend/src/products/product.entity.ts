import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Product {
  @PrimaryGeneratedColumn()
  categoryId: number;

  @Column()
  categoryName: string;

  @Column({ type: 'text' })
  categoryThumbnail: string;

  @Column({ type: 'text' })
  categoryDescription: string;
}