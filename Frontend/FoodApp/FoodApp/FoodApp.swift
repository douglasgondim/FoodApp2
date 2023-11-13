//
//  FoodAppApp.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import SwiftUI

@main
struct FoodApp: App {
    let persistenceController : PersistenceController
    let apiService : APIService
    let cartViewModel : CartViewModel
    
    init(){
        persistenceController = PersistenceController.shared
        apiService = APIService()
        cartViewModel = CartViewModel(apiService: apiService)
    }
    

    var body: some Scene {
        WindowGroup {
                ContentView(apiService: apiService, cartViewModel: cartViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
         
        }
    }
}
