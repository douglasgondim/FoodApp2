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
            CartTabView(cartViewModel: cartViewModel)
        }.onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct CartTabView: View {
    @ObservedObject var cartViewModel: CartViewModel

    var body: some View {
        NavigationStack {
            CartView(viewModel: cartViewModel)
                .navigationTitle("Cart")
        } .tabItem {
            Image(systemName: "cart")
            Text("Cart")
        }.badge(cartViewModel.totalItemCount)
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let apiService = APIService()
        ContentView(apiService: apiService, cartViewModel: CartViewModel(apiService: apiService))
    }
}
