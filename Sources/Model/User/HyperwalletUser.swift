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
public struct HyperwalletUser: Codable {
    private var storage = [String: AnyCodable]()

    /// Representation of the user field type.
    ///
    /// - addressLine1: The user's street address.
    /// - addressLine2: The user's address, second line.
    /// - businessContactAddressLine1: The business contact's street address.
    /// - businessContactAddressLine2: The business contact's address, second line.
    /// - businessContactCity: The business contact's city.
    /// - businessContactCountry: The business contact's country.
    /// - businessContactPostalCode: The business contact's postal code.
    /// - businessContactRole: The user's role in the organization.
    /// - businessContactStateProvince: The business contact's state, province or region.
    /// - businessName: The business name.
    /// - businessOperatingName: The business' operating name.
    /// - businessRegistrationCountry: The country where the business is registered.
    /// - businessRegistrationId: The business registration number or identifier assigned by a government body.
    /// - businessRegistrationStateProvince: The state, province or region where the business is registered.
    /// - businessType: The business type.
    /// - city: The user's city.
    /// - clientUserId: A client-defined identifier for the user. This is the unique ID assigned to the user
    ///                 on your system.
    /// - country: The user's country.
    /// - countryOfBirth: The user's birth country.
    /// - countryOfNationality: The user's country of citizenship or nationality.
    /// - createdOn: The datetime the user account was created on in ISO 8601 format (YYYY-MM-DDThh:mm:ss).
    ///              Note that the timezone used is UTC, therefore no time offset is returned.
    /// - dateOfBirth: The user's date of birth (All users must be at least 13 years old).
    /// - driversLicenseId: The user's driver's license number.
    /// - email: The contact email address for the user account. This must be unique for your program,
    ///          so you cannot have two users belonging to the same program with the same email address.
    /// - employerId: The user's employer identifier, generally used for tax purposes.
    /// - firstName: The user's first name.
    /// - gender: The user's gender.
    /// - governmentId: The user's government ID number, such as a Social Security Number.
    /// - governmentIdType: The user's government ID type.
    /// - language: The preferred language for the user's account. Defaults to English if not provided.
    /// - lastName: The user's last name.
    /// - middleName: The user's middle name.
    /// - mobileNumber: The user's cell phone number.
    /// - passportId: The user's passport number.
    /// - phoneNumber: The user's phone number.
    /// - postalCode: The user's postal code.
    /// - profileType: The user's postal code.
    /// - programToken: The unique identifier for the program to which the user will belong.
    /// - stateProvince: The user's state, province or region.
    /// - status: The user account status.
    /// - timeZone: The local time of a region or a country. e.g. GMT, PST, ...
    /// - token: The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
    /// - verificationStatus: The user's verification status. A user may be required to verify their identity after
    ///                       a certain threshold of payments is reached.
    public enum UserField: String {
        case addressLine1
        case addressLine2
        case businessContactAddressLine1
        case businessContactAddressLine2
        case businessContactCity
        case businessContactCountry
        case businessContactPostalCode
        case businessContactRole
        case businessContactStateProvince
        case businessName
        case businessOperatingName
        case businessRegistrationCountry
        case businessRegistrationId
        case businessRegistrationStateProvince
        case businessType
        case city
        case clientUserId
        case country
        case countryOfBirth
        case countryOfNationality
        case createdOn
        case dateOfBirth
        case driversLicenseId
        case email
        case employerId
        case firstName
        case gender
        case governmentId
        case governmentIdType
        case language
        case lastName
        case middleName
        case mobileNumber
        case passportId
        case phoneNumber
        case postalCode
        case profileType
        case programToken
        case stateProvince
        case status
        case timeZone
        case token
        case verificationStatus
    }

    /// The business type.
    ///
    /// - corporation: Corporation.
    /// - partnership: Partnership.
    public enum BusinessType: String {
        case corporation = "CORPORATION"
        case partnership = "PARTNERSHIP"
    }

    /// The user's role in the organization.
    ///
    /// - director: Director.
    /// - other: Other.
    /// - owner: Owner.
    public enum BusinessContactRole: String {
        case director = "DIRECTOR"
        case other = "OTHER"
        case owner = "OWNER"
    }

    /// Representation of the gender.
    ///
    /// - female: Female.
    /// - male: Male.
    public enum Gender: String {
        case female = "FEMALE"
        case male = "MALE"
    }

    /// Representation of the user's profile type.
    ///
    /// - business: Business.
    /// - individual: Individual.
    public enum ProfileType: String {
        case business = "BUSINESS"
        case individual = "INDIVIDUAL"
    }

    /// Representation of the user account status type.
    ///
    /// - activated: The user account is activate.
    /// - deactivated: The user account is deactivate.
    /// - frozen: The user account is frozen.
    /// - locked: The user account is locked.
    /// - preActivated: The user account is pre activated.
    public enum Status: String {
        case activated = "ACTIVATED"
        case deactivated = "DE_ACTIVATED"
        case frozen = "FROZEN"
        case locked = "LOCKED"
        case preActivated = "PRE_ACTIVATED"
    }

    /// Representation of the user's verification status type.
    ///
    /// - failed: The user's verification status is fail. Temporary status before changing to REQUIRED.
    /// - notRequired: The user's verification status is not require.
    /// - required:  The user's verification status is require.
    /// - underReview:  The user's verification status is under review.
    /// - verified:  The user's verification status is verified.
    public enum VerificationStatus: String, Codable {
        case failed = "FAILED"
        case notRequired = "NOT_REQUIRED"
        case required = "REQUIRED"
        case underReview = "UNDER_REVIEW"
        case verified = "VERIFIED"
    }

    /// Creates a new instance of the `HyperwalletUser` based on the storage dictionaty.
    ///
    /// - Parameter data: The `[String: AnyCodable]` dictionary.
    private init(data: [String: AnyCodable]) {
        self.storage = data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Dictionary<String, AnyCodable>.self)
        self.storage = data
    }

    /// The user's street address.
    public var addressLine1: String? {
        return getField(UserField.addressLine1.rawValue)
    }

    /// The user's address, second line.
    public var addressLine2: String? {
        return getField(UserField.addressLine2.rawValue)
    }

    /// The business contact's street address.
    public var businessContactAddressLine1: String? {
        return getField(UserField.businessContactAddressLine1.rawValue)
    }

    /// The business contact's address, second line.
    public var businessContactAddressLine2: String? {
        return getField(UserField.businessContactAddressLine2.rawValue)
    }

    /// The business contact's city.
    public var businessContactCity: String? {
        return getField(UserField.businessContactCity.rawValue)
    }

    /// The business contact's country,
    public var businessContactCountry: String? {
        return getField(UserField.businessContactCountry.rawValue)
    }

    /// The business contact's postal code.
    public var businessContactPostalCode: String? {
        return getField(UserField.businessContactPostalCode.rawValue)
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
        return getField(UserField.businessContactStateProvince.rawValue)
    }

    /// The business name.
    public var businessName: String? {
        return getField(UserField.businessName.rawValue)
    }

    /// The business' operating name.
    public var businessOperatingName: String? {
        return getField(UserField.businessOperatingName.rawValue)
    }

    /// The country where the business is registered.
    public var businessRegistrationCountry: String? {
        return getField(UserField.businessRegistrationCountry.rawValue)
    }

    /// The business registration number or identifier assigned by a government body.
    public var businessRegistrationId: String? {
        return getField(UserField.businessRegistrationId.rawValue)
    }

    /// The state, province or region where the business is registered.
    public var businessRegistrationStateProvince: String? {
        return getField(UserField.businessRegistrationStateProvince.rawValue)
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
        return getField(UserField.city.rawValue)
    }

    /// A client-defined identifier for the user. This is the unique ID assigned to the user on your system.
    public var clientUserId: String? {
        return getField(UserField.clientUserId.rawValue)
    }

    /// The user's country.
    public var country: String? {
        return getField(UserField.country.rawValue)
    }

    /// The user's birth country.
    public var countryOfBirth: String? {
        return getField(UserField.countryOfBirth.rawValue)
    }

    /// The user's country of citizenship or nationality.
    public var countryOfNationality: String? {
        return getField(UserField.countryOfNationality.rawValue)
    }

    /// The datetime the user account was created on in ISO 8601 format (YYYY-MM-DDThh:mm:ss). Note that the timezone
    /// used is UTC, therefore no time offset is returned.
    public var createdOn: String? {
        return getField(UserField.createdOn.rawValue)
    }

    /// The user's date of birth (All users must be at least 13 years old).
    public var dateOfBirth: String? {
        return getField(UserField.dateOfBirth.rawValue)
    }

    /// The user's driver's license number.
    public var driversLicenseId: String? {
        return getField(UserField.driversLicenseId.rawValue)
    }

    /// The contact email address for the user account. This must be unique for your program, so you cannot have two
    /// users belonging to the same program with the same email address.
    public var email: String? {
        return getField(UserField.email.rawValue)
    }

    /// The user's employer identifier, generally used for tax purposes.
    public var employerId: String? {
        return getField(UserField.employerId.rawValue)
    }

    /// The user's first name.
    public var firstName: String? {
        return getField(UserField.firstName.rawValue)
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
        return getField(UserField.governmentId.rawValue)
    }

    /// The user's government ID type.
    public var governmentIdType: String? {
        return getField(UserField.governmentIdType.rawValue)
    }

    /// The preferred language for the user's account. Defaults to English if not provided.
    public var language: String? {
        return getField(UserField.language.rawValue)
    }

    /// The user's last name.
    public var lastName: String? {
        return getField(UserField.lastName.rawValue)
    }

    /// The user's middle name.
    public var middleName: String? {
        return getField(UserField.middleName.rawValue)
    }

    /// The user's cell phone number.
    public var mobileNumber: String? {
        return getField(UserField.mobileNumber.rawValue)
    }

    /// The user's passport number.
    public var passportId: String? {
        return getField(UserField.passportId.rawValue)
    }

    /// The user's phone number.
    public var phoneNumber: String? {
        return getField(UserField.phoneNumber.rawValue)
    }

    /// The user's postal code.
    public var postalCode: String? {
        return getField(UserField.postalCode.rawValue)
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
        return getField(UserField.programToken.rawValue)
    }

    /// The user's state, province or region.
    public var stateProvince: String? {
        return getField(UserField.stateProvince.rawValue)
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
        return getField(UserField.timeZone.rawValue)
    }

    /// The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
    public var token: String? {
        return getField(UserField.token.rawValue)
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
        return self.storage[fieldName]?.value as? String
    }

    /// A helper class to build the `HyperwalletUser` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Sets the user's street address.
        ///
        /// - Parameter addressLine1: The user's street address
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func addressLine1(_ addressLine1: String) -> Builder {
            return setField(key: UserField.addressLine1, value: addressLine1)
        }

        /// Sets the user's address, second line.
        ///
        /// - Parameter addressLine2: The user's address, second line.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func addressLine2(_ addressLine2: String) -> Builder {
            return setField(key: UserField.addressLine2, value: addressLine2)
        }

        /// Builds a new instance of the `HyperwalletUser`.
        ///
        /// - Returns: a new instance of the `HyperwalletUser`.
        public func build() -> HyperwalletUser {
            return HyperwalletUser(data: self.storage)
        }

        /// Sets the business contact's street address.
        ///
        /// - Parameter businessContactAddressLine1: The business contact's street address.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactAddressLine1(_ businessContactAddressLine1: String) -> Builder {
            return setField(key: UserField.businessContactAddressLine1, value: businessContactAddressLine1)
        }

        /// Sets the business contact's address, second line.
        ///
        /// - Parameter businessContactAddressLine2: The business contact's address, second line.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactAddressLine2(_ businessContactAddressLine2: String) -> Builder {
            return setField(key: UserField.businessContactAddressLine2, value: businessContactAddressLine2)
        }

        /// Sets the business contact's city.
        ///
        /// - Parameter businessContactCity: The business contact's city.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactCity(_ businessContactCity: String) -> Builder {
            return setField(key: UserField.businessContactCity, value: businessContactCity)
        }

        /// Sets the business contact's country.
        ///
        /// - Parameter businessContactCountry: The business contact's city.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactCountry(_ businessContactCountry: String) -> Builder {
            return setField(key: UserField.businessContactCountry, value: businessContactCountry)
        }

        /// Sets the business contact's postal code.
        ///
        /// - Parameter businessContactPostalCode: The business contact's postal code.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactPostalCode(_ businessContactPostalCode: String) -> Builder {
            return setField(key: UserField.businessContactPostalCode, value: businessContactPostalCode)
        }

        /// Sets the user's role in the organization.
        ///
        /// - Parameter businessContactPostalCode: The `BusinessContactRole`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactRole(_ businessContactRole: BusinessContactRole) -> Builder {
            return setField(key: UserField.businessContactRole, value: businessContactRole.rawValue)
        }

        /// Sets the business contact's state, province or region.
        ///
        /// - Parameter businessContactStateProvince: The business contact's state, province or region.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessContactStateProvince(_ businessContactStateProvince: String) -> Builder {
            return setField(key: UserField.businessContactStateProvince, value: businessContactStateProvince)
        }

        /// Sets the business name.
        ///
        /// - Parameter businessName: The business name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessName(_ businessName: String) -> Builder {
            return setField(key: UserField.businessName, value: businessName)
        }

        /// Sets the business' operating name.
        ///
        /// - Parameter businessName: The business' operating name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessOperatingName(_ businessOperatingName: String) -> Builder {
            return setField(key: UserField.businessOperatingName, value: businessOperatingName)
        }

        /// Sets the country where the business is registered.
        ///
        /// - Parameter businessRegistrationCountry: The country where the business is registered.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessRegistrationCountry(_ businessRegistrationCountry: String) -> Builder {
            return setField(key: UserField.businessRegistrationCountry, value: businessRegistrationCountry)
        }

        /// Sets the business registration number or identifier assigned by a government body.
        ///
        /// - Parameter businessRegistrationId: The business registration number or identifier assigned by a
        ///             government body.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessRegistrationId(_ businessRegistrationId: String) -> Builder {
            return setField(key: UserField.businessRegistrationId, value: businessRegistrationId)
        }

        /// Sets the state, province or region where the business is registered.
        ///
        /// - Parameter businessRegistrationStateProvince: The business registration number or identifier assigned by a
        ///             government body.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessRegistrationStateProvince(_ businessRegistrationStateProvince: String) -> Builder {
            return setField(key: UserField.businessRegistrationStateProvince, value: businessRegistrationStateProvince)
        }

        /// Sets the business type.
        ///
        /// - Parameter businessRegistrationStateProvince: The `BusinessType`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func businessType(_ businessType: BusinessType) -> Builder {
            return setField(key: UserField.businessType, value: businessType.rawValue)
        }

        /// Sets the user's city.
        ///
        /// - Parameter city: The user's city.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func city(_ city: String) -> Builder {
            return setField(key: UserField.city, value: city)
        }

        /// Sets the user's country.
        ///
        /// - Parameter country: The user's country.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func country(_ country: String) -> Builder {
            return setField(key: UserField.country, value: country)
        }

        /// Sets the user's birth country.
        ///
        /// - Parameter country: The user's birth country.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func countryOfBirth(_ countryOfBirth: String) -> Builder {
            return setField(key: UserField.countryOfBirth, value: countryOfBirth)
        }

        /// Sets the user's country of citizenship or nationality.
        ///
        /// - Parameter countryOfNationality: The user's country of citizenship or nationality.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func countryOfNationality(_ countryOfNationality: String) -> Builder {
            return setField(key: UserField.countryOfNationality, value: countryOfNationality)
        }

        /// Sets the datetime the user account was created on in ISO 8601 format (YYYY-MM-DDThh:mm:ss). Note that the
        /// timezone used is UTC, therefore no time offset is returned.
        ///
        /// - Parameter createdOn: The datetime the user account was created on in ISO 8601
        ///                        format (YYYY-MM-DDThh:mm:ss). Note that the timezone used is UTC, therefore no time
        ///                        offset is returned.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func createdOn(_ createdOn: String) -> Builder {
            return setField(key: UserField.createdOn, value: createdOn)
        }

        /// Sets the user's date of birth (All users must be at least 13 years old).
        ///
        /// - Parameter dateOfBirth: The user's date of birth (All users must be at least 13 years old).
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func dateOfBirth(_ dateOfBirth: String) -> Builder {
            return setField(key: UserField.dateOfBirth, value: dateOfBirth)
        }

        /// Sets the user's driver's license number.
        ///
        /// - Parameter driversLicenseId: The user's driver's license number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func driversLicenseId(_ driversLicenseId: String) -> Builder {
            return setField(key: UserField.driversLicenseId, value: driversLicenseId)
        }

        /// Sets the contact email address for the user account. This must be unique for your program, so you cannot
        /// have two users belonging to the same program with the same email address.
        ///
        /// - Parameter driversLicenseId: the contact email address for the user account. This must be unique for your
        ///                               program, so you cannot have two users belonging to the same program with the
        ///                               same email address.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func email(_ email: String) -> Builder {
            return setField(key: UserField.email, value: email)
        }

        /// Sets the user's employer identifier, generally used for tax purposes.
        ///
        /// - Parameter employerId: The user's employer identifier, generally used for tax purposes.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func employerId(_ employerId: String) -> Builder {
            return setField(key: UserField.employerId, value: employerId)
        }

        /// Sets the user's first name.
        ///
        /// - Parameter firstName: The user's first name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func firstName(_ firstName: String) -> Builder {
            return setField(key: UserField.employerId, value: firstName)
        }

        /// Sets the user's gender.
        ///
        /// - Parameter gender: The `Gender`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func gender(_ gender: Gender) -> Builder {
            return setField(key: UserField.gender, value: gender.rawValue)
        }

        /// Sets the user's government ID number, such as a Social Security Number.
        ///
        /// - Parameter governmentId: The user's government ID number, such as a Social Security Number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func governmentId(_ governmentId: String) -> Builder {
            return setField(key: UserField.employerId, value: governmentId)
        }

        /// Sets the user's government ID type.
        ///
        /// - Parameter governmentIdType: The user's government ID type.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func governmentIdType(_ governmentIdType: String) -> Builder {
            return setField(key: UserField.governmentIdType, value: governmentIdType)
        }

        /// Sets the preferred language for the user's account. Defaults to English if not provided.
        ///
        /// - Parameter language: The preferred language for the user's account. Defaults to English if not provided.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func language(_ language: String) -> Builder {
            return setField(key: UserField.language, value: language)
        }

        /// Sets the user's last name.
        ///
        /// - Parameter lastName: The user's last name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func lastName(_ lastName: String) -> Builder {
            return setField(key: UserField.lastName, value: lastName)
        }

        /// Sets the user's middle name.
        ///
        /// - Parameter middleName: The user's middle name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func middleName(_ middleName: String) -> Builder {
            return setField(key: UserField.middleName, value: middleName)
        }

        /// Sets the user's cell phone number.
        ///
        /// - Parameter middleName: The user's middle name.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func mobileNumber(_ mobileNumber: String) -> Builder {
            return setField(key: UserField.mobileNumber, value: mobileNumber)
        }

        /// Sets the user's passport number.
        ///
        /// - Parameter passportId: The user's passport number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func passportId(_ passportId: String) -> Builder {
            return setField(key: UserField.passportId, value: passportId)
        }

        /// Sets the user's phone number.
        ///
        /// - Parameter passportId: The user's phone number.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func phoneNumber(_ phoneNumber: String) -> Builder {
            return setField(key: UserField.phoneNumber, value: phoneNumber)
        }

        /// Sets the user's postal code.
        ///
        /// - Parameter postalCode: The user's postal code.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func postalCode(_ postalCode: String) -> Builder {
            return setField(key: UserField.postalCode, value: postalCode)
        }

        /// Sets the user's profile type.
        ///
        /// - Parameter profileType: The `ProfileType`.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func profileType(_ profileType: ProfileType) -> Builder {
            return setField(key: UserField.profileType, value: profileType.rawValue)
        }

        /// Sets the unique identifier for the program to which the user will belong.
        ///
        /// - Parameter programToken: The unique identifier for the program to which the user will belong.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func programToken(_ programToken: String) -> Builder {
            return setField(key: UserField.postalCode, value: programToken)
        }

        /// Sets the field value based on the `UserField`
        ///
        /// - Parameters:
        ///   - key: The `UserField` value
        ///   - value: The value
        public func setField(key: UserField, value: String) -> Builder {
            return setField(key: key.rawValue, value: value)
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
            return setField(key: UserField.stateProvince, value: stateProvince)
        }

        /// Sets the user account status.
        ///
        /// - Parameter status: The user's state, province or region.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func status(_ status: Status) -> Builder {
            return setField(key: UserField.status, value: status.rawValue)
        }

        /// Sets the local time of a region or a country. e.g. GMT, PST, ...
        ///
        /// - Parameter timeZone: The local time of a region or a country.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func timeZone(_ timeZone: String) -> Builder {
            return setField(key: UserField.timeZone, value: timeZone)
        }
        /// Sets the unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
        ///
        /// - Parameter token: The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func token(_ token: String) -> Builder {
            return setField(key: UserField.token, value: token)
        }

        /// Sets the the user's verification status. A user may be required to verify their identity after a certain
        /// threshold of payments is reached.
        ///
        /// - Parameter verificationStatus: The user's verification status. A user may be required to verify their
        ///                                 identity after a certainthreshold of payments is reached.
        /// - Returns: a self reference of `HyperwalletUser.Builder` instance.
        public func verificationStatus(_ verificationStatus: VerificationStatus) -> Builder {
            return setField(key: UserField.verificationStatus, value: verificationStatus.rawValue)
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
            return CodingKeys(stringValue: key)!
        }
    }
}
