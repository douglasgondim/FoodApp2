//
//  GeneralCardView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import SwiftUI

protocol GeneralItemProtocol: Identifiable {
    var id: Int { get }
    var thumbnail: String { get }
    var title: String { get }
    
}




struct GeneralCardView: View {
    let generalItem: any GeneralItemProtocol
    let onAddToCartClicked: () -> Void
    let onCardClicked: () -> Void
    
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
            
            Text(generalItem.title)
                .font(.headline)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(height: 70)
                .foregroundStyle(.foreground)
            
            
            
            if let product = generalItem as? Product {
                Text("$\(product.productPrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(Color("GeneralCardPrice"))
                    .frame(height: 20)
                
                
                
                Button(action: onAddToCartClicked
                ) {
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
        .onTapGesture {
            onCardClicked()
        }
        
    }
}


struct GeneralCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group{
            // Category card preview
            GeneralCardView(generalItem: Category(
                categoryId: 1,
                categoryName: "Fruits",
                categoryThumbnail: ""
            ),
                            onAddToCartClicked: {},
                            onCardClicked: {}
            )
            .previewLayout(.sizeThatFits)
            
            // Product card preview
            GeneralCardView(generalItem: Product(
                productId: 1,
                productName: "Banana",
                productThumbnail: "",
                productPrice: 0.99
            ),
                            
                            onAddToCartClicked: {},
                            onCardClicked: {})
            .previewLayout(.sizeThatFits)
            
        }
    }
}
