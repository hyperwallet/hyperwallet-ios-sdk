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

import UIKit

/// Representation of the Hyperwallet's user.
@objcMembers
public class HyperwalletUser: NSObject, Codable {
    private var storage = [String: AnyCodable]()

    /// Representation of the user field type.
    public enum UserField: String {
        /// The user's street address.
        case addressLine1
        /// The user's address, second line.
        case addressLine2
        /// The business contact's street address.
        case businessContactAddressLine1
        /// The business contact's address, second line.
        case businessContactAddressLine2
        /// The business contact's city.
        case businessContactCity
        /// The business contact's country.
        case businessContactCountry
        /// The business contact's postal code.
        case businessContactPostalCode
        /// The user's role in the organization.
        case businessContactRole
        /// The business contact's state, province or region.
        case businessContactStateProvince
        /// The business name.
        case businessName
        /// The business' operating name.
        case businessOperatingName
        /// The country where the business is registered.
        case businessRegistrationCountry
        /// The business registration number or identifier assigned by a government body.
        case businessRegistrationId
        /// The state, province or region where the business is registered.
        case businessRegistrationStateProvince
        /// The business type.
        case businessType
        /// The user's city.
        case city
        /// A client-defined identifier for the user. This is the unique ID assigned to the user
        /// on your system.
        case clientUserId
        /// The user's country.
        case country
        /// The user's birth country.
        case countryOfBirth
        /// The user's country of citizenship or nationality.
        case countryOfNationality
        /// The datetime the user account was created on in ISO 8601 format (YYYY-MM-DDThh:mm:ss).
        /// Note that the timezone used is UTC, therefore no time offset is returned.
        case createdOn
        /// The user's date of birth (All users must be at least 13 years old).
        case dateOfBirth
        /// The user's driver's license number.
        case driversLicenseId
        /// The contact email address for the user account. This must be unique for your program,
        /// so you cannot have two users belonging to the same program with the same email address.
        case email
        /// The user's employer identifier, generally used for tax purposes.
        case employerId
        /// The user's first name.
        case firstName
        /// The user's gender.
        case gender
        /// The user's government ID number, such as a Social Security Number.
        case governmentId
        /// The user's government ID type.
        case governmentIdType
        /// The preferred language for the user's account. Defaults to English if not provided.
        case language
        /// The user's last name.
        case lastName
        /// The user's middle name.
        case middleName
        /// The user's cell phone number.
        case mobileNumber
        /// The user's passport number.
        case passportId
        /// The user's phone number.
        case phoneNumber
        /// The user's postal code.
        case postalCode
        /// The user's postal code.
        case profileType
        /// The unique identifier for the program to which the user will belong.
        case programToken
        /// The user's state, province or region.
        case stateProvince
        /// The user account status.
        case status
        /// The local time of a region or a country. e.g. GMT, PST, ...
        case timeZone
        /// The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
        case token
        /// The user's verification status. A user may be required to verify their identity after
        /// a certain threshold of payments is reached.
        case verificationStatus
    }

    /// The business type.
    public enum BusinessType: String {
        /// The corporation business type
        case corporation = "CORPORATION"
        /// The partnership business type
        case partnership = "PARTNERSHIP"
    }

    /// The user's role in the organization.
    public enum BusinessContactRole: String {
        /// The director role
        case director = "DIRECTOR"
        /// The other role
        case other = "OTHER"
        /// The owner role
        case owner = "OWNER"
    }

    /// Representation of the gender.
    public enum Gender: String {
        /// The female gender
        case female = "FEMALE"
        /// The male gender
        case male = "MALE"
    }

    /// Representation of the user's profile type.
    public enum ProfileType: String {
        /// The business profile type.
        case business = "BUSINESS"
        /// The individual profile type.
        case individual = "INDIVIDUAL"
    }

    /// Representation of the user account status type.
    public enum Status: String {
        /// The user account is activated.
        case activated = "ACTIVATED"
        /// The user account is deactivated.
        case deactivated = "DE_ACTIVATED"
        /// The user account is frozen.
        case frozen = "FROZEN"
        /// The user account is locked.
        case locked = "LOCKED"
        /// The user account is pre activated.
        case preActivated = "PRE_ACTIVATED"
    }

    /// Representation of the user's verification status type.
    public enum VerificationStatus: String, Codable {
        /// The user's verification status is fail. Temporary status before changing to REQUIRED.
        case failed = "FAILED"
        /// The user's verification status is not require.
        case notRequired = "NOT_REQUIRED"
        /// The user's verification status is require.
        case required = "REQUIRED"
        /// The user's verification status is under review.
        case underReview = "UNDER_REVIEW"
        /// The user's verification status is verified.
        case verified = "VERIFIED"
    }

    /// Creates a new instance of the `HyperwalletUser` based on the storage dictionaty.
    ///
    /// - Parameter data: The `[String: AnyCodable]` dictionary.
    private init(data: [String: AnyCodable]) {
        self.storage = data
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Dictionary<String, AnyCodable>.self)
        self.storage = data
    }

    /// The user's street address.
    public var addressLine1: String? {
        getField(UserField.addressLine1.rawValue)
    }

    /// The user's address, second line.
    public var addressLine2: String? {
        getField(UserField.addressLine2.rawValue)
    }

    /// The business contact's street address.
    public var businessContactAddressLine1: String? {
        getField(UserField.businessContactAddressLine1.rawValue)
    }

    /// The business contact's address, second line.
    public var businessContactAddressLine2: String? {
        getField(UserField.businessContactAddressLine2.rawValue)
    }

    /// The business contact's city.
    public var businessContactCity: String? {
        getField(UserField.businessContactCity.rawValue)
    }

    /// The business contact's country,
    public var businessContactCountry: String? {
        getField(UserField.businessContactCountry.rawValue)
    }

    /// The business contact's postal code.
    public var businessContactPostalCode: String? {
        getField(UserField.businessContactPostalCode.rawValue)
    }

    /// The user's role in the organization
    public var businessContactRole: BusinessContactRole? {
        guard let value = getField(UserField.businessContactRole.rawValue) else {
            return nil
        }
        return BusinessContactRole(rawValue: value)
    }

    /// The business contact's state, province or region.
    public var businessContactStateProvince: String? {
        getField(UserField.businessContactStateProvince.rawValue)
    }

    /// The business name.
    public var businessName: String? {
        getField(UserField.businessName.rawValue)
    }

    /// The business' operating name.
    public var businessOperatingName: String? {
        getField(UserField.businessOperatingName.rawValue)
    }

    /// The country where the business is registered.
    public var businessRegistrationCountry: String? {
        getField(UserField.businessRegistrationCountry.rawValue)
    }

    /// The business registration number or identifier assigned by a government body.
    public var businessRegistrationId: String? {
        getField(UserField.businessRegistrationId.rawValue)
    }

    /// The state, province or region where the business is registered.
    public var businessRegistrationStateProvince: String? {
        getField(UserField.businessRegistrationStateProvince.rawValue)
    }

    /// The business type
    public var businessType: BusinessType? {
        guard let value = getField(UserField.businessType.rawValue) else {
            return nil
        }
        return BusinessType(rawValue: value)
    }

    /// The user's city.
    public var city: String? {
        getField(UserField.city.rawValue)
    }

    /// A client-defined identifier for the user. This is the unique ID assigned to the user on your system.
    public var clientUserId: String? {
        getField(UserField.clientUserId.rawValue)
    }

    /// The user's country.
    public var country: String? {
        getField(UserField.country.rawValue)
    }

    /// The user's birth country.
    public var countryOfBirth: String? {
        getField(UserField.countryOfBirth.rawValue)
    }

    /// The user's country of citizenship or nationality.
    public var countryOfNationality: String? {
        getField(UserField.countryOfNationality.rawValue)
    }

    /// The datetime the user account was created on in ISO 8601 format (YYYY-MM-DDThh:mm:ss). Note that the timezone
    /// used is UTC, therefore no time offset is returned.
    public var createdOn: String? {
        getField(UserField.createdOn.rawValue)
    }

    /// The user's date of birth (All users must be at least 13 years old).
    public var dateOfBirth: String? {
        getField(UserField.dateOfBirth.rawValue)
    }

    /// The user's driver's license number.
    public var driversLicenseId: String? {
        getField(UserField.driversLicenseId.rawValue)
    }

    /// The contact email address for the user account. This must be unique for your program, so you cannot have two
    /// users belonging to the same program with the same email address.
    public var email: String? {
        getField(UserField.email.rawValue)
    }

    /// The user's employer identifier, generally used for tax purposes.
    public var employerId: String? {
        getField(UserField.employerId.rawValue)
    }

    /// The user's first name.
    public var firstName: String? {
        getField(UserField.firstName.rawValue)
    }

    /// The user's gender.
    public var gender: Gender? {
        guard let value = getField(UserField.gender.rawValue) else {
            return nil
        }
        return Gender(rawValue: value)
    }

    /// The user's government ID number, such as a Social Security Number.
    public var governmentId: String? {
        getField(UserField.governmentId.rawValue)
    }

    /// The user's government ID type.
    public var governmentIdType: String? {
        getField(UserField.governmentIdType.rawValue)
    }

    /// The preferred language for the user's account. Defaults to English if not provided.
    public var language: String? {
        getField(UserField.language.rawValue)
    }

    /// The user's last name.
    public var lastName: String? {
        getField(UserField.lastName.rawValue)
    }

    /// The user's middle name.
    public var middleName: String? {
        getField(UserField.middleName.rawValue)
    }

    /// The user's cell phone number.
    public var mobileNumber: String? {
        getField(UserField.mobileNumber.rawValue)
    }

    /// The user's passport number.
    public var passportId: String? {
        getField(UserField.passportId.rawValue)
    }

    /// The user's phone number.
    public var phoneNumber: String? {
        getField(UserField.phoneNumber.rawValue)
    }

    /// The user's postal code.
    public var postalCode: String? {
        getField(UserField.postalCode.rawValue)
    }

    /// The user's profile type. See `ProfileType`
    public var profileType: ProfileType? {
        guard let value = getField(UserField.profileType.rawValue) else {
            return nil
        }
        return ProfileType(rawValue: value)
    }

    /// The unique identifier for the program to which the user will belong.
    public var programToken: String? {
        getField(UserField.programToken.rawValue)
    }

    /// The user's state, province or region.
    public var stateProvince: String? {
        getField(UserField.stateProvince.rawValue)
    }

    /// The user account status.
    public var status: Status? {
        guard let value = getField(UserField.status.rawValue) else {
            return nil
        }
        return Status(rawValue: value)
    }

    /// The local time of a region or a country. e.g. GMT, PST, ...
    public var timeZone: String? {
        getField(UserField.timeZone.rawValue)
    }

    /// The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
    public var token: String? {
        getField(UserField.token.rawValue)
    }

    /// The user's verification status. A user may be required to verify their identity after a certain
    /// threshold of payments is reached.
    public var verificationStatus: VerificationStatus? {
        guard let value = getField(UserField.verificationStatus.rawValue) else {
            return nil
        }
        return VerificationStatus(rawValue: value)
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
    /// - Parameter fieldName: The `UserField` type raw value
    /// - Returns: Returns the field value, or nil if none exists.
    public func getField(_ fieldName: String) -> String? {
        self.storage[fieldName]?.value as? String
    }

    /// A helper class to build the `HyperwalletUser` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Sets the user's street address.
        ///
        /// - Parameter addressLine1: The user's street address
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func addressLine1(_ addressLine1: String) -> Builder {
            setField(key: UserField.addressLine1, value: addressLine1)
        }

        /// Sets the user's address, second line.
        ///
        /// - Parameter addressLine2: The user's address, second line.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func addressLine2(_ addressLine2: String) -> Builder {
            setField(key: UserField.addressLine2, value: addressLine2)
        }

        /// Builds a new instance of the `HyperwalletUser`.
        ///
        /// - Returns: a new instance of the `HyperwalletUser`.
        public func build() -> HyperwalletUser {
            HyperwalletUser(data: self.storage)
        }

        /// Sets the business contact's street address.
        ///
        /// - Parameter businessContactAddressLine1: The business contact's street address.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactAddressLine1(_ businessContactAddressLine1: String) -> Builder {
            setField(key: UserField.businessContactAddressLine1, value: businessContactAddressLine1)
        }

        /// Sets the business contact's address, second line.
        ///
        /// - Parameter businessContactAddressLine2: The business contact's address, second line.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactAddressLine2(_ businessContactAddressLine2: String) -> Builder {
            setField(key: UserField.businessContactAddressLine2, value: businessContactAddressLine2)
        }

        /// Sets the business contact's city.
        ///
        /// - Parameter businessContactCity: The business contact's city.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactCity(_ businessContactCity: String) -> Builder {
            setField(key: UserField.businessContactCity, value: businessContactCity)
        }

        /// Sets the business contact's country.
        ///
        /// - Parameter businessContactCountry: The business contact's city.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactCountry(_ businessContactCountry: String) -> Builder {
            setField(key: UserField.businessContactCountry, value: businessContactCountry)
        }

        /// Sets the business contact's postal code.
        ///
        /// - Parameter businessContactPostalCode: The business contact's postal code.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactPostalCode(_ businessContactPostalCode: String) -> Builder {
            setField(key: UserField.businessContactPostalCode, value: businessContactPostalCode)
        }

        /// Sets the user's role in the organization.
        ///
        /// - Parameter businessContactPostalCode: The `BusinessContactRole`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactRole(_ businessContactRole: BusinessContactRole) -> Builder {
            setField(key: UserField.businessContactRole, value: businessContactRole.rawValue)
        }

        /// Sets the business contact's state, province or region.
        ///
        /// - Parameter businessContactStateProvince: The business contact's state, province or region.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactStateProvince(_ businessContactStateProvince: String) -> Builder {
            setField(key: UserField.businessContactStateProvince, value: businessContactStateProvince)
        }

        /// Sets the business name.
        ///
        /// - Parameter businessName: The business name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessName(_ businessName: String) -> Builder {
            setField(key: UserField.businessName, value: businessName)
        }

        /// Sets the business' operating name.
        ///
        /// - Parameter businessName: The business' operating name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessOperatingName(_ businessOperatingName: String) -> Builder {
            setField(key: UserField.businessOperatingName, value: businessOperatingName)
        }

        /// Sets the country where the business is registered.
        ///
        /// - Parameter businessRegistrationCountry: The country where the business is registered.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessRegistrationCountry(_ businessRegistrationCountry: String) -> Builder {
            setField(key: UserField.businessRegistrationCountry, value: businessRegistrationCountry)
        }

        /// Sets the business registration number or identifier assigned by a government body.
        ///
        /// - Parameter businessRegistrationId: The business registration number or identifier assigned by a
        ///             government body.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessRegistrationId(_ businessRegistrationId: String) -> Builder {
            setField(key: UserField.businessRegistrationId, value: businessRegistrationId)
        }

        /// Sets the state, province or region where the business is registered.
        ///
        /// - Parameter businessRegistrationStateProvince: The business registration number or identifier assigned by a
        ///             government body.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessRegistrationStateProvince(_ businessRegistrationStateProvince: String) -> Builder {
            setField(key: UserField.businessRegistrationStateProvince, value: businessRegistrationStateProvince)
        }

        /// Sets the business type.
        ///
        /// - Parameter businessRegistrationStateProvince: The `BusinessType`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessType(_ businessType: BusinessType) -> Builder {
            setField(key: UserField.businessType, value: businessType.rawValue)
        }

        /// Sets the user's city.
        ///
        /// - Parameter city: The user's city.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func city(_ city: String) -> Builder {
            setField(key: UserField.city, value: city)
        }

        /// Sets the user's country.
        ///
        /// - Parameter country: The user's country.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func country(_ country: String) -> Builder {
            setField(key: UserField.country, value: country)
        }

        /// Sets the user's birth country.
        ///
        /// - Parameter country: The user's birth country.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func countryOfBirth(_ countryOfBirth: String) -> Builder {
            setField(key: UserField.countryOfBirth, value: countryOfBirth)
        }

        /// Sets the user's country of citizenship or nationality.
        ///
        /// - Parameter countryOfNationality: The user's country of citizenship or nationality.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func countryOfNationality(_ countryOfNationality: String) -> Builder {
            setField(key: UserField.countryOfNationality, value: countryOfNationality)
        }

        /// Sets the datetime the user account was created on in ISO 8601 format (YYYY-MM-DDThh:mm:ss). Note that the
        /// timezone used is UTC, therefore no time offset is returned.
        ///
        /// - Parameter createdOn: The datetime the user account was created on in ISO 8601
        ///                        format (YYYY-MM-DDThh:mm:ss). Note that the timezone used is UTC, therefore no time
        ///                        offset is returned.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func createdOn(_ createdOn: String) -> Builder {
            setField(key: UserField.createdOn, value: createdOn)
        }

        /// Sets the user's date of birth (All users must be at least 13 years old).
        ///
        /// - Parameter dateOfBirth: The user's date of birth (All users must be at least 13 years old).
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func dateOfBirth(_ dateOfBirth: String) -> Builder {
            setField(key: UserField.dateOfBirth, value: dateOfBirth)
        }

        /// Sets the user's driver's license number.
        ///
        /// - Parameter driversLicenseId: The user's driver's license number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func driversLicenseId(_ driversLicenseId: String) -> Builder {
            setField(key: UserField.driversLicenseId, value: driversLicenseId)
        }

        /// Sets the contact email address for the user account. This must be unique for your program, so you cannot
        /// have two users belonging to the same program with the same email address.
        ///
        /// - Parameter driversLicenseId: the contact email address for the user account. This must be unique for your
        ///                               program, so you cannot have two users belonging to the same program with the
        ///                               same email address.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func email(_ email: String) -> Builder {
            setField(key: UserField.email, value: email)
        }

        /// Sets the user's employer identifier, generally used for tax purposes.
        ///
        /// - Parameter employerId: The user's employer identifier, generally used for tax purposes.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func employerId(_ employerId: String) -> Builder {
            setField(key: UserField.employerId, value: employerId)
        }

        /// Sets the user's first name.
        ///
        /// - Parameter firstName: The user's first name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func firstName(_ firstName: String) -> Builder {
            setField(key: UserField.employerId, value: firstName)
        }

        /// Sets the user's gender.
        ///
        /// - Parameter gender: The `Gender`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func gender(_ gender: Gender) -> Builder {
            setField(key: UserField.gender, value: gender.rawValue)
        }

        /// Sets the user's government ID number, such as a Social Security Number.
        ///
        /// - Parameter governmentId: The user's government ID number, such as a Social Security Number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func governmentId(_ governmentId: String) -> Builder {
            setField(key: UserField.employerId, value: governmentId)
        }

        /// Sets the user's government ID type.
        ///
        /// - Parameter governmentIdType: The user's government ID type.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func governmentIdType(_ governmentIdType: String) -> Builder {
            setField(key: UserField.governmentIdType, value: governmentIdType)
        }

        /// Sets the preferred language for the user's account. Defaults to English if not provided.
        ///
        /// - Parameter language: The preferred language for the user's account. Defaults to English if not provided.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func language(_ language: String) -> Builder {
            setField(key: UserField.language, value: language)
        }

        /// Sets the user's last name.
        ///
        /// - Parameter lastName: The user's last name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func lastName(_ lastName: String) -> Builder {
            setField(key: UserField.lastName, value: lastName)
        }

        /// Sets the user's middle name.
        ///
        /// - Parameter middleName: The user's middle name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func middleName(_ middleName: String) -> Builder {
            setField(key: UserField.middleName, value: middleName)
        }

        /// Sets the user's cell phone number.
        ///
        /// - Parameter middleName: The user's middle name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func mobileNumber(_ mobileNumber: String) -> Builder {
            setField(key: UserField.mobileNumber, value: mobileNumber)
        }

        /// Sets the user's passport number.
        ///
        /// - Parameter passportId: The user's passport number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func passportId(_ passportId: String) -> Builder {
            setField(key: UserField.passportId, value: passportId)
        }

        /// Sets the user's phone number.
        ///
        /// - Parameter passportId: The user's phone number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func phoneNumber(_ phoneNumber: String) -> Builder {
            setField(key: UserField.phoneNumber, value: phoneNumber)
        }

        /// Sets the user's postal code.
        ///
        /// - Parameter postalCode: The user's postal code.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func postalCode(_ postalCode: String) -> Builder {
            setField(key: UserField.postalCode, value: postalCode)
        }

        /// Sets the user's profile type.
        ///
        /// - Parameter profileType: The `ProfileType`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func profileType(_ profileType: ProfileType) -> Builder {
            setField(key: UserField.profileType, value: profileType.rawValue)
        }

        /// Sets the unique identifier for the program to which the user will belong.
        ///
        /// - Parameter programToken: The unique identifier for the program to which the user will belong.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func programToken(_ programToken: String) -> Builder {
            setField(key: UserField.postalCode, value: programToken)
        }

        /// Sets the field value based on the `UserField`
        ///
        /// - Parameters:
        ///   - key: The `UserField` value
        ///   - value: The value
        public func setField(key: UserField, value: String) -> Builder {
            setField(key: key.rawValue, value: value)
        }

        /// Sets the field value based on the `UserField.RawValue`
        ///
        /// - Parameters:
        ///   - key: The `UserField.RawValue` value
        ///   - value: The value
        public func setField(key: UserField.RawValue, value: String) -> Builder {
            storage[key] = AnyCodable(value: value)
            return self
        }

        /// Sets the user's state, province or region.
        ///
        /// - Parameter stateProvince: The user's state, province or region.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func stateProvince(_ stateProvince: String) -> Builder {
            setField(key: UserField.stateProvince, value: stateProvince)
        }

        /// Sets the user account status.
        ///
        /// - Parameter status: The user's state, province or region.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func status(_ status: Status) -> Builder {
            setField(key: UserField.status, value: status.rawValue)
        }

        /// Sets the local time of a region or a country. e.g. GMT, PST, ...
        ///
        /// - Parameter timeZone: The local time of a region or a country.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func timeZone(_ timeZone: String) -> Builder {
            setField(key: UserField.timeZone, value: timeZone)
        }
        /// Sets the unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
        ///
        /// - Parameter token: The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func token(_ token: String) -> Builder {
            setField(key: UserField.token, value: token)
        }

        /// Sets the the user's verification status. A user may be required to verify their identity after a certain
        /// threshold of payments is reached.
        ///
        /// - Parameter verificationStatus: The user's verification status. A user may be required to verify their
        ///                                 identity after a certainthreshold of payments is reached.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func verificationStatus(_ verificationStatus: VerificationStatus) -> Builder {
            setField(key: UserField.verificationStatus, value: verificationStatus.rawValue)
        }
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
}
