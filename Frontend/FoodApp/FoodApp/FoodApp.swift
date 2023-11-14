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
        STPAPIClient.shared.publishableKey = "pk_test_51OBU7EFQKJ0M0HiOX0I2mdZe49NYB64rFB60IAj3oIUVQziqIGbTeHpzjaK8h5FtoJNxhvx5xqI6gUh2CWDKkPfQ00Lhf7yUEl"


        apiService = APIService()
        cartViewModel = CartViewModel(apiService: apiService)
    }
    

    var body: some Scene {
        WindowGroup {
                ContentView(apiService: apiService, cartViewModel: cartViewModel)

         
        }
    }
}

