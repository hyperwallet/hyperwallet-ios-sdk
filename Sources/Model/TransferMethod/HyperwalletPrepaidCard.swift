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
/// Representation of the user's Prepaid card account
@objcMembers
public final class HyperwalletPrepaidCard: HyperwalletTransferMethod {
    override private init(data: [String: AnyCodable]) {
        super.init(data: data)
    }
    /// The required initializer
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// The prepaid card's type
    public var cardType: String? {
        getField(TransferMethodField.cardType.rawValue)
    }

    /// The prepaid card's package
    public var cardPackage: String? {
        getField(TransferMethodField.cardPackage.rawValue)
    }

    /// The prepaid card's number
    public var cardNumber: String? {
        getField(TransferMethodField.cardNumber.rawValue)
    }

    /// The prepaid card's brand
    public var cardBrand: String? {
        getField(TransferMethodField.cardBrand.rawValue)
    }

    /// The prepaid card's expiry date
    public var dateOfExpiry: String? {
        getField(TransferMethodField.dateOfExpiry.rawValue)
    }

    /// The prepaid card's user token (instant issue cards only)
    public var userToken: String? {
        getField(TransferMethodField.userToken.rawValue)
    }

    /// A helper class to build the `HyperwalletPrepaidCard` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Creates a new instance of the `HyperwalletPayPalAccount` based on the required parameter to update
        /// PayPal account.
        ///
        /// - Parameter token: The PayPal account token.
        public init(token: String) {
            storage[TransferMethodField.token.rawValue] = AnyCodable(value: token)
        }

        /// Creates a new instance of the `HyperwalletPrepaidCard` based on the required parameters to create
        /// prepaid card account.
        ///
        /// - Parameters:
        ///   - transferMethodProfileType: The prepaid card account holder's profile type, e.g. INDIVIDUAL or BUSINESS
        public init(transferMethodProfileType: String) {
            storage[TransferMethodField.type.rawValue] = AnyCodable(value: TransferMethodType.prepaidCard.rawValue)
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: transferMethodProfileType)
        }

        /// Sets the card package
        ///
        /// - Parameter cardPackage: The card package name or identifier. You must provide an exact cardPackage value
        ///                          that has been been configured for the program or leave it blank.
        ///                          If left blank, the default card package will be automatically selected.
        /// - Returns: a self `HyperwalletPrepaidCard.Builder` instance.
        public func cardPackage(_ cardPackage: String) -> Builder {
            storage[TransferMethodField.cardPackage.rawValue] = AnyCodable(value: cardPackage)
            return self
        }

        /// Sets userToken for an instant issue card
        ///
        /// - Parameter userToken: The unique, auto-generated user identifier. Max 64 characters, prefixed with "usr-".
        /// - Returns: a self `HyperwalletPrepaidCard.Builder` instance.
        public func userToken(_ userToken: String) -> Builder {
            storage[TransferMethodField.userToken.rawValue] = AnyCodable(value: userToken)
            return self
        }

        /// Builds a new instance of the `HyperwalletPrepaidCard`.
        ///
        /// - Returns: a new instance of the `HyperwalletPrepaidCard`.
        public func build() -> HyperwalletPrepaidCard {
            HyperwalletPrepaidCard(data: self.storage)
        }
    }
}
