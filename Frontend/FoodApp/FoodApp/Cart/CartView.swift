//
//  CartView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//
//  Description: This view displays the user's shopping cart and provides options for adjusting quantities and checking out.

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: CartViewModel  // ViewModel providing data and logic for the cart
    
    var body: some View {
        
        VStack {
            // Check if the cart is empty and display message if it is
            if viewModel.isCartEmpty() {
                Spacer()
                Text("Your cart is empty.")
                    .font(.headline)
                    .padding()
                Spacer()
            } else {
                // Display list of cart items
                List {
                    Section(header: Color.clear.frame(height: 0)) {
                        ForEach(viewModel.cartItems) { item in
                            HStack {
                                // Item image
                                AsyncImage(url: URL(string: item.product.productThumbnail))
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                // Item details
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
                                
                                // Quantity adjustment view
                                QuantityAdjustmentView(viewModel: viewModel, item: item)
                            }
                        }
                    }
                }
            }
            
            // Total and checkout view
            TotalAndCheckoutView(viewModel: viewModel)
                .padding(.horizontal)
                .padding(.vertical, 10)
        }
        .navigationDestination(isPresented: $viewModel.isNavigationActive) {
            // Navigate to payment view on checkout
            PaymentView(viewModel: PaymentViewModel(apiService: APIService(), cartViewModel: viewModel))
        }
        .onAppear() {
            // Hide payment view on appearance
            viewModel.hidePaymentView()
        }
    }
}

// Component for adjusting item quantity in the cart
struct QuantityAdjustmentView: View {
    @ObservedObject var viewModel: CartViewModel
    let item: CartItem  // The specific cart item
    
    var body: some View {
        HStack {
            // Decrease quantity button
            Spacer()
            Button(action: { viewModel.decreaseQuantity(of: item) }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 8)
            
            // Display item quantity
            Text("\(item.quantity)")
                .frame(minWidth: 36)
                .padding(.horizontal, 4)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
                .monospaced()
            
            // Increase quantity button
            Button(action: { viewModel.increaseQuantity(of: item) }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
            .padding(.leading, 8)
            
            Spacer()
            Spacer()
            
            // Delete item button
            Button(action: { viewModel.deleteItem(item) }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
        .buttonStyle(BorderlessButtonStyle())
        .onAppear() {
            // Reset cart if it has been paid for
            if viewModel.cartHasBeenPaidFor {
                viewModel.resetCart()
            }
        }
    }
}

// Component for displaying total amount and checkout button
struct TotalAndCheckoutView: View {
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        HStack {
            // Display total price
            VStack(alignment: .leading) {
                Text("Total:")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("$\(viewModel.total, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .monospaced()
                    .padding(.top, 1)
            }
            
            Spacer()
            
            // Checkout button
            Button(action: {
                viewModel.showPaymentView()
            }) {
                Text("Checkout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(viewModel.isCartEmpty() ? Color.gray : Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
            .opacity(viewModel.isCartEmpty() ? 0.5 : 1)
            .disabled(viewModel.isCartEmpty())
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Preview provider for CartView
struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: CartViewModel(apiService: APIService()))
    }
}
