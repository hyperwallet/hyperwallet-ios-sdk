//
// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletTransferMethodUpdateConfigurationTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    // swiftlint:disable function_body_length
    func testRetrieveTransferMethodUpdateConfigurationFields_bankAccount() {
        // Given
        let request = setUpTransferMethodUpdateConfigurationRequest("TransferMethodUpdateConfigurationFieldsResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description: "Retrieve update transfer method configuration fields")

        var graphQlResponse: HyperwalletTransferMethodUpdateConfigurationField?
        var errorResponse: HyperwalletErrorType?
        // When
        let fieldQuery = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "trm-0000001")

        Hyperwallet.shared.retrieveTransferMethodUpdateConfigurationFields(request: fieldQuery) { (result, error) in
            graphQlResponse = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        let fieldGroups = graphQlResponse?.transferMethodUpdateConfiguration()?.fieldGroups?.nodes

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(graphQlResponse)
        XCTAssertEqual(fieldGroups?.count,
                       3,
                       "`fieldGroups()` should be 3")

        let bankAccount = fieldGroups?
            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
            .first(where: { $0.name == "bankAccountId" })
        XCTAssertNotNil(bankAccount)
        XCTAssertEqual(bankAccount?.value, "****9822")
        XCTAssertEqual(bankAccount?.dataType, HyperwalletDataType.number.rawValue)
        XCTAssertEqual(bankAccount?.isRequired, true)
        XCTAssertEqual(bankAccount?.isEditable, true)
        XCTAssertEqual(bankAccount?.label, "Account Number")
        XCTAssertEqual(bankAccount?.regularExpression, "^(?![0-]+$)[0-9-]{3,17}$")
        XCTAssertEqual(bankAccount?.validationMessage?.length,
                       "The minimum length of this field is 3 and maximum length is 17.")
        XCTAssertEqual(bankAccount?.fieldValueMasked, true)

        let firstName = fieldGroups?
        .first(where: { $0.group == "ACCOUNT_HOLDER" })?.fields?
        .first(where: { $0.name == "firstName" })
        XCTAssertEqual(firstName?.value, "Cheng")
        XCTAssertEqual(firstName?.dataType, HyperwalletDataType.text.rawValue)
        XCTAssertEqual(firstName?.isRequired, true)
        XCTAssertEqual(firstName?.isEditable, true)
        XCTAssertEqual(firstName?.label, "First Name")
        XCTAssertEqual(firstName?.regularExpression,
                       "^[\\sa-zA-Z0-9\\-.,'\\u00C0-\\u00FF\\u0100-\\u017F\\u0180-\\u024F]{1,50}$")
        XCTAssertEqual(firstName?.validationMessage?.empty,
                       "You must provide a value for this field")
        XCTAssertEqual(firstName?.fieldValueMasked, false)

        let postalCode = fieldGroups?
        .first(where: { $0.group == "ADDRESS" })?.fields?
        .first(where: { $0.name == "postalCode" })
        XCTAssertEqual(postalCode?.value, "12345")
        XCTAssertEqual(postalCode?.dataType, HyperwalletDataType.text.rawValue)
        XCTAssertEqual(postalCode?.isRequired, true)
        XCTAssertEqual(postalCode?.isEditable, true)
        XCTAssertEqual(postalCode?.label, "Zip/Postal Code")
        XCTAssertEqual(postalCode?.regularExpression,
                       "^(?![\\-]+$)[\\sa-zA-Z0-9\\-]{2,16}$")
        XCTAssertEqual(postalCode?.validationMessage?.pattern,
                       "is invalid length or format.")
        XCTAssertEqual(postalCode?.fieldValueMasked, false)
    }

    func testRetrieveTransferMethodUpdateConfigurationFields_payPal() {
        // Given
        let request = setUpTransferMethodUpdateConfigurationRequest(
            "TransferMethodUpdateConfigurationFieldsPaypalResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description:
            "Retrieve update transfer method configuration fields for Paypal")

        var graphQlResponse: HyperwalletTransferMethodUpdateConfigurationField?
        var errorResponse: HyperwalletErrorType?
        // When
        let fieldQuery = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "trm-0000002")

        Hyperwallet.shared.retrieveTransferMethodUpdateConfigurationFields(request: fieldQuery) { (result, error) in
            graphQlResponse = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        let fieldGroups = graphQlResponse?.transferMethodUpdateConfiguration()?.fieldGroups?.nodes

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(graphQlResponse)
        XCTAssertEqual(fieldGroups?.count,
                       1,
                       "`fieldGroups()` should be 1")

        let email = fieldGroups?
            .first(where: { $0.group == "CONTACT_INFORMATION" })?.fields?
            .first(where: { $0.name == "email" })
        XCTAssertNotNil(email)
        XCTAssertEqual(email?.value, "hello@hw.com")
        XCTAssertEqual(email?.dataType, HyperwalletDataType.text.rawValue)
        XCTAssertEqual(email?.isRequired, true)
        XCTAssertEqual(email?.isEditable, true)
        XCTAssertEqual(email?.label, "Email")
        XCTAssertEqual(email?.validationMessage?.length,
                       "The minimum length of this field is 3 and maximum length is 200.")
        XCTAssertEqual(email?.fieldValueMasked, false)
    }

    func testRetrieveTransferMethodUpdateConfigurationFields_bankCard() {
        // Given
        let request = setUpTransferMethodUpdateConfigurationRequest(
            "TransferMethodUpdateConfigurationFieldsBankCardResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description:
            "Retrieve update transfer method configuration fields for Bank Card")

        var graphQlResponse: HyperwalletTransferMethodUpdateConfigurationField?
        var errorResponse: HyperwalletErrorType?
        // When
        let fieldQuery = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "trm-0000003")

        Hyperwallet.shared.retrieveTransferMethodUpdateConfigurationFields(request: fieldQuery) { (result, error) in
            graphQlResponse = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        let fieldGroups = graphQlResponse?.transferMethodUpdateConfiguration()?.fieldGroups?.nodes

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(graphQlResponse)
        XCTAssertEqual(fieldGroups?.count,
                       1,
                       "`fieldGroups()` should be 1")

        let cardNumber = fieldGroups?
            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
            .first(where: { $0.name == "cardNumber" })
        XCTAssertNotNil(cardNumber)
        XCTAssertEqual(cardNumber?.value, "****0006")
        XCTAssertEqual(cardNumber?.dataType, HyperwalletDataType.number.rawValue)
        XCTAssertEqual(cardNumber?.isRequired, true)
        XCTAssertEqual(cardNumber?.isEditable, true)
        XCTAssertEqual(cardNumber?.label, "Card Number")
        XCTAssertEqual(cardNumber?.regularExpression, "^[0-9]{13,19}$")
        XCTAssertEqual(cardNumber?.validationMessage?.length,
                       "The minimum length of this field is 13 and maximum length is 19.")
        XCTAssertEqual(cardNumber?.fieldValueMasked, true)
        XCTAssertEqual(cardNumber?.mask?.defaultPattern, "#### #### #### ####")

        let dateOfExpiry = fieldGroups?
            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
            .first(where: { $0.name == "dateOfExpiry" })
        XCTAssertNotNil(dateOfExpiry)
        XCTAssertEqual(dateOfExpiry?.value, "2024-10-01")
        XCTAssertEqual(dateOfExpiry?.dataType, HyperwalletDataType.expiryDate.rawValue)
        XCTAssertEqual(dateOfExpiry?.isRequired, true)
        XCTAssertEqual(dateOfExpiry?.isEditable, true)
        XCTAssertEqual(dateOfExpiry?.label, "Expiration Date")
        XCTAssertEqual(dateOfExpiry?.regularExpression, "^[0-9]{4}-(1[0-2]|0[1-9])$")
        XCTAssertEqual(dateOfExpiry?.validationMessage?.length,
                       "The exact length of this field is 7.")
        XCTAssertEqual(dateOfExpiry?.fieldValueMasked, false)

        let cvv = fieldGroups?
            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
            .first(where: { $0.name == "cvv" })
        XCTAssertNotNil(cvv)
        XCTAssertEqual(cvv?.dataType, HyperwalletDataType.number.rawValue)
        XCTAssertEqual(cvv?.isRequired, true)
        XCTAssertEqual(cvv?.isEditable, true)
        XCTAssertEqual(cvv?.label, "CVV (Card Security Code)")
        XCTAssertEqual(cvv?.regularExpression, "^[0-9]{3,4}$")
        XCTAssertEqual(cvv?.validationMessage?.length,
                       "The minimum length of this field is 3 and maximum length is 4.")
        XCTAssertEqual(cvv?.fieldValueMasked, false)
        XCTAssertEqual(cvv?.mask?.defaultPattern, "###")
    }

    func testRetrieveTransferMethodUpdateConfigurationFields_venmo() {
        // Given
        let request = setUpTransferMethodUpdateConfigurationRequest(
            "TransferMethodUpdateConfigurationFieldsVenmoResponse")
        HyperwalletTestHelper.setUpMockServer(request: request)

        let expectation = self.expectation(description:
            "Retrieve update transfer method configuration fields for Venmo")

        var graphQlResponse: HyperwalletTransferMethodUpdateConfigurationField?
        var errorResponse: HyperwalletErrorType?
        // When
        let fieldQuery = HyperwalletTransferMethodUpdateConfigurationFieldQuery(transferMethodToken: "trm-0000004")

        Hyperwallet.shared.retrieveTransferMethodUpdateConfigurationFields(request: fieldQuery) { (result, error) in
            graphQlResponse = result
            errorResponse = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        let fieldGroups = graphQlResponse?.transferMethodUpdateConfiguration()?.fieldGroups?.nodes

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(graphQlResponse)
        XCTAssertEqual(fieldGroups?.count,
                       1,
                       "`fieldGroups()` should be 1")

        let accountId = fieldGroups?
            .first(where: { $0.group == "ACCOUNT_INFORMATION" })?.fields?
            .first(where: { $0.name == "accountId" })
        XCTAssertNotNil(accountId)
        XCTAssertEqual(accountId?.value, "5555555555")
        XCTAssertEqual(accountId?.dataType, HyperwalletDataType.text.rawValue)
        XCTAssertEqual(accountId?.isRequired, true)
        XCTAssertEqual(accountId?.isEditable, true)
        XCTAssertEqual(accountId?.label, "Mobile Number")
        XCTAssertEqual(accountId?.regularExpression, "^([0-9]{10})$")
        XCTAssertEqual(accountId?.validationMessage?.length,
                       "The exact length of this field is 10.")
        XCTAssertEqual(accountId?.fieldValueMasked, false)
    }

    private func setUpTransferMethodUpdateConfigurationRequest(_ responseFile: String,
                                                               _ error: NSError? = nil)
        -> StubRequest {
        let data = HyperwalletTestHelper.getDataFromJson(responseFile)
        return HyperwalletTestHelper.buildPostRequest(baseUrl: HyperwalletTestHelper.graphQlURL,
                                                      HyperwalletTestHelper.setUpMockedResponse(payload: data,
                                                                                                error: error))
    }
}
