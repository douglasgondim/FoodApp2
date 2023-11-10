import { ValueTransformer } from 'typeorm';

export class DecimalTransformer implements ValueTransformer {
  from(value: string): number {
    return parseFloat(value);
  }
  
  to(value: number): string {
    return value.toString();
  }
}