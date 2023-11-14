//
//  CategoriesListView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//
//  Description: This file defines the CategoriesListView struct, which is a SwiftUI View
//  responsible for displaying a list of categories in a grid format. It allows users to select
//  a category and navigate to the corresponding products list.

import SwiftUI

// CategoriesListView displays the categories in a two-column grid.
struct CategoriesListView: View {
    @ObservedObject var viewModel: CategoriesListViewModel // ViewModel for managing category data.
    
    // Defines the layout for the grid. Two columns with equal spacing.
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        // A scrollable view containing a grid of categories.
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                // Iterates over the categories and creates a card view for each.
                ForEach(viewModel.categories) { category in
                    GeneralCardView(
                        generalItem: category,
                        onAddToCartClicked: { },
                        onCardClicked: {
                            viewModel.selectCategory(category) // Handles category selection.
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
        }
        
        .navigationTitle("Categories") // Sets the navigation bar title.
        
        // Navigation destination for when a category is selected.
        .navigationDestination(isPresented: $viewModel.isNavigationActive) {
            // Conditionally navigate to the products list view if a category is selected.
            if let selectedCategory = viewModel.selectedCategory {
                ProductsListView(viewModel: ProductsListViewModel(apiService: viewModel.getAPIService(), cartViewModel: viewModel.getCartViewModel(), category: selectedCategory))
            }
        }
        .refreshable {
            viewModel.loadCategories() // Refreshes the categories list.
        }
        .onAppear() {
            viewModel.resetSelectedCategory() // Reset selected category on view appearance.
        }
        
        // Alert for displaying error messages.
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
    }
}

// SwiftUI Preview Provider
struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView(viewModel: CategoriesListViewModel(apiService: APIService(), cartViewModel: CartViewModel(apiService: APIService())))
            .previewLayout(.sizeThatFits)
    }
}
