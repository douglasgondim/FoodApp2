//
//  CategoriesViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//


import Foundation
import Combine

class CategoriesListViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func onCardClicked(){
        
    }
    
    private var apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
        loadCategories()
    }
    
    
    func loadCategories() {
        apiService.fetchCategories()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] categories in
                self?.categories = categories
            })
            .store(in: &cancellables)
    }
}
