//
//  ProductListView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//


import SwiftUI

struct ProductsListView: View {
    @StateObject var viewModel: ProductsListViewModel

    init(category: Category) {
        _viewModel = StateObject(wrappedValue: ProductsListViewModel(category: category))
    }

    var body: some View {
        ProductGridView(viewModel: viewModel)
    }
}


struct ProductGridView: View {
    @ObservedObject var viewModel: ProductsListViewModel
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.products) { product in
                    GeneralCardView(generalItem: product,
                    onAddToCartClicked: { },
                    onCardClicked: { }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            
        }
    }
}




struct ProductGridView_Previews: PreviewProvider {
    static var previews: some View {
        ProductGridView(viewModel: ProductsListViewModel(category: Category(
            categoryId: 1,
            categoryName: "Beef",
            categoryThumbnail: "String"
        )))
            .previewLayout(.sizeThatFits)
        //.padding()
    }
}


