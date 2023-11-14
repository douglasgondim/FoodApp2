//
//  FoodAppApp.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import SwiftUI
import Stripe

@main
struct FoodApp: App {
    let apiService : APIService
    let cartViewModel : CartViewModel
    
    init(){
        STPAPIClient.shared.publishableKey = "YOUR_STRIPE_API_TEST_KEY_HERE"


        apiService = APIService()
        cartViewModel = CartViewModel(apiService: apiService)
    }
    

    var body: some Scene {
        WindowGroup {
                ContentView(apiService: apiService, cartViewModel: cartViewModel)

         
        }
    }
}

