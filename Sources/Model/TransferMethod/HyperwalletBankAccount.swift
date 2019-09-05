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

    /// Representation of the bank account holder's role in the organization
    ///
    /// - director
    /// - owner
    /// - other
    public enum BusinessContactRole: String {
        case director = "DIRECTOR"
        case owner = "OWNER"
        case other = "OTHER"
    }

    /// Representation of the bank account holder's business type.
    ///
    /// - corporation
    /// - partnership
    public enum BusinessType: String {
        case corporation = "CORPORATION"
        case partnership = "PARTNERSHIP"
    }

    /// Representation of the bank account holder's gender.
    ///
    /// - male
    /// - female
    public enum Gender: String {
        case male = "MALE"
        case female = "FEMALE"
    }

    /// Representation of the bank account holder's government ID type
    ///
    /// - passport
    /// - nationalIdCard
    public enum GovernmentIdType: String {
        case passport = "PASSPORT"
        case nationalIdCard = "NATIONAL_ID_CARD"
    }

    /// Representation of the user's profile type.
    ///
    /// - business: Business.
    /// - individual: Individual.
    public enum ProfileType: String {
        case business = "BUSINESS"
        case individual = "INDIVIDUAL"
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

    /// The bank account holder's street address.
    public var addressLine1: String? {
        return getField(TransferMethodField.addressLine1.rawValue)
    }

    /// The bank account holder's address, second line.
    public var addressLine2: String? {
        return getField(TransferMethodField.addressLine2.rawValue)
    }

    /// The bank account number, IBAN or equivalent. If you are providing an IBAN, the first two
    /// letters of the IBAN must match the `transferMethodCountry`
    public var bankAccountId: String? {
        return getField(TransferMethodField.bankAccountId.rawValue)
    }

    /// The purpose of the bank account (e.g. checking, savings, etc).
    public var bankAccountPurpose: PurposeType? {
        guard let purpose = getField(TransferMethodField.bankAccountPurpose.rawValue) else {
            return nil
        }

        return PurposeType(rawValue: purpose)
    }

    /// The user's relationship with the bank account holder.
    public var bankAccountRelationship: RelationshipType? {
        let relationshipFieldName = TransferMethodField.bankAccountRelationship.rawValue

        guard let relationship = getField(relationshipFieldName) else {
            return nil
        }

        return RelationshipType(rawValue: relationship)
    }

    /// The bank code or equivalent (e.g. BIC/SWIFT code).
    public var bankId: String? {
        return getField(TransferMethodField.bankId.rawValue)
    }

    /// The bank name.
    public var bankName: String? {
        return getField(TransferMethodField.bankName.rawValue)
    }

    /// The branch code, transit number, routing number or equivalent.
    public var branchId: String? {
        return getField(TransferMethodField.branchId.rawValue)
    }

    /// The branch name.
    public var branchName: String? {
        return getField(TransferMethodField.branchName.rawValue)
    }

    /// The bank account holder's role in the organization.
    public var businessContactRole: BusinessContactRole? {
        guard let role = getField(TransferMethodField.businessContactRole.rawValue) else {
            return nil
        }

        return BusinessContactRole(rawValue: role)
    }

    /// The name of the bank account holder's business.
    public var businessName: String? {
        return getField(TransferMethodField.businessName.rawValue)
    }

    /// The country where the bank account holder's business is registered.
    public var businessRegistrationCountry: String? {
        return getField(TransferMethodField.businessRegistrationCountry.rawValue)
    }

    /// The bank account holder's business registration number or identifier,
    /// as assigned by the relevant government body.
    public var businessRegistrationId: String? {
        return getField(TransferMethodField.businessRegistrationId.rawValue)
    }

    /// The state, province or region where the bank account holder's business is registered.
    public var businessRegistrationStateProvince: String? {
        return getField(TransferMethodField.businessRegistrationStateProvince.rawValue)
    }

    /// The bank account holder's business type.
    public var businessType: BusinessType? {
        guard let type = getField(TransferMethodField.businessType.rawValue) else {
            return nil
        }

        return BusinessType(rawValue: type)
    }

    /// The bank account holder's city.
    public var city: String? {
        return getField(TransferMethodField.city.rawValue)
    }

    /// The bank account holder's country.
    public var country: String? {
        return getField(TransferMethodField.country.rawValue)
    }

    /// The bank account holder's birth country.
    public var countryOfBirth: String? {
        return getField(TransferMethodField.countryOfBirth.rawValue)
    }

    /// The bank account holder's date of birth (All users must be at least 13 years old).
    public var dateOfBirth: String? {
        return getField(TransferMethodField.dateOfBirth.rawValue)
    }

    /// The bank account holder's driver's license number.
    public var driversLicenseId: String? {
        return getField(TransferMethodField.driversLicenseId.rawValue)
    }

    /// The bank account holder's employer identifier, generally used for tax purposes.
    public var employerId: String? {
        return getField(TransferMethodField.employerId.rawValue)
    }

    /// The bank account holder's first name.
    public var firstName: String? {
        return getField(TransferMethodField.firstName.rawValue)
    }

    /// The bank account holder's gender.
    public var gender: Gender? {
        guard let type = getField(TransferMethodField.gender.rawValue) else {
            return nil
        }

        return Gender(rawValue: type)
    }

    /// The bank account holder's government ID number, such as a Social Security Number.
    public var governmentId: String? {
        return getField(TransferMethodField.governmentId.rawValue)
    }

    /// The bank account holder's government ID type.
    public var governmentIdType: GovernmentIdType? {
        guard let type = getField(TransferMethodField.governmentIdType.rawValue) else {
            return nil
        }

        return GovernmentIdType(rawValue: type)
    }

    /// The account number at the intermediary bank.
    public var intermediaryBankAccountId: String? {
        return getField(TransferMethodField.intermediaryBankAccountId.rawValue)
    }

    /// The intermediary bank street address.
    public var intermediaryBankAddressLine1: String? {
        return getField(TransferMethodField.intermediaryBankAddressLine1.rawValue)
    }

    /// The intermediary bank street address, second line.
    public var intermediaryBankAddressLine2: String? {
        return getField(TransferMethodField.intermediaryBankAddressLine2.rawValue)
    }

    /// The intermediary bank city.
    public var intermediaryBankCity: String? {
        return getField(TransferMethodField.intermediaryBankCity.rawValue)
    }

    /// The intermediary bank country.
    public var intermediaryBankCountry: String? {
        return getField(TransferMethodField.intermediaryBankCountry.rawValue)
    }

    /// The intermediary bank's 11-character SWIFT code.
    public var intermediaryBankId: String? {
        return getField(TransferMethodField.intermediaryBankId.rawValue)
    }

    /// The intermediary bank name.
    public var intermediaryBankName: String? {
        return getField(TransferMethodField.intermediaryBankName.rawValue)
    }

    /// The intermediary bank postal code.
    public var intermediaryBankPostalCode: String? {
        return getField(TransferMethodField.intermediaryBankPostalCode.rawValue)
    }

    /// The intermediary bank state, province or region.
    public var intermediaryBankStateProvince: String? {
        return getField(TransferMethodField.intermediaryBankStateProvince.rawValue)
    }

    /// The bank account holder's last name.
    public var lastName: String? {
        return getField(TransferMethodField.lastName.rawValue)
    }

    /// The bank account holder's middle name.
    public var middleName: String? {
        return getField(TransferMethodField.middleName.rawValue)
    }

    /// The bank account holder's cell phone number.
    public var mobileNumber: String? {
        return getField(TransferMethodField.mobileNumber.rawValue)
    }

    /// The bank account holder's passport number.
    public var passportId: String? {
        return getField(TransferMethodField.passportId.rawValue)
    }

    /// The bank account holder's phone number.
    public var phoneNumber: String? {
        return getField(TransferMethodField.phoneNumber.rawValue)
    }

    /// The bank account holder's postal code.
    public var postalCode: String? {
        return getField(TransferMethodField.postalCode.rawValue)
    }

    /// The bank account holder's state, province or region.
    public var stateProvince: String? {
        return getField(TransferMethodField.stateProvince.rawValue)
    }

    /// The wire transfer instructions
    public var wireInstructions: String? {
        return getField(TransferMethodField.wireInstructions.rawValue)
    }

    /// A helper class to build the `HyperwalletBankAccount` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Creates a new instance of the `HyperwalletBankAccount.Builder` based on the required parameter to update
        /// Bank account.
        ///
        /// - Parameter token: The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
        public init(token: String) {
            storage[TransferMethodField.token.rawValue] = AnyCodable(value: token)
        }

        /// Creates a new instance of the `HyperwalletBankAccount.Builder` based on the required parameters to create
        /// Bank account.
        ///
        /// - Parameters:
        ///   - transferMethodCountry: The bank account country.
        ///   - transferMethodCurrency: The bank account currency.
        ///   - transferMethodProfileType: The bank account holder's profile type, e.g. INDIVIDUAL or BUSINESS
        ///   - transferMethodType: The bank account type, e.g. BANK_ACCOUNT or WIRE_ACCOUNT
        public init(transferMethodCountry: String,
                    transferMethodCurrency: String,
                    transferMethodProfileType: String,
                    transferMethodType: String) {
            storage[TransferMethodField.type.rawValue] = AnyCodable(value: transferMethodType)
            storage[TransferMethodField.transferMethodCountry.rawValue] = AnyCodable(value: transferMethodCountry)
            storage[TransferMethodField.transferMethodCurrency.rawValue] = AnyCodable(value: transferMethodCurrency)
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: transferMethodProfileType)
        }

        /// Sets the bank account holder's street address.
        ///
        /// - Parameter addressLine1: The bank account holder's street address.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func addressLine1(_ addressLine1: String) -> Builder {
            storage[TransferMethodField.addressLine1.rawValue] = AnyCodable(value: addressLine1)
            return self
        }

        /// Sets the bank account holder's address, second line.
        ///
        /// - Parameter addressLine2: The bank account holder's address, second line.
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
        /// - Parameter bankId: The bank code or equivalent (e.g. BIC/SWIFT code)
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankId(_ bankId: String) -> Builder {
            storage[TransferMethodField.bankId.rawValue] = AnyCodable(value: bankId)
            return self
        }

        /// Sets the bank name.
        ///
        /// - Parameter bankName: The bank name
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankName(_ bankName: String) -> Builder {
            storage[TransferMethodField.bankName.rawValue] = AnyCodable(value: bankName)
            return self
        }

        /// Sets the branch code, transit number, routing number or equivalent.
        ///
        /// - Parameter branchId: The branch code, transit number, routing number or equivalent.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func branchId(_ branchId: String) -> Builder {
            storage[TransferMethodField.branchId.rawValue] = AnyCodable(value: branchId)
            return self
        }

        /// Sets the branch name.
        ///
        /// - Parameter branchName: The branch name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func branchName(_ branchName: String) -> Builder {
            storage[TransferMethodField.branchName.rawValue] = AnyCodable(value: branchName)
            return self
        }

        /// Sets the bank account holder's role in the organization.
        ///
        /// - Parameter businessContactRole: The bank account holder's role in the organization.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessContactRole(_ businessContactRole: BusinessContactRole) -> Builder {
            storage[TransferMethodField.businessContactRole.rawValue] = AnyCodable(value: businessContactRole.rawValue)
            return self
        }

        /// Sets the name of the bank account holder's business.
        ///
        /// - Parameter businessName: The name of the bank account holder's business.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessName(_ businessName: String) -> Builder {
            storage[TransferMethodField.businessName.rawValue] = AnyCodable(value: businessName)
            return self
        }

        /// Sets the country where the bank account holder's business is registered.
        ///
        /// - Parameter businessRegistrationCountry: The country where the bank account holder's business is registered.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessRegistrationCountry(_ country: String) -> Builder {
            storage[TransferMethodField.businessRegistrationCountry.rawValue] = AnyCodable(value: country)
            return self
        }

        /// Sets the bank account holder's business registration number or identifier,
        /// as assigned by the relevant government body.
        ///
        /// - Parameter businessRegistrationId: The bank account holder's business
        ///   registration number or identifier, as assigned by the relevant government body.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessRegistrationId(_ businessRegistrationId: String) -> Builder {
            storage[TransferMethodField.businessRegistrationId.rawValue] = AnyCodable(value: businessRegistrationId)
            return self
        }

        /// Sets the state, province or region where the bank account holder's business is registered.
        ///
        /// - Parameter businessRegistrationStateProvince: The state, province or region
        ///   where the bank account holder's business is registered.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessRegistrationStateProvince(_ stateProvince: String) -> Builder {
            storage[TransferMethodField.businessRegistrationStateProvince.rawValue] = AnyCodable(value: stateProvince)
            return self
        }

        /// Sets the bank account holder's business type.
        ///
        /// - Parameter businessType: The bank account holder's business type.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func businessType(_ businessType: BusinessType) -> Builder {
            storage[TransferMethodField.businessType.rawValue] = AnyCodable(value: businessType.rawValue)
            return self
        }

        /// Sets the bank account holder's city.
        ///
        /// - Parameter city: The bank account holder's city.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func city(_ city: String) -> Builder {
            storage[TransferMethodField.city.rawValue] = AnyCodable(value: city)
            return self
        }

        /// Sets the bank account holder's country.
        ///
        /// - Parameter country: The bank account holder's country.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func country(_ country: String) -> Builder {
            storage[TransferMethodField.country.rawValue] = AnyCodable(value: country)
            return self
        }

        /// Sets the bank account holder's birth country.
        ///
        /// - Parameter countryOfBirth: The bank account holder's birth country.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func countryOfBirth(_ countryOfBirth: String) -> Builder {
            storage[TransferMethodField.countryOfBirth.rawValue] = AnyCodable(value: countryOfBirth)
            return self
        }

        /// Sets the bank account holder's date of birth (All users must be at least 13 years old).
        ///
        /// - Parameter dateOfBirth: The bank account holder's date of birth
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func dateOfBirth(_ dateOfBirth: String) -> Builder {
            storage[TransferMethodField.dateOfBirth.rawValue] = AnyCodable(value: dateOfBirth)
            return self
        }

        /// Sets the bank account holder's driver's license number.
        ///
        /// - Parameter driversLicenseId: The bank account holder's driver's license number.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func driversLicenseId(_ driversLicenseId: String) -> Builder {
            storage[TransferMethodField.driversLicenseId.rawValue] = AnyCodable(value: driversLicenseId)
            return self
        }

        /// Sets the bank account holder's employer identifier, generally used for tax purposes.
        ///
        /// - Parameter employerId: The bank account holder's employer identifier, generally used for tax purposes.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func employerId(_ employerId: String) -> Builder {
            storage[TransferMethodField.employerId.rawValue] = AnyCodable(value: employerId)
            return self
        }

        /// Sets the bank account holder's first name.
        ///
        /// - Parameter firstName: The bank account holder's first name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func firstName(_ firstName: String) -> Builder {
            storage[TransferMethodField.firstName.rawValue] = AnyCodable(value: firstName)
            return self
        }

        /// Sets the bank account holder's gender.
        ///
        /// - Parameter gender: The bank account holder's gender.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func gender(_ gender: Gender) -> Builder {
            storage[TransferMethodField.gender.rawValue] = AnyCodable(value: gender.rawValue)
            return self
        }

        /// Sets the bank account holder's government ID number, such as a Social Security Number.
        ///
        /// - Parameter governmentId: The bank account holder's government ID number, such as a Social Security Number.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func governmentId(_ governmentId: String) -> Builder {
            storage[TransferMethodField.governmentId.rawValue] = AnyCodable(value: governmentId)
            return self
        }

        /// Sets the bank account holder's government ID type.
        ///
        /// - Parameter governmentIdType: The bank account holder's government ID type.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func governmentIdType(_ governmentIdType: GovernmentIdType) -> Builder {
            storage[TransferMethodField.governmentIdType.rawValue] = AnyCodable(value: governmentIdType.rawValue)
            return self
        }

        /// Sets the account number at the intermediary bank.
        ///
        /// - Parameter intermediaryBankAccountId: The account number at the intermediary bank.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankAccountId(_ accountId: String) -> Builder {
            storage[TransferMethodField.intermediaryBankAccountId.rawValue] = AnyCodable(value: accountId)
            return self
        }

        /// Sets the intermediary bank street address.
        ///
        /// - Parameter intermediaryBankAddressLine1: The intermediary bank street address.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankAddressLine1(_ addressLine1: String) -> Builder {
            storage[TransferMethodField.intermediaryBankAddressLine1.rawValue] = AnyCodable(value: addressLine1)
            return self
        }

        /// Sets the intermediary bank street address, second line.
        ///
        /// - Parameter intermediaryBankAddressLine2: The intermediary bank street address, second line.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankAddressLine2(_ addressLine2: String) -> Builder {
            storage[TransferMethodField.intermediaryBankAddressLine2.rawValue] = AnyCodable(value: addressLine2)
            return self
        }

        /// Sets the intermediary bank city.
        ///
        /// - Parameter intermediaryBankCity: The intermediary bank city.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankCity(_ city: String) -> Builder {
            storage[TransferMethodField.intermediaryBankCity.rawValue] = AnyCodable(value: city)
            return self
        }

        /// Sets the intermediary bank country.
        ///
        /// - Parameter intermediaryBankCountry: The intermediary bank country.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankCountry(_ country: String) -> Builder {
            storage[TransferMethodField.intermediaryBankCountry.rawValue] = AnyCodable(value: country)
            return self
        }

        /// Sets the intermediary bank's 11-character SWIFT code.
        ///
        /// - Parameter intermediaryBankId: The intermediary bank's 11-character SWIFT code.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankId(_ intermediaryBankId: String) -> Builder {
            storage[TransferMethodField.intermediaryBankId.rawValue] = AnyCodable(value: intermediaryBankId)
            return self
        }

        /// Sets the intermediary bank name.
        ///
        /// - Parameter intermediaryBankName: The intermediary bank name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankName(_ name: String) -> Builder {
            storage[TransferMethodField.intermediaryBankName.rawValue] = AnyCodable(value: name)
            return self
        }

        /// Sets the intermediary bank postal code.
        ///
        /// - Parameter intermediaryBankPostalCode: The intermediary bank postal code.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankPostalCode(_ postalCode: String) -> Builder {
            storage[TransferMethodField.intermediaryBankPostalCode.rawValue] = AnyCodable(value: postalCode)
            return self
        }

        /// Sets the intermediary bank state, province or region.
        ///
        /// - Parameter intermediaryBankStateProvince: The intermediary bank state, province or region.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func intermediaryBankStateProvince(_ stateProvince: String) -> Builder {
            storage[TransferMethodField.intermediaryBankStateProvince.rawValue] = AnyCodable(value: stateProvince)
            return self
        }

        /// Sets the bank account holder's last name.
        ///
        /// - Parameter lastName: The bank account holder's last name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func lastName(_ lastName: String) -> Builder {
            storage[TransferMethodField.lastName.rawValue] = AnyCodable(value: lastName)
            return self
        }

        /// Sets the bank account holder's middle name.
        ///
        /// - Parameter middleName: The bank account holder's middle name.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func middleName(_ middleName: String) -> Builder {
            storage[TransferMethodField.middleName.rawValue] = AnyCodable(value: middleName)
            return self
        }

        /// Sets the bank account holder's cell phone number.
        ///
        /// - Parameter mobileNumber: The bank account holder's cell phone number.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func mobileNumber(_ mobileNumber: String) -> Builder {
            storage[TransferMethodField.mobileNumber.rawValue] = AnyCodable(value: mobileNumber)
            return self
        }

        /// Sets the bank account holder's passport number.
        ///
        /// - Parameter passportId: The bank account holder's passport number.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func passportId(_ passportId: String) -> Builder {
            storage[TransferMethodField.passportId.rawValue] = AnyCodable(value: passportId)
            return self
        }

        /// Sets the bank account holder's phone number.
        ///
        /// - Parameter phoneNumber: The bank account holder's phone number.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func phoneNumber(_ phoneNumber: String) -> Builder {
            storage[TransferMethodField.phoneNumber.rawValue] = AnyCodable(value: phoneNumber)
            return self
        }

        /// Sets the bank account holder's postal code.
        ///
        /// - Parameter postalCode: The bank account holder's postal code.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func postalCode(_ postalCode: String) -> Builder {
            storage[TransferMethodField.postalCode.rawValue] = AnyCodable(value: postalCode)
            return self
        }

        /// Sets the bank account holder's profile type.
        ///
        /// - Parameter profileType: The bank account holder's profile type, e.g. INDIVIDUAL or BUSINESS
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func profileType(_ profileType: String) -> Builder {
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: profileType)
            return self
        }

        /// Sets the bank account holder's state, province or region.
        ///
        /// - Parameter stateProvince: The bank account holder's state, province or region.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func stateProvince(_ stateProvince: String) -> Builder {
            storage[TransferMethodField.stateProvince.rawValue] = AnyCodable(value: stateProvince)
            return self
        }

        /// Sets the type of transfer method, e.g. BANK_ACCOUNT or WIRE_ACCOUNT.
        ///
        /// - Parameter type: The type of transfer method, e.g. BANK_ACCOUNT or WIRE_ACCOUNT.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func type(_ type: String) -> Builder {
            storage[TransferMethodField.type.rawValue] = AnyCodable(value: type)
            return self
        }

        /// Sets wire transfer instructions.
        ///
        /// - Parameter wireInstructions: Wire transfer instructions.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func wireInstructions(_ wireInstructions: String) -> Builder {
            storage[TransferMethodField.wireInstructions.rawValue] = AnyCodable(value: wireInstructions)
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
