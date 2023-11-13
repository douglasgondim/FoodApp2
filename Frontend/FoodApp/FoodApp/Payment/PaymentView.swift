//
//  PaymentView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//
import SwiftUI

struct PaymentView: View {
    @ObservedObject var viewModel: PaymentViewModel
    
    var body: some View {
        VStack {
            Picker("Payment Type", selection: $viewModel.currentPaymentMethod) {
                Text("Credit Card").tag(PaymentType.creditCard)
                Text("Apple Pay").tag(PaymentType.applePlay)
            }.pickerStyle(.segmented)
            
            switch viewModel.currentPaymentMethod {
            case .creditCard:
                CreditCardView(viewModel: CreditCardViewModel() )
            case .applePlay:
                Spacer()
                Text("Coming Soon!")
                    .font(.title)
                Spacer()
            }
                
        }
        //.navigationTitle("Payment")
        .padding(.top, 10)
    }
    
    
}



struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(viewModel: PaymentViewModel())
        }
    }
}

