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
    public enum TransferMethodField: String {
        /// Common transfer method fields
        /// - createdOn: The datetime when the transfer method was created on.
        case createdOn
        /// - status: The transfer method status transition.
        case status
        /// - token: The transfer method identifier.
        case token
        /// - transferMethodCountry: The transfer method country.
        case transferMethodCountry
        /// - transferMethodCurrency: The transfer method currency.
        case transferMethodCurrency
        /// - type: The transfer method type.
        case type
        /// Bank Account related fields
        ///
        /// - addressLine1: The bank account holder's street address.
        case addressLine1
        /// - addressLine2: The bank account holder's address, second line.
        case addressLine2
        /// - bankAccountId: The bank account number, IBAN or equivalent. If you are providing an IBAN,
        ///         the first two letters of the IBAN must match the `transferMethodCountry`.
        case bankAccountId
        /// - bankAccountPurpose: The purpose of the bank account (e.g. checking, savings, etc).
        case bankAccountPurpose
        /// - bankAccountRelationship: The user's relationship with the bank account holder.
        case bankAccountRelationship
        /// - bankId: The bank code or equivalent (e.g. BIC/SWIFT code).
        case bankId
        /// - bankName: The bank name.
        case bankName
        /// - branchId: The branch code, transit number, routing number or equivalent.
        case branchId
        /// - branchName: The branch name
        case branchName
        /// - businessContactRole: The bank account holder's role in the organization.
        case businessContactRole
        /// - businessName: The name of the transfer method holder's business
        case businessName
        /// - businessRegistrationCountry: The country where the transfer method holder's business is registered
        case businessRegistrationCountry
        /// - businessRegistrationId: The bank account holder's business registration number or identifier, as
        ///         assigned by the relevant government body.
        case businessRegistrationId
        /// - businessRegistrationStateProvince: The state, province or region where the bank account holder's business
        ///         is registered.
        case businessRegistrationStateProvince
        /// - businessType: The bank account holder's business type.
        case businessType
        /// - city: The bank account holder's city.
        case city
        /// - country: The bank account holder's country.
        case country
        /// - countryOfBirth: The country where bank account holder  born
        case countryOfBirth
        /// - countryOfNationality: The Nationality of the bank account holder
        case countryOfNationality
        /// - dateOfBirth: The bank account holder's date of birth.
        case dateOfBirth
        /// - driversLicenseId: The LicenseId of the bank account holder
        case driversLicenseId
        /// - employerId: The employer Id of the  bank account holder
        case employerId
        /// - firstName: The bank account holder's first name.
        case firstName
        /// - gender: The bank account holder's gender
        case gender
        /// - governmentId: The bank account holder's government ID number, such as a Social Security Number.
        case governmentId
        /// - governmentIdType: The bank account holder's government IdType
        case governmentIdType
        /// - intermediaryBankAccountId:  The bank account holder's  Intermediary Bank AccountId
        case intermediaryBankAccountId
        /// - intermediaryBankAddressLine1:  The bank account holder's  Intermediary Bank AddressLine1
        case intermediaryBankAddressLine1
        /// - intermediaryBankAddressLine2: The bank account holder's  Intermediary Bank AddressLine2
        case intermediaryBankAddressLine2
        /// - intermediaryBankCity:  The bank account holder's  Intermediary Bank's City
        case intermediaryBankCity
        /// - intermediaryBankCountry: The bank account holder's Intermediary Bank's  Country
        case intermediaryBankCountry
        /// - intermediaryBankId: The bank account holder's Intermediary Bank Id
        case intermediaryBankId
        /// - intermediaryBankName: The bank account holder's Intermediary Bank Name
        case intermediaryBankName
        /// - intermediaryBankPostalCode: The bank account holder's Intermediary PostalCode:
        case intermediaryBankPostalCode
        /// - intermediaryBankStateProvince: The bank account holder's Intermediary Bank's  State and Province
        case intermediaryBankStateProvince
        /// - lastName: The bank account holder's last name.
        case lastName
        /// - middleName: The bank account holder's middle name.
        case middleName
        /// - mobileNumber: The bank account holder's mobile number
        case mobileNumber
        /// - passportId: The bank account holder's passport Id
        case passportId
        /// - phoneNumber: The bank account holder's phone number.
        case phoneNumber
        /// - postalCode: The bank account holder's postal code.
        case postalCode
        /// - profileType: The bank account holder's profile type.
        case profileType
        /// - stateProvince: The bank account holder's state, province or region.
        case stateProvince
        /// - wireInstructions: The wire transfer instructions
        case wireInstructions

        /// Bank Card related fields
        ///
        /// - cardBrand: The card brand.
        case cardBrand
        /// - cardNumber: The 16-digit card number.
        case cardNumber
        /// - cardType: The bank card type.
        case cardType
        /// - cvv: The card security code which is embossed or printed on the card.
        case cvv
        /// - dateOfExpiry: The expiration date for the card (YYYY-MM).
        case dateOfExpiry

        /// PayPal account related fields
        ///
        /// - email: The email address associated with the PayPal account.
        case email

        /// prepaid card related fields
        ///
        /// cardPackage: The  card's package
        case cardPackage
        /// userToken: The user token
        case userToken
    }

    internal init(data: [String: AnyCodable]) {
        self.storage = data
    }

    /// Representation of the transfer method's type
    public enum TransferMethodType: String {
        /// - bankAccount:   When the transfer method is Bank Account
        case bankAccount = "BANK_ACCOUNT"
        /// - bankCard:      When the transfer method is Bank Card
        case bankCard = "BANK_CARD"
        /// - payPalAccount: When the transfer method is PayPal Account
        case payPalAccount = "PAYPAL_ACCOUNT"
        /// - wireAccount:   When the transfer method is Wire Account
        case wireAccount = "WIRE_ACCOUNT"
        /// - prepaidCard:   When the transfer method is Prepaid Card
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
