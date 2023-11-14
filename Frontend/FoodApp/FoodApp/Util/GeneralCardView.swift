//
//  GeneralCardView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//
//  Description: This file defines the GeneralCardView struct, a reusable SwiftUI View for
//  displaying general items like categories and products in card format. It supports interaction
//  like adding to cart and clicking on the card.

import SwiftUI

// Protocol defining the necessary properties for an item to be displayed in GeneralCardView.
protocol GeneralItemProtocol: Identifiable {
    var id: Int { get }
    var thumbnail: String { get }
    var title: String { get }
}

// The view that represents a general item (category or product) as a card.
struct GeneralCardView: View {
    let generalItem: any GeneralItemProtocol // The item to be displayed.
    let onAddToCartClicked: () -> Void // Closure to handle add to cart action.
    let onCardClicked: () -> Void // Closure to handle card click action.
    @State private var isTapped: Bool = false // State to manage tap interaction.
    
    var body: some View {
        VStack {
            // Asynchronous image loading.
            AsyncImage(url: URL(string: generalItem.thumbnail)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 36))
                    
                default:
                    ProgressView() // Shown while loading or for empty URL.
                }
            }
            .frame(width: 100, height: 100)
            .cornerRadius(8)
            
            // Title of the item.
            Text(generalItem.title)
                .font(.headline)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(height: 70)
                .foregroundStyle(.foreground)
            
            // Display product-specific details if the item is a product.
            if let product = generalItem as? Product {
                Text("$\(product.productPrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(Color("GeneralCardPrice"))
                    .frame(height: 20)
                    .padding(.bottom, 5)
                
                // Add to cart button.
                Button(action: onAddToCartClicked) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Add to Cart")
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .font(.system(size: 10))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.33, height: ((generalItem as? Product) != nil) ? 270 : 200)
        .padding()
        .background(Color("GeneralCardBackground"))
        .cornerRadius(10)
        .shadow(radius: 5)
        
        .opacity(isTapped ? 0.5 : 1.0)
        .onTapGesture {
            if(generalItem as? Category != nil){
                isTapped = true
                onCardClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isTapped = false
                }
            }
        }
    }
}

// SwiftUI Preview Provider for GeneralCardView.
struct GeneralCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            // Category card preview.
            GeneralCardView(generalItem: Category(
                categoryId: 124,
                categoryName: "Miscellaneous",
                categoryThumbnail: "https://www.themealdb.com/images/category/miscellaneous.png",
                categoryDescription: "General foods that don't fit into another category"
            ),
            onAddToCartClicked: {},
            onCardClicked: {}
            )
            .previewLayout(.sizeThatFits)
            
            // Product card preview.
            GeneralCardView(generalItem: Product(
                productId: 2581,
                productName: "Duck Confit",
                productThumbnail: "https://www.themealdb.com/images/media/meals/wvpvsu1511786158.jpg",
                productPrice: 0.99
            ),
            onAddToCartClicked: {},
            onCardClicked: {})
            .previewLayout(.sizeThatFits)
        }
    }
}
