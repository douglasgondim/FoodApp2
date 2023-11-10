//
//  GeneralCardView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import SwiftUI

struct GeneralItem {
    let thumbnail : String
    let title : String
    let price : Double?
    let showAddToCartButton : Bool
    let onAddToCartClick : (() -> Void)?
    let onCardClickAction : (() -> Void)?
}

struct GeneralCardView: View {
    let generalItem: GeneralItem
    
    func addToCart(){
        
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: generalItem.thumbnail)) { phase in
                if let image = phase.image {
                    image.resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                } else if phase.error != nil {
                    Color.red
                } else {
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
            .cornerRadius(8)
            .background(Color.gray.opacity(0.3))
            

            Text(generalItem.title)
                .font(.headline)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(height: 70)
                .background(Color.white)
            

            
            if generalItem.price != nil{
                Text("$\(generalItem.price!, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 20)
            }
            
            if generalItem.showAddToCartButton {
                Button(action: addToCart) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Add to Cart")
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .font(.system(size: 10))
                        //.minimumScaleFactor(0.5)
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
        .frame(width: UIScreen.main.bounds.width * 0.33, height: generalItem.showAddToCartButton ? 270 : 200) 
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        
    }
}


struct GeneralCardView_Previews: PreviewProvider {

    static var previews: some View {
        Group{
            // Category card preview
            GeneralCardView(generalItem: GeneralItem(
                thumbnail: "https://www.themealdb.com/images/category/beef.png",
                title: "Beef",
                price: nil,
                showAddToCartButton: false,
                onAddToCartClick: nil,
                onCardClickAction: nil))
            .previewLayout(.sizeThatFits)
            
            // Product card preview
            GeneralCardView(generalItem: GeneralItem(
                thumbnail: "https://www.themealdb.com/images/media/meals/atd5sh1583188467.jpg",
                title: "Beef",
                price: 30,
                showAddToCartButton: true,
                onAddToCartClick: nil,
                onCardClickAction: nil))
            .previewLayout(.sizeThatFits)
        }
        //.padding()
    }
}
