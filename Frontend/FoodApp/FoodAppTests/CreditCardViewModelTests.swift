//
//  CreditCardViewModelTests.swift
//  FoodAppTests
//
//  Created by Douglas Gondim on 14/11/23.
//


import XCTest
@testable import FoodApp

class CreditCardViewModelTests: XCTestCase {
    var viewModel: CreditCardViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CreditCardViewModel(apiService: MockAPIService(), creditCard: CreditCard(cardNumber: "", expirationDate: "", cvv: ""))
    }

    func testCardNumberFormatting() {
        viewModel.formatCreditCardNumber("1234567890123456")
        XCTAssertEqual(viewModel.paymentMethod.cardNumber, "1234 5678 9012 3456")
    }

    func testExpirationDateFormatting() {
        viewModel.formatedExpirationDate("1226")
        XCTAssertEqual(viewModel.paymentMethod.expirationDate, "12/26")

        viewModel.formatedExpirationDate("1326") // Invalid month
        XCTAssertNotEqual(viewModel.paymentMethod.expirationDate, "13/26")
    }

    func testCvvFormatting() {
        viewModel.formattedCvv("123")
        XCTAssertEqual(viewModel.paymentMethod.cvv, "123")

        viewModel.formattedCvv("1234") // CVV should be 3 digits
        XCTAssertNotEqual(viewModel.paymentMethod.cvv, "1234")
    }


    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
}

class MockAPIService: APIService {

}
