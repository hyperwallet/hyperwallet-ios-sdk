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
        // Common transfer method fields
        /// The datetime when the transfer method was created on.
        case createdOn
        /// The transfer method status transition.
        case status
        /// The transfer method identifier.
        case token
        /// The transfer method country.
        case transferMethodCountry
        /// The transfer method currency.
        case transferMethodCurrency
        /// The transfer method type.
        case type
        // Bank Account related fields
        ///
        /// The bank account holder's street address.
        case addressLine1
        /// The bank account holder's address, second line.
        case addressLine2
        /// The bank account number, IBAN or equivalent. If you are providing an IBAN,
        /// the first two letters of the IBAN must match the `transferMethodCountry`.
        case bankAccountId
        /// The purpose of the bank account (e.g. checking, savings, etc).
        case bankAccountPurpose
        /// The user's relationship with the bank account holder.
        case bankAccountRelationship
        /// The bank code or equivalent (e.g. BIC/SWIFT code).
        case bankId
        /// The bank name.
        case bankName
        /// The branch code, transit number, routing number or equivalent.
        case branchId
        /// The branch name
        case branchName
        /// The bank account holder's role in the organization.
        case businessContactRole
        /// The name of the transfer method holder's business
        case businessName
        /// The country where the transfer method holder's business is registered
        case businessRegistrationCountry
        /// The bank account holder's business registration number or identifier, as
        /// assigned by the relevant government body.
        case businessRegistrationId
        /// The state, province or region where the bank account holder's business
        /// is registered.
        case businessRegistrationStateProvince
        /// The bank account holder's business type.
        case businessType
        /// The bank account holder's city.
        case city
        /// The bank account holder's country.
        case country
        /// The country where bank account holder born
        case countryOfBirth
        /// The Nationality of the bank account holder
        case countryOfNationality
        /// The bank account holder's date of birth.
        case dateOfBirth
        /// The LicenseId of the bank account holder
        case driversLicenseId
        /// The employer Id of the bank account holder
        case employerId
        /// The bank account holder's first name.
        case firstName
        /// The bank account holder's gender
        case gender
        /// The bank account holder's government ID number, such as a Social Security Number.
        case governmentId
        /// The bank account holder's government IdType
        case governmentIdType
        /// The bank account holder's Intermediary Bank AccountId
        case intermediaryBankAccountId
        /// The bank account holder's Intermediary Bank AddressLine1
        case intermediaryBankAddressLine1
        /// The bank account holder's Intermediary Bank AddressLine2
        case intermediaryBankAddressLine2
        /// The bank account holder's Intermediary Bank's City
        case intermediaryBankCity
        /// The bank account holder's Intermediary Bank's Country
        case intermediaryBankCountry
        /// The bank account holder's Intermediary Bank Id
        case intermediaryBankId
        /// The bank account holder's Intermediary Bank Name
        case intermediaryBankName
        /// The bank account holder's Intermediary PostalCode:
        case intermediaryBankPostalCode
        /// The bank account holder's Intermediary Bank's State and Province
        case intermediaryBankStateProvince
        /// The bank account holder's last name.
        case lastName
        /// The bank account holder's middle name.
        case middleName
        /// The bank account holder's mobile number
        case mobileNumber
        /// The bank account holder's passport Id
        case passportId
        /// The bank account holder's phone number.
        case phoneNumber
        /// The bank account holder's postal code.
        case postalCode
        /// The bank account holder's profile type.
        case profileType
        /// The bank account holder's state, province or region.
        case stateProvince
        /// The wire transfer instructions
        case wireInstructions

        // Bank Card related fields
        ///
        /// The card brand.
        case cardBrand
        /// The 16-digit card number.
        case cardNumber
        /// The bank card type.
        case cardType
        /// The card security code which is embossed or printed on the card.
        case cvv
        /// The expiration date for the card (YYYY-MM).
        case dateOfExpiry
        /// The primary card token
        case primaryCardToken

        // PayPal account related fields
        ///
        /// The email address associated with the PayPal account.
        case email

        // Venmo account related field
        ///
        /// The mobile number associated with the Venmo account.
        case accountId

        // prepaid card related fields
        ///
        /// The card's package
        case cardPackage
        /// The user token
        case userToken
    }

    internal init(data: [String: AnyCodable]) {
        self.storage = data
    }

    /// Representation of the transfer method's type
    public enum TransferMethodType: String {
        /// When the transfer method is Bank Account
        case bankAccount = "BANK_ACCOUNT"
        /// When the transfer method is Bank Card
        case bankCard = "BANK_CARD"
        /// When the transfer method is PayPal Account
        case payPalAccount = "PAYPAL_ACCOUNT"
        /// When the transfer method is Wire Account
        case wireAccount = "WIRE_ACCOUNT"
        /// When the transfer method is Prepaid Card
        case prepaidCard = "PREPAID_CARD"
        /// When the transfer method is Venmo Account
        case venmoAccount = "VENMO_ACCOUNT"
        /// When the transfer method is Paper Check
        case peperCheck = "PAPER_CHECK"
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
        self.storage[fieldName]?.value as? String
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
        self.storage
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
            CodingKeys(stringValue: key)!
        }
    }

    /// The transfer method's created time
    public var createdOn: String? {
        getField(TransferMethodField.createdOn.rawValue)
    }

    /// The transfer method holder's profile type, e.g. INDIVIDUAL or BUSINESS.
    public var profileType: String? {
        getField(TransferMethodField.profileType.rawValue)
    }

    /// The transfer method's status
    public var status: String? {
        getField(TransferMethodField.status.rawValue)
    }

    /// The transfer method's token
    public var token: String? {
        getField(TransferMethodField.token.rawValue)
    }

    /// The transfer method's country
    public var transferMethodCountry: String? {
        getField(TransferMethodField.transferMethodCountry.rawValue)
    }

    /// The transfer method's currency
    public var transferMethodCurrency: String? {
        getField(TransferMethodField.transferMethodCurrency.rawValue)
    }

    /// The transfer method's type
    public var type: String? {
        getField(TransferMethodField.type.rawValue)
    }
}
