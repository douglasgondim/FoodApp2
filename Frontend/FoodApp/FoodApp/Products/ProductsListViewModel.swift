//
//  ProductListViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import Foundation
import Combine
class ProductsListViewModel: ObservableObject {
    @Published var products: [Product] = []
    var addProductToCartPublisher = PassthroughSubject<Product, Never>()

    private var cancellables: Set<AnyCancellable> = []
    private var apiService = APIService()
    private var category : Category

    init(category : Category) {
        self.category = category
        loadProducts(for: category.categoryName)
    }
    
    func addToCart(product: Product) {
           addProductToCartPublisher.send(product)
       }

    func loadProducts(for category: String) {
        apiService.fetchProductsForCategory(for: category)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }
}

//extension Product {
//    func toGeneralItem(onAddToCartClick: @escaping () -> Void) -> GeneralItem {
//        return GeneralItem(
//            thumbnail: self.productThumbnail,
//            title: self.productName,
//            price: self.price,
//            showAddToCartButton: true,
//            onAddToCartClick: onAddToCartClick,
//            onCardClickAction: nil
//        )
//    }
//}
