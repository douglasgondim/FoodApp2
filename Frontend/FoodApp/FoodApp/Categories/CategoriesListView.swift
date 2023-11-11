//
//  CategoriesListView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import SwiftUI

struct CategoriesListView: View {
    @StateObject var viewModel = CategoriesListViewModel(apiService: APIService())
    var body: some View {
        CategoriesGridView(viewModel: viewModel)
    }
}



struct CategoriesGridView: View {
    @ObservedObject var viewModel: CategoriesListViewModel
    @State private var isNavigationActive: Bool = false
    @State private var selectedCategory: Category?
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.categories) { category in
                    GeneralCardView(
                        generalItem: category,
                        onAddToCartClicked: { },
                        onCardClicked: {
                            selectedCategory = category
                            isNavigationActive = true
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
        }
        .navigationTitle("Categories")
        .navigationDestination(isPresented: $isNavigationActive) {
            // Check if selectedCategory is not nil before navigating
            if let selectedCategory = selectedCategory {
                ProductsListView(category: selectedCategory)
            }
        }.onAppear(){
            selectedCategory = nil
            isNavigationActive = false
        }
        
    }
}


struct CategoriesGridView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesGridView(viewModel: CategoriesListViewModel(apiService: APIService()))
            .previewLayout(.sizeThatFits)
        
    }
}
