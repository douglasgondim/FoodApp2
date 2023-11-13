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
                TextField("Card Number", text: $viewModel.creditCard.cardNumber)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.creditCard.cardNumber) { oldValue , newValue in
                        viewModel.formatCreditCardNumber(oldValue)
                        
                    }
                
                
                TextField("Expiry Date (MM/YY)", text: $viewModel.creditCard.expirationDate)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.creditCard.expirationDate){ oldValue, newValue in
                        viewModel.formatedExpirationDate(oldValue)
                        
                    }
                
                TextField("CVV", text: $viewModel.creditCard.cvv)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.creditCard.cvv){ oldValue, newValue in
                        viewModel.formattedCvv(oldValue)
                    }
                
            }
            
            //            Section(header: Text("Billing Information")) {
            //                TextField("Card Holder Name", text: $viewModel.paymentData.cardHolderName)
            //            }
            
            Section {
                Button("Pay") {
                    viewModel.processPayment()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        //.navigationBarTitle("Payment", displayMode: .inline)
    }
}


struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView(viewModel: CreditCardViewModel())
        
    }
}
