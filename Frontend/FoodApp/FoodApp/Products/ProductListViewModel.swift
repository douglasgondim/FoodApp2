//
//  ProductListViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import Foundation
import Combine
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [String] = ["fruits", "breakfast", "meal", "lunch", "dinner"]
    private var cancellables: Set<AnyCancellable> = []
    
    func onCartClicked(){
        
    }

    private var apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
        loadProducts(for: "Breakfast")
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

extension Product {
    func toGeneralItem() -> GeneralItem {
        return GeneralItem(
            thumbnail: self.productThumbnail,
            title: self.productName,
            price: self.price,
            showAddToCartButton: true,
            onAddToCartClick: nil,
            onCardClickAction: nil
        )
    }
}
