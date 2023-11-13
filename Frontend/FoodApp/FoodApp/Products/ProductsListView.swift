//
//  ProductListView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//


import SwiftUI

struct ProductsListView: View {
    @ObservedObject var viewModel: ProductsListViewModel
    
    init(viewModel : ProductsListViewModel) {
        self.viewModel = viewModel
    }
    
    
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        
        ScrollView {
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
        .navigationTitle(viewModel.getCategoryName())
        .refreshable {
            viewModel.loadProducts(for: viewModel.getCategoryName())
        }
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
        .overlay(
            Group{
                if viewModel.showConfirmation {
                    ConfirmationView()
                        .animation(.easeInOut, value: viewModel.showConfirmation)
                    
                }else{
                    EmptyView()
                }
            }
        )
    }
}



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
        //.padding()
    }
}


