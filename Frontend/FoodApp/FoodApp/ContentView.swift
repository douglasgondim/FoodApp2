//
//  ContentView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                ProductListView()
                    .navigationTitle("Products")
                    .navigationBarItems(leading: MenuButton())
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Products")
            }
            
            CartView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
        }
    }
}
struct MenuView: View {
    var body: some View {
        List {
            Text("Pork")
            Text("Beef")
            Text("Lamb")
  
        }
    }
}
struct MenuButton: View {
    @State var isShowingMenu = false
    
    var body: some View {
        Button(action: {
            isShowingMenu.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
        }
        .sheet(isPresented: $isShowingMenu) {
            MenuView() 
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
        // .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
