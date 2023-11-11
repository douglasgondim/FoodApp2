//
//  CartView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        
        VStack {
            if viewModel.isCartEmpty(){
                Spacer()
                Text("Your cart is empty.")
                    .font(.headline)
                    .padding()
                Spacer()
            }else{
                
                List {
                    Section(header: Color.clear.frame(height:0)) {
                        ForEach(viewModel.items) { item in
                            HStack {
                                AsyncImage(url: URL(string: item.product.productThumbnail))
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                VStack(alignment: .leading) {
                                    Text(item.product.productName)
                                        .font(.headline)
                                    Text("$\(item.product.productPrice, specifier: "%.2f") x \(item.quantity)")
                                        .font(.subheadline)
                                        .frame(minWidth: 85, alignment: .leading)
                                        .monospaced()
                                        .padding(.top, 1)
                                    
                                }
                                .frame(width: 100)
                                
                                
                                Spacer()
                                
                                QuantityAdjustmentView(viewModel: viewModel, item: item)
                            }
                        }
                    }
                }
            }
            
            
            TotalAndCheckoutView(total: viewModel.total, isCheckoutEnabled: !viewModel.isCartEmpty())
                .padding(.horizontal)
                .padding(.vertical, 10)
            
        }
        //        .background(Color(UIColor.secondarySystemBackground))
        
        //        .navigationBarTitle("Cart", displayMode: .)
    }
}

struct QuantityAdjustmentView: View {
    @ObservedObject var viewModel: CartViewModel
    let item: CartItem
    
    var body: some View {
        HStack {
            // Minus Button
            Spacer()
            Button(action: { viewModel.decreaseQuantity(of: item) }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 8)
            
            // Quantity Text
            Text("\(item.quantity)")
                .frame(minWidth: 36)
                .padding(.horizontal, 4)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
                .monospaced()
            
            // Plus Button
            Button(action: { viewModel.increaseQuantity(of: item) }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
            .padding(.leading, 8)
            
            Spacer()
            Spacer()
            
            // Delete Button
            Button(action: { viewModel.deleteItem(item) }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4) // Add some vertical padding for tappability
        .buttonStyle(BorderlessButtonStyle()) // Ensure the button area is limited to its content
    }
}


struct TotalAndCheckoutView: View {
    let total: Double
    let isCheckoutEnabled : Bool
    
    var body: some View {
        HStack {
            // Total Price
            VStack(alignment: .leading){
                Text("Total:")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("$\(total, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .monospaced()
                    .padding(.top, 1)
            }
            
            Spacer()
            
            // Checkout Button
            Button(action: {
                // Implement checkout action
            }) {
                Text("Checkout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(isCheckoutEnabled ? Color.blue : Color.gray)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
            .disabled(true)
            .opacity(isCheckoutEnabled ? 1 : 0.5)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        
    }
}



struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: CartViewModel())
    }
}

