//
//  CategoriesListView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import SwiftUI

struct CategoriesListView: View {
    @ObservedObject var viewModel : CategoriesListViewModel
    
    
    init(viewModel : CategoriesListViewModel){
        self.viewModel = viewModel
    }
    
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
                            viewModel.selectCategory(category)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
        }
        .navigationTitle("Categories")
        .navigationDestination(isPresented: $viewModel.isNavigationActive) {
            if let selectedCategory = viewModel.selectedCategory {
                ProductsListView(viewModel: ProductsListViewModel(apiService: viewModel.getAPIService(), cartViewModel: viewModel.getCartViewModel(), category: selectedCategory))
            }
        }.onAppear(){
            viewModel.resetSelectedCategory()
        }
        
    }
    
}






struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView(viewModel: CategoriesListViewModel(apiService: APIService(), cartViewModel: CartViewModel(apiService: APIService())))
            .previewLayout(.sizeThatFits)
        
    }
}
