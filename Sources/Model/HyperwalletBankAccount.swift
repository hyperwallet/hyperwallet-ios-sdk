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

/// Representation of the user's bank account
public final class HyperwalletBankAccount: HyperwalletTransferMethod {
    override private init(data: [String: AnyCodable]) {
        super.init(data: data)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// Representation of the bank account's purpose type.
    ///
    /// - checking: When the user's bank account purpose is checking
    /// - savings: When the user's bank account purpose is savings
    public enum PurposeType: String {
        case checking = "CHECKING"
        case savings = "SAVINGS"
    }

    /// Representation of the user's relationship with the bank account holder.
    ///
    /// - `self`: When the user owns the bank account
    /// - ownCompany: When the bank account is owned by the user's business
    public enum RelationshipType: String {
        case `self` = "SELF"
        case ownCompany = "OWN_COMPANY"
    }

    /// Representation of the user's profile type.
    ///
    /// - business: Business.
    /// - individual: Individual.
    public enum ProfileType: String {
        case business = "BUSINESS"
        case individual = "INDIVIDUAL"
    }

    /// A helper class to build the `HyperwalletBankAccount` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Creates a new instance of the `HyperwalletBankAccount.Builder` based on the required parameter to update
        /// Bank account.
        ///
        /// - Parameter token: The bank account token.
        public init(token: String) {
            storage[TransferMethodField.token.rawValue] = AnyCodable(value: token)
        }

        /// Creates a new instance of the `HyperwalletBankAccount.Builder` based on the required parameters to create
        /// Bank account.
        ///
        /// - Parameters:
        ///   - transferMethodCountry: The bank account country.
        ///   - transferMethodCurrency: The bank account currency.
        ///   - transferMethodProfileType: The method profile type
        public init(transferMethodCountry: String, transferMethodCurrency: String, transferMethodProfileType: String) {
            storage[TransferMethodField.type.rawValue] = AnyCodable(value: TransferMethodType.bankAccount.rawValue)
            storage[TransferMethodField.transferMethodCountry.rawValue] = AnyCodable(value: transferMethodCountry)
            storage[TransferMethodField.transferMethodCurrency.rawValue] = AnyCodable(value: transferMethodCurrency)
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: transferMethodProfileType)
        }

        /// Sets profile address line 1
        ///
        /// - Parameter addressLine1: address line 1
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func addressLine1(_ addressLine1: String) -> Builder {
            storage[TransferMethodField.addressLine1.rawValue] = AnyCodable(value: addressLine1)
            return self
        }

        /// Sets profile address line 2
        ///
        /// - Parameter addressLine2: address line 2
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func addressLine2(_ addressLine2: String) -> Builder {
            storage[TransferMethodField.addressLine2.rawValue] = AnyCodable(value: addressLine2)
            return self
        }

        /// Sets the bank account number, IBAN or equivalent. If you are providing an IBAN, the first two
        /// letters of the IBAN must match the `transferMethodCountry`
        ///
        /// - Parameter bankAccountId: The bank account number, IBAN or equivalent.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankAccountId(_ bankAccountId: String) -> Builder {
            storage[TransferMethodField.bankAccountId.rawValue] = AnyCodable(value: bankAccountId)
            return self
        }

        /// Sets the purpose of the bank account (e.g. checking, savings, etc).
        ///
        /// - Parameter purpose: The `PurposeType`
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankAccountPurpose(_ purpose: PurposeType) -> Builder {
            storage[TransferMethodField.bankAccountPurpose.rawValue] = AnyCodable(value: purpose.rawValue)
            return self
        }

        /// Sets the user's relationship with the bank account holder.
        ///
        /// - Parameter relationship: The `RelationshipType`
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankAccountRelationship(_ relationship: RelationshipType) -> Builder {
            storage[TransferMethodField.bankAccountRelationship.rawValue] = AnyCodable(value: relationship.rawValue)
            return self
        }

        /// Sets the bank code or equivalent (e.g. BIC/SWIFT code).
        ///
        /// - Parameter bankId: the bank code or equivalent (e.g. BIC/SWIFT code)
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankId(_ bankId: String) -> Builder {
            storage[TransferMethodField.bankId.rawValue] = AnyCodable(value: bankId)
            return self
        }

        /// Sets the bank name.
        ///
        /// - Parameter bankName: the bank name
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankName(_ bankName: String) -> Builder {
            storage[TransferMethodField.bankName.rawValue] = AnyCodable(value: bankName)
            return self
        }

        /// Sets the bank account branch code, transit number, routing number or equivalent.
        ///
        /// - Parameter branchId: The branch code, transit number, routing number or equivalent.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func branchId(_ branchId: String) -> Builder {
            storage[TransferMethodField.branchId.rawValue] = AnyCodable(value: branchId)
            return self
        }

        /// Sets the bank account branch name.
        ///
        /// - Parameter branchName: The branch name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func branchName(_ branchName: String) -> Builder {
            storage[TransferMethodField.branchName.rawValue] = AnyCodable(value: branchName)
            return self
        }

        /// Sets the profile business contact role.
        ///
        /// - Parameter businessContactRole: The profile business contact role.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessContactRole(_ businessContactRole: String) -> Builder {
            storage[TransferMethodField.businessContactRole.rawValue] = AnyCodable(value: businessContactRole)
            return self
        }

        /// Sets the profile business name.
        ///
        /// - Parameter businessName: The profile business name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessName(_ businessName: String) -> Builder {
            storage[TransferMethodField.businessName.rawValue] = AnyCodable(value: businessName)
            return self
        }

        /// Sets the profile business registration country.
        ///
        /// - Parameter businessRegistrationCountry: The profile business registration country.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessRegistrationCountry(_ businessRegistrationCountry: String) -> Builder {
            storage[TransferMethodField.businessRegistrationCountry.rawValue] = AnyCodable(value: businessRegistrationCountry)
            return self
        }

        /// Sets the profile business registration id.
        ///
        /// - Parameter businessRegistrationId: The profile business registration id.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessRegistrationId(_ businessRegistrationId: String) -> Builder {
            storage[TransferMethodField.businessRegistrationId.rawValue] = AnyCodable(value: businessRegistrationId)
            return self
        }

        /// Sets the profile business registration state/province.
        ///
        /// - Parameter businessRegistrationStateProvince: The profile business registration state/province.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessRegistrationStateProvince(_ businessRegistrationStateProvince: String) -> Builder {
            storage[TransferMethodField.businessRegistrationStateProvince.rawValue] = AnyCodable(value: businessRegistrationStateProvince)
            return self
        }

        /// Sets the profile business type.
        ///
        /// - Parameter businessType: The profile business type.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessType(_ businessType: String) -> Builder {
            storage[TransferMethodField.businessType.rawValue] = AnyCodable(value: businessType)
            return self
        }

        /// Sets the profile country.
        ///
        /// - Parameter country: The profile country.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func country(_ country: String) -> Builder {
            storage[TransferMethodField.country.rawValue] = AnyCodable(value: country)
            return self
        }

        /// Sets the profile city.
        ///
        /// - Parameter city: The profile city.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func city(_ city: String) -> Builder {
            storage[TransferMethodField.city.rawValue] = AnyCodable(value: city)
            return self
        }

        /// Sets the profile date of birth.
        ///
        /// - Parameter dateOfBirth: The profile date of birth.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func dateOfBirth(_ dateOfBirth: String) -> Builder {
            storage[TransferMethodField.dateOfBirth.rawValue] = AnyCodable(value: dateOfBirth)
            return self
        }

        /// Sets the profile first name.
        ///
        /// - Parameter firstName: The profile first name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func firstName(_ firstName: String) -> Builder {
            storage[TransferMethodField.firstName.rawValue] = AnyCodable(value: firstName)
            return self
        }

        /// Sets the profile government id.
        ///
        /// - Parameter governmentId: The profile government id.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func governmentId(_ governmentId: String) -> Builder {
            storage[TransferMethodField.governmentId.rawValue] = AnyCodable(value: governmentId)
            return self
        }

        /// Sets the profile last name.
        ///
        /// - Parameter lastName: The profile last name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func lastName(_ lastName: String) -> Builder {
            storage[TransferMethodField.lastName.rawValue] = AnyCodable(value: lastName)
            return self
        }

        /// Sets the profile mobile number.
        ///
        /// - Parameter mobileNumber: The profile mobile number.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func mobileNumber(_ mobileNumber: String) -> Builder {
            storage[TransferMethodField.mobileNumber.rawValue] = AnyCodable(value: mobileNumber)
            return self
        }

        /// Sets the profile phone number.
        ///
        /// - Parameter phoneNumber: The profile phone number.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func phoneNumber(_ phoneNumber: String) -> Builder {
            storage[TransferMethodField.phoneNumber.rawValue] = AnyCodable(value: phoneNumber)
            return self
        }

        /// Sets the profile postal code.
        ///
        /// - Parameter postalCode: The profile postal code.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func postalCode(_ postalCode: String) -> Builder {
            storage[TransferMethodField.postalCode.rawValue] = AnyCodable(value: postalCode)
            return self
        }

        /// Sets the profile type (e.g. individual or business).
        ///
        /// - Parameter profileType: The `ProfileType`.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func profileType(_ profileType: ProfileType) -> Builder {
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: profileType.rawValue)
            return self
        }

        /// Sets the profile state/province.
        ///
        /// - Parameter stateProvince: The profile state/province.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func stateProvince(_ stateProvince: String) -> Builder {
            storage[TransferMethodField.stateProvince.rawValue] = AnyCodable(value: stateProvince)
            return self
        }

        /// Builds a new instance of the `HyperwalletBankAccount`.
        ///
        /// - Returns: a new instance of the `HyperwalletBankAccount`.
        public func build() -> HyperwalletBankAccount {
            return HyperwalletBankAccount(data: self.storage)
        }
    }
}
