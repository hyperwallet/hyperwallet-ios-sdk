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

import Foundation

/// Representation of the transfer method (bank account, bank card, PayPal account, prepaid card, paper check).
@objcMembers
public class HyperwalletTransferMethod: NSObject, Codable {
    private var storage: [String: AnyCodable]

    /// Representation of the transfer method's field type
    ///
    /// - createdOn: The datetime when the transfer method was created on.
    /// - status: The transfer method status transition.
    /// - token: The transfer method identifier.
    /// - transferMethodCountry: The transfer method country.
    /// - transferMethodCurrency: The transfer method currency.
    /// - type: The transfer method type.
    /// - addressLine1: The bank account holder's street address.
    /// - addressLine2: The bank account holder's address, second line.
    /// - bankAccountId: The bank account number, IBAN or equivalent. If you are providing an IBAN,
    ///                  the first two letters of the IBAN must match the `transferMethodCountry`.
    /// - bankAccountRelationship: The user's relationship with the bank account holder.
    /// - bankAccountPurpose: The purpose of the bank account (e.g. checking, savings, etc).
    /// - bankName: The bank name.
    /// - bankId: The bank code or equivalent (e.g. BIC/SWIFT code).
    /// - branchName: The branch name
    /// - branchId: The branch code, transit number, routing number or equivalent.
    /// - businessContactRole: The bank account holder's role in the organization.
    /// - businessName: The name of the transfer method holder's business
    /// - businessRegistrationCountry: The country where the transfer method holder's business is registered
    /// - businessRegistrationId: The bank account holder's business registration number or identifier, as assigned by
    ///                           the relevant government body.
    /// - businessRegistrationStateProvince: The state, province or region where the bank account holder's business
    ///                                      is registered.
    /// - businessType: The bank account holder's business type.
    /// - country: The bank account holder's country.
    /// - city: The bank account holder's city.
    /// - dateOfBirth: The bank account holder's date of birth.
    /// - firstName: The bank account holder's first name.
    /// - governmentId: The bank account holder's government ID number, such as a Social Security Number.
    /// - lastName: The bank account holder's last name.
    /// - mobileNumber: The bank account holder's cell phone number.
    /// - phoneNumber: The bank account holder's phone number.
    /// - postalCode: The bank account holder's postal code.
    /// - profileType: The bank account holder's profile type.
    /// - stateProvince: The bank account holder's state, province or region.
    /// - cardBrand: The card brand.
    /// - cardNumber: The 16-digit card number.
    /// - cardType: The bank card type.
    /// - cvv: The card security code which is embossed or printed on the card.
    /// - dateOfExpiry: The expiration date for the card (YYYY-MM).
    /// - email: The email address associated with the PayPal account.
    public enum TransferMethodField: String {
        /// Common transfer method fields
        case createdOn
        case status
        case token
        case transferMethodCountry
        case transferMethodCurrency
        case type

        /// Bank Account related fields
        case addressLine1
        case addressLine2
        case bankAccountId
        case bankAccountPurpose
        case bankAccountRelationship
        case bankId
        case bankName
        case branchId
        case branchName
        case businessContactRole
        case businessName
        case businessRegistrationCountry
        case businessRegistrationId
        case businessRegistrationStateProvince
        case businessType
        case city
        case country
        case countryOfBirth
        case countryOfNationality
        case dateOfBirth
        case driversLicenseId
        case employerId
        case firstName
        case gender
        case governmentId
        case governmentIdType
        case intermediaryBankAccountId
        case intermediaryBankAddressLine1
        case intermediaryBankAddressLine2
        case intermediaryBankCity
        case intermediaryBankCountry
        case intermediaryBankId
        case intermediaryBankName
        case intermediaryBankPostalCode
        case intermediaryBankStateProvince
        case lastName
        case middleName
        case mobileNumber
        case passportId
        case phoneNumber
        case postalCode
        case profileType
        case stateProvince
        case wireInstructions

        /// Bank Card related fields
        case cardBrand
        case cardNumber
        case cardType
        case cvv
        case dateOfExpiry

        // PayPal account related fields
        case email

        // prepaid card related fields
        case cardPackage
        case userToken
    }

    internal init(data: [String: AnyCodable]) {
        self.storage = data
    }

    /// Representation of the transfer method's type
    ///
    /// - bankAccount:   When the transfer method is Bank Account
    /// - bankCard:      When the transfer method is Bank Card
    /// - payPalAccount: When the transfer method is PayPal Account
    /// - wireAccount:   When the transfer method is Wire Account
    /// - prepaidCard:   When the transfer method is Prepaid Card
    public enum TransferMethodType: String {
        case bankAccount = "BANK_ACCOUNT"
        case bankCard = "BANK_CARD"
        case payPalAccount = "PAYPAL_ACCOUNT"
        case wireAccount = "WIRE_ACCOUNT"
        case prepaidCard = "PREPAID_CARD"
    }

    /// Creates a new instance of the `HyperwalletTransferMethod`
    override public init() {
        self.storage = [String: AnyCodable]()
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Dictionary<String, AnyCodable>.self)
        self.storage = data
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for (key, value) in storage {
            do {
                try container.encode(value, forKey: CodingKeys.make(key: key))
            }
        }
    }

    /// Gets the field value
    ///
    /// - Parameter fieldName: The `TransferMethodField` type raw value
    /// - Returns: Returns the field value, or nil if none exists.
    public func getField(_ fieldName: String) -> String? {
        return self.storage[fieldName]?.value as? String
    }

    /// Sets the field value based on the key
    ///
    /// - Parameters:
    ///   - key: The `TransferMethodField.RawValue` value
    ///   - value: The value
    public func setField(key: TransferMethodField.RawValue, value: String) {
        storage[key] = AnyCodable(value: value)
    }

    internal func getFields() -> [String: AnyCodable] {
        return self.storage
    }

    private struct CodingKeys: CodingKey {
        var intValue: Int?
        var stringValue: String

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        static func make(key: String) -> CodingKeys {
            return CodingKeys(stringValue: key)!
        }
    }

    /// The transfer method's created time
    public var createdOn: String? {
        return getField(TransferMethodField.createdOn.rawValue)
    }

    /// The transfer method holder's profile type, e.g. INDIVIDUAL or BUSINESS.
    public var profileType: String? {
        return getField(TransferMethodField.profileType.rawValue)
    }

    /// The transfer method's status
    public var status: String? {
        return getField(TransferMethodField.status.rawValue)
    }

    /// The transfer method's token
    public var token: String? {
        return getField(TransferMethodField.token.rawValue)
    }

    /// The transfer method's country
    public var transferMethodCountry: String? {
        return getField(TransferMethodField.transferMethodCountry.rawValue)
    }

    /// The transfer method's currency
    public var transferMethodCurrency: String? {
        return getField(TransferMethodField.transferMethodCurrency.rawValue)
    }

    /// The transfer method's type
    public var type: String? {
        return getField(TransferMethodField.type.rawValue)
    }
}
