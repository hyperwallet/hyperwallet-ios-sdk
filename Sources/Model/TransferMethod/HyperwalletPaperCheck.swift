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

/// Representation of the user's paper check
@objcMembers
public class HyperwalletPaperCheck: HyperwalletTransferMethod {
    override private init(data: [String: AnyCodable]) {
        super.init(data: data)
    }
    /// The required initializer
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// The user's relationship with the bank account holder.
    public var bankAccountRelationship: String? {
        getField(TransferMethodField.bankAccountRelationship.rawValue)
    }

    /// The bank account holder's street address.
    public var addressLine1: String? {
        getField(TransferMethodField.addressLine1.rawValue)
    }

    /// The bank account holder's address, second line.
    public var addressLine2: String? {
        getField(TransferMethodField.addressLine2.rawValue)
    }

    /// The bank account holder's city.
     public var city: String? {
         getField(TransferMethodField.city.rawValue)
     }

     /// The bank account holder's country.
     public var country: String? {
         getField(TransferMethodField.country.rawValue)
     }

    /// The bank account holder's postal code.
    public var postalCode: String? {
        getField(TransferMethodField.postalCode.rawValue)
    }

    /// The bank account holder's state, province or region.
    public var stateProvince: String? {
        getField(TransferMethodField.stateProvince.rawValue)
    }

    /// The bank account holder's state, province or region.
    public var shippingMethod: String? {
        getField(TransferMethodField.shippingMethod.rawValue)
    }

    /// The name of the bank account holder's business.
    public var businessName: String? {
        getField(TransferMethodField.businessName.rawValue)
    }

    /// The country where the bank account holder's business is registered.
    public var businessRegistrationCountry: String? {
        getField(TransferMethodField.businessRegistrationCountry.rawValue)
    }

    /// The bank account holder's business registration number or identifier,
    /// as assigned by the relevant government body.
    public var businessRegistrationId: String? {
        getField(TransferMethodField.businessRegistrationId.rawValue)
    }

    /// The state, province or region where the bank account holder's business is registered.
    public var businessRegistrationStateProvince: String? {
        getField(TransferMethodField.businessRegistrationStateProvince.rawValue)
    }

    /// The bank account holder's business type.
    public var businessType: String? {
        getField(TransferMethodField.businessType.rawValue)
    }

    /// The bank account holder's birth country.
    public var countryOfBirth: String? {
        getField(TransferMethodField.countryOfBirth.rawValue)
    }

    /// The bank account holder's nationality country.
    public var countryOfNationality: String? {
        getField(TransferMethodField.countryOfNationality.rawValue)
    }

    /// The bank account holder's date of birth (All users must be at least 13 years old).
    public var dateOfBirth: String? {
        getField(TransferMethodField.dateOfBirth.rawValue)
    }

    /// The bank account holder's driver's license number.
    public var driversLicenseId: String? {
        getField(TransferMethodField.driversLicenseId.rawValue)
    }

    /// The bank account holder's employer identifier, generally used for tax purposes.
    public var employerId: String? {
        getField(TransferMethodField.employerId.rawValue)
    }

    /// The bank account holder's first name.
    public var firstName: String? {
        getField(TransferMethodField.firstName.rawValue)
    }

    /// The bank account holder's gender.
    public var gender: String? {
        getField(TransferMethodField.gender.rawValue)
    }

    /// The bank account holder's government ID number, such as a Social Security Number.
    public var governmentId: String? {
        getField(TransferMethodField.governmentId.rawValue)
    }

    /// The bank account holder's government ID type.
    public var governmentIdType: String? {
        getField(TransferMethodField.governmentIdType.rawValue)
    }

    /// The bank account holder's phone number.
    public var phoneNumber: String? {
        getField(TransferMethodField.phoneNumber.rawValue)
    }

    /// The bank account holder's cell phone number.
    public var mobileNumber: String? {
        getField(TransferMethodField.mobileNumber.rawValue)
    }

    /// The bank account holder's last name.
    public var lastName: String? {
        getField(TransferMethodField.lastName.rawValue)
    }

    /// The bank account holder's middle name.
    public var middleName: String? {
        getField(TransferMethodField.middleName.rawValue)
    }

    /// The bank account holder's passport number.
    public var passportId: String? {
        getField(TransferMethodField.passportId.rawValue)
    }

    /// A helper class to build the `HyperwalletPaperCheck` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Creates a new instance of the `HyperwalletPaperCheck.Builder`
        /// based on the required parameter to updaate Bank card.
        ///
        /// - Parameter token: The bank card token.
        public init(token: String) {
            storage[TransferMethodField.token.rawValue] = AnyCodable(value: token)
        }

        /// Creates a new instance of the `HyperwalletPaperCheck.Builder`
        /// based on the required parameters to create paper check.
        ///
        /// - Parameters:
        ///   - transferMethodCountry: The bank account country.
        ///   - transferMethodCurrency: The bank account currency.
        ///   - transferMethodProfileType: The bank account holder's profile type, e.g. INDIVIDUAL or BUSINESS
        ///   - transferMethodType: The bank account type, i.e, PAPER_CHECK
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
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func addressLine1(_ addressLine1: String) -> Builder {
           storage[TransferMethodField.addressLine1.rawValue] = AnyCodable(value: addressLine1)
           return self
        }

        /// Sets the bank account holder's address, second line.
        ///
        /// - Parameter addressLine2: The bank account holder's address, second line.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func addressLine2(_ addressLine2: String) -> Builder {
            storage[TransferMethodField.addressLine2.rawValue] = AnyCodable(value: addressLine2)
            return self
        }

        /// Sets the user's relationship with the bank account holder.
        ///
        /// - Parameter relationship: The `RelationshipType`
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func bankAccountRelationship(_ relationship: String) -> Builder {
            storage[TransferMethodField.bankAccountRelationship.rawValue] = AnyCodable(value: relationship)
            return self
        }

        /// Sets the bank account holder's city.
        ///
        /// - Parameter city: The bank account holder's city.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func city(_ city: String) -> Builder {
            storage[TransferMethodField.city.rawValue] = AnyCodable(value: city)
            return self
        }

        /// Sets the bank account holder's country.
        ///
        /// - Parameter country: The bank account holder's country.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func country(_ country: String) -> Builder {
            storage[TransferMethodField.country.rawValue] = AnyCodable(value: country)
            return self
        }

        /// Sets the bank account holder's postal code.
        ///
        /// - Parameter postalCode: The bank account holder's postal code.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func postalCode(_ postalCode: String) -> Builder {
            storage[TransferMethodField.postalCode.rawValue] = AnyCodable(value: postalCode)
            return self
        }

        /// Sets the shipping method for paper check.
        ///
        /// - Parameter shippingMethod: The bank account holder's postal code.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func shippingMethod(_ shippingMethod: String) -> Builder {
            storage[TransferMethodField.shippingMethod.rawValue] = AnyCodable(value: shippingMethod)
            return self
        }

        /// Sets the bank account holder's state, province or region.
        ///
        /// - Parameter stateProvince: The bank account holder's state, province or region.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func stateProvince(_ stateProvince: String) -> Builder {
            storage[TransferMethodField.stateProvince.rawValue] = AnyCodable(value: stateProvince)
            return self
        }

        // Sets the bank account holder's profile type.
        ///
        /// - Parameter profileType: The bank account holder's profile type, e.g. INDIVIDUAL or BUSINESS
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func profileType(_ profileType: String) -> Builder {
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: profileType)
            return self
        }

        /// Sets the bank account holder's last name.
        ///
        /// - Parameter lastName: The bank account holder's last name.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func lastName(_ lastName: String) -> Builder {
            storage[TransferMethodField.lastName.rawValue] = AnyCodable(value: lastName)
            return self
        }

        /// Sets the bank account holder's middle name.
        ///
        /// - Parameter middleName: The bank account holder's middle name.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func middleName(_ middleName: String) -> Builder {
            storage[TransferMethodField.middleName.rawValue] = AnyCodable(value: middleName)
            return self
        }

        /// Sets the bank account holder's cell phone number.
        ///
        /// - Parameter mobileNumber: The bank account holder's cell phone number.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func mobileNumber(_ mobileNumber: String) -> Builder {
            storage[TransferMethodField.mobileNumber.rawValue] = AnyCodable(value: mobileNumber)
            return self
        }

        /// Sets the bank account holder's passport number.
        ///
        /// - Parameter passportId: The bank account holder's passport number.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func passportId(_ passportId: String) -> Builder {
            storage[TransferMethodField.passportId.rawValue] = AnyCodable(value: passportId)
            return self
        }

        /// Sets the bank account holder's phone number.
        ///
        /// - Parameter phoneNumber: The bank account holder's phone number.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func phoneNumber(_ phoneNumber: String) -> Builder {
            storage[TransferMethodField.phoneNumber.rawValue] = AnyCodable(value: phoneNumber)
            return self
        }

        /// Sets the bank account holder's birth country.
        ///
        /// - Parameter countryOfBirth: The bank account holder's birth country.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func countryOfBirth(_ countryOfBirth: String) -> Builder {
            storage[TransferMethodField.countryOfBirth.rawValue] = AnyCodable(value: countryOfBirth)
            return self
        }

        // Sets the bank account holder's nationality country.
        ///
        /// - Parameter countryOfNationality: The bank account holder's birth country.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func countryOfNationality(_ countryOfNationality: String) -> Builder {
            storage[TransferMethodField.countryOfNationality.rawValue] = AnyCodable(value: countryOfNationality)
            return self
        }

        /// Sets the bank account holder's date of birth (All users must be at least 13 years old).
        ///
        /// - Parameter dateOfBirth: The bank account holder's date of birth
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func dateOfBirth(_ dateOfBirth: String) -> Builder {
            storage[TransferMethodField.dateOfBirth.rawValue] = AnyCodable(value: dateOfBirth)
            return self
        }

        /// Sets the bank account holder's driver's license number.
        ///
        /// - Parameter driversLicenseId: The bank account holder's driver's license number.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func driversLicenseId(_ driversLicenseId: String) -> Builder {
            storage[TransferMethodField.driversLicenseId.rawValue] = AnyCodable(value: driversLicenseId)
            return self
        }

        /// Sets the bank account holder's employer identifier, generally used for tax purposes.
        ///
        /// - Parameter employerId: The bank account holder's employer identifier, generally used for tax purposes.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func employerId(_ employerId: String) -> Builder {
            storage[TransferMethodField.employerId.rawValue] = AnyCodable(value: employerId)
            return self
        }

        /// Sets the bank account holder's first name.
        ///
        /// - Parameter firstName: The bank account holder's first name.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func firstName(_ firstName: String) -> Builder {
            storage[TransferMethodField.firstName.rawValue] = AnyCodable(value: firstName)
            return self
        }

        /// Sets the bank account holder's gender.
        ///
        /// - Parameter gender: The bank account holder's gender.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func gender(_ gender: String) -> Builder {
            storage[TransferMethodField.gender.rawValue] = AnyCodable(value: gender)
            return self
        }

        /// Sets the bank account holder's government ID number, such as a Social Security Number.
        ///
        /// - Parameter governmentId: The bank account holder's government ID number, such as a Social Security Number.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func governmentId(_ governmentId: String) -> Builder {
            storage[TransferMethodField.governmentId.rawValue] = AnyCodable(value: governmentId)
            return self
        }

        /// Sets the bank account holder's government ID type.
        ///
        /// - Parameter governmentIdType: The bank account holder's government ID type.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func governmentIdType(_ governmentIdType: String) -> Builder {
            storage[TransferMethodField.governmentIdType.rawValue] = AnyCodable(value: governmentIdType)
            return self
        }

        /// Sets the bank account holder's role in the organization.
        ///
        /// - Parameter businessContactRole: The bank account holder's role in the organization.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func businessContactRole(_ businessContactRole: String) -> Builder {
            storage[TransferMethodField.businessContactRole.rawValue] = AnyCodable(value: businessContactRole)
            return self
        }

        /// Sets the name of the bank account holder's business.
        ///
        /// - Parameter businessName: The name of the bank account holder's business.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func businessName(_ businessName: String) -> Builder {
            storage[TransferMethodField.businessName.rawValue] = AnyCodable(value: businessName)
            return self
        }

        /// Sets the country where the bank account holder's business is registered.
        ///
        /// - Parameter businessRegistrationCountry: The country where the bank account holder's business is registered.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func businessRegistrationCountry(_ country: String) -> Builder {
            storage[TransferMethodField.businessRegistrationCountry.rawValue] = AnyCodable(value: country)
            return self
        }

        /// Sets the bank account holder's business registration number or identifier,
        /// as assigned by the relevant government body.
        ///
        /// - Parameter businessRegistrationId: The bank account holder's business
        ///   registration number or identifier, as assigned by the relevant government body.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func businessRegistrationId(_ businessRegistrationId: String) -> Builder {
            storage[TransferMethodField.businessRegistrationId.rawValue] = AnyCodable(value: businessRegistrationId)
            return self
        }

        /// Sets the state, province or region where the bank account holder's business is registered.
        ///
        /// - Parameter businessRegistrationStateProvince: The state, province or region
        ///   where the bank account holder's business is registered.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func businessRegistrationStateProvince(_ stateProvince: String) -> Builder {
            storage[TransferMethodField.businessRegistrationStateProvince.rawValue] = AnyCodable(value: stateProvince)
            return self
        }

        /// Sets the bank account holder's business type.
        ///
        /// - Parameter businessType: The bank account holder's business type.
        /// - Returns: a self `HyperwalletPaperCheck.Builder` instance.
        public func businessType(_ businessType: String) -> Builder {
            storage[TransferMethodField.businessType.rawValue] = AnyCodable(value: businessType)
            return self
        }

        /// Builds a new instance of the `HyperwalletPaperCheck`.
        ///
        /// - Returns: a new instance of the `HyperwalletPaperCheck`.
        public func build() -> HyperwalletPaperCheck {
            HyperwalletPaperCheck(data: self.storage)
        }
    }
}
