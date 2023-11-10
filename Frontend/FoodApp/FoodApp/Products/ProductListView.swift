//
//  ProductListView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//


import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel = ProductListViewModel(apiService: APIService())
    var body: some View {
        ProductGridView(viewModel: viewModel)
    }
}



struct ProductGridView: View {
    @ObservedObject var viewModel: ProductListViewModel
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.products) { product in
                    GeneralCardView(generalItem: product.toGeneralItem())
                }
            }
            .padding(.horizontal)
            
        }
    }
}




struct ProductGridView_Previews: PreviewProvider {
    static var previews: some View {
        ProductGridView(viewModel: ProductListViewModel(apiService: APIService()))
            .previewLayout(.sizeThatFits)
        //.padding()
    }
}


