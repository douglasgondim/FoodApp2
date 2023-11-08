import { Entity, Column, PrimaryGeneratedColumn, Unique } from 'typeorm';

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
}