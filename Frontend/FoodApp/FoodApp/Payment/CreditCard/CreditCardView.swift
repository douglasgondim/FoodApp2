//
//  CreditCardView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import SwiftUI

struct CreditCardView: View {
    @ObservedObject var viewModel : CreditCardViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Card Details")) {
                TextField("Card Number", text: $viewModel.paymentMethod.cardNumber)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.paymentMethod.cardNumber) { oldValue , newValue in
                        viewModel.formatCreditCardNumber(newValue)

                    }

                TextField("Expiration Date (MM/YY)", text: $viewModel.paymentMethod.expirationDate)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.paymentMethod.expirationDate){ oldValue, newValue in
                        viewModel.formatedExpirationDate(newValue)

                    }
                
                TextField("CVV", text: $viewModel.paymentMethod.cvv)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.paymentMethod.cvv){ oldValue, newValue in
                        viewModel.formattedCvv(newValue)
                    }
                
            }
            
        }
    }
}


struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView(viewModel: CreditCardViewModel(apiService: APIService(), creditCard: CreditCard(cardNumber: "", expirationDate: "", cvv: "")))
        
    }
}
