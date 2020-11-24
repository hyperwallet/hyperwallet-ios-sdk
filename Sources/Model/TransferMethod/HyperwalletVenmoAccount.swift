//
// Copyright 2020 - Present Hyperwallet
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

/// Representation of the user's Venmo account
@objcMembers
public final class HyperwalletVenmoAccount: HyperwalletTransferMethod {
    override private init(data: [String: AnyCodable]) {
        super.init(data: data)
    }
    /// The required initializer
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// The accountId as phone number.
    public var accountId: String? {
        getField(TransferMethodField.accountId.rawValue)
    }

    /// A helper class to build the `HyperwalletVenmoAccount` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Creates a new instance of the `HyperwalletVenmoAccount` based on the required parameter to update
        /// Venmo account.
        ///
        /// - Parameter token: The Venmo account token.
        public init(token: String) {
            storage[TransferMethodField.token.rawValue] = AnyCodable(value: token)
        }

        /// Creates a new instance of the `HyperwalletVenmoAccount` based on the required parameters to create
        /// Venmo account.
        ///
        /// - Parameters:
        ///   - transferMethodCountry: The Venmo account country.
        ///   - transferMethodCurrency: The Venmo account currency.
        ///   - transferMethodProfileType: The Venmo account holder's profile type, e.g. INDIVIDUAL or BUSINESS
        public init(transferMethodCountry: String, transferMethodCurrency: String, transferMethodProfileType: String) {
            storage[TransferMethodField.type.rawValue] = AnyCodable(value: TransferMethodType.venmoAccount.rawValue)
            storage[TransferMethodField.transferMethodCountry.rawValue] = AnyCodable(value: transferMethodCountry)
            storage[TransferMethodField.transferMethodCurrency.rawValue] = AnyCodable(value: transferMethodCurrency)
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: transferMethodProfileType)
        }

        /// Sets the accountId address
        ///
        /// - Parameter accountId: The accountId as phone number user want to create a Venmo account
        /// - Returns: a self `HyperwalletVenmoAccount.Builder` instance.
        public func accountId(_ accountId: String) -> Builder {
            storage[TransferMethodField.accountId.rawValue] = AnyCodable(value: accountId)
            return self
        }

        /// Sets the bank account holder's profile type.
        ///
        /// - Parameter profileType: The Venmo account holder's profile type, e.g. INDIVIDUAL or BUSINESS
        /// - Returns: a self `HyperwalletVenmoAccount.Builder` instance.
        public func profileType(_ profileType: String) -> Builder {
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: profileType)
            return self
        }

        /// Builds a new instance of the `HyperwalletVenmoAccount`.
        ///
        /// - Returns: a new instance of the `HyperwalletVenmoAccount`.
        public func build() -> HyperwalletVenmoAccount {
            HyperwalletVenmoAccount(data: self.storage)
        }
    }
}
