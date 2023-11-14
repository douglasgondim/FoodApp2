//
//  ContentView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//
//  Description: The main content view of the app, acting as the root view. It contains a tab view for navigating between the categories and cart sections.

import SwiftUI
import CoreData

struct ContentView: View {
    var apiService : APIService  // API service instance for network calls
    let cartViewModel : CartViewModel  // ViewModel for managing cart data

    var body: some View {
        TabView {
            // Categories Tab - displays a list of categories
            NavigationStack {
                CategoriesListView(viewModel : CategoriesListViewModel(apiService: apiService, cartViewModel: cartViewModel))
                    .navigationTitle("Categories")  // Title for the navigation bar
            }
            .tabItem {
                Image(systemName: "list.dash")  // Tab icon
                Text("Categories")  // Tab title
            }
            
            // Cart Tab - displays the user's shopping cart
            CartTabView(cartViewModel: cartViewModel)
        }
        .onAppear {
            // iOS 15 appearance fix for TabView
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

// View for the Cart tab, displaying the cart contents and a badge with the total item count
struct CartTabView: View {
    @ObservedObject var cartViewModel: CartViewModel  // ViewModel for cart data

    var body: some View {
        NavigationStack {
            CartView(viewModel: cartViewModel)
                .navigationTitle("Cart")  // Title for the navigation bar
        }
        .tabItem {
            Image(systemName: "cart")  // Tab icon
            Text("Cart")  // Tab title
        }
        .badge(cartViewModel.totalItemCount)  // Badge showing the total number of items in the cart
    }
}

// Previews for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Creating instances for the preview
        let apiService = APIService()
        ContentView(apiService: apiService, cartViewModel: CartViewModel(apiService: apiService))
    }
}
