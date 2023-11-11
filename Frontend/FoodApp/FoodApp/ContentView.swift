//
//  ContentView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var apiService : APIService
    let cartViewModel : CartViewModel
    
    init(){
        apiService = APIService()
        cartViewModel = CartViewModel(apiService: apiService)
    }

   
    
    var body: some View {
        TabView {
            // Categories Tab
            NavigationStack {
                CategoriesListView(viewModel : CategoriesListViewModel(apiService: apiService, cartViewModel: cartViewModel))
                    .navigationTitle("Categories")
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Categories")
            }
            
            // Cart Tab
            NavigationStack {
                CartView(viewModel: cartViewModel)
                    .navigationTitle("Cart")
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Cart")
            }
        }.onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
