//
//  ProductListView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//
//  Description: This file contains the ProductsListView structure responsible for displaying a grid of products
//  within a specific category. It includes functionality for refreshing product lists and handling product selection.

import SwiftUI

// SwiftUI view for displaying a list of products.
struct ProductsListView: View {
    @ObservedObject var viewModel: ProductsListViewModel

    // Initializer for the view, taking a ProductsListViewModel instance.
    init(viewModel: ProductsListViewModel) {
        self.viewModel = viewModel
    }

    // Grid layout configuration for the product list.
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    // Main body of the view.
    var body: some View {
        ScrollView {
            // Grid for displaying product cards.
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.products) { product in
                    GeneralCardView(generalItem: product,
                                    onAddToCartClicked: {
                                        viewModel.addProductToCart(product)
                                    },
                                    onCardClicked: { }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        // Navigation title set to the current category name.
        .navigationTitle(viewModel.getCategoryName())
        // Refresh control for reloading products.
        .refreshable {
            viewModel.loadProducts(for: viewModel.getCategoryName())
        }
        // Error handling alert.
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "An error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        // Overlay for showing a confirmation message when a product is added to the cart.
        .overlay(
            Group {
                if viewModel.showConfirmation {
                    ConfirmationView()
                        .animation(.easeInOut, value: viewModel.showConfirmation)
                } else {
                    EmptyView()
                }
            }
        )
    }
}

// View for showing a confirmation message.
struct ConfirmationView: View {
    var body: some View {
        Text("Added to Cart")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(Color.green)
            .cornerRadius(25)
            .shadow(radius: 10)
            .transition(.scale)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.maxY - 280)
    }
}

// Preview provider for SwiftUI previews in Xcode.
struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView(
            viewModel: ProductsListViewModel(apiService: APIService(), cartViewModel: CartViewModel(apiService: APIService()),
                                             category: Category(
                                                categoryId: 1,
                                                categoryName: "Beef",
                                                categoryThumbnail: "",
                                                categoryDescription: ""
                                             )))
        .previewLayout(.sizeThatFits)
    }
}
