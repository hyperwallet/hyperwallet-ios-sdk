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
/// Representation of the user's paypal account
public final class HyperwalletPaypalAccount: HyperwalletTransferMethod {
    override private init(data: [String: AnyCodable]) {
        super.init(data: data)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// A helper class to build the `HyperwalletPaypalAccount` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Creates a new instance of the `HyperwalletPaypalAccount` based on the required parameter to update
        /// Paypal account.
        ///
        /// - Parameter token: The paypal account token.
        public init(token: String) {
            storage[TransferMethodField.token.rawValue] = AnyCodable(value: token)
        }

        /// Creates a new instance of the `HyperwalletPaypalAccount` based on the required parameters to create
        /// Paypal account.
        ///
        /// - Parameters:
        ///   - transferMethodCountry: The paypal account country.
        ///   - transferMethodCurrency: The paypal account currency.
        public init(transferMethodCountry: String, transferMethodCurrency: String) {
            storage[TransferMethodField.type.rawValue] = AnyCodable(value: TransferMethodType.paypalAccount.rawValue)
            storage[TransferMethodField.transferMethodCountry.rawValue] = AnyCodable(value: transferMethodCountry)
            storage[TransferMethodField.transferMethodCurrency.rawValue] = AnyCodable(value: transferMethodCurrency)
        }

        /// Sets the email address
        ///
        /// - Parameter email: The email address user want to create a paypal account
        /// - Returns: a self `HyperwalletPaypalAccount.Builder` instance.
        public func email(_ email: String) -> Builder {
            storage[TransferMethodField.email.rawValue] = AnyCodable(value: email)
            return self
        }

        /// Builds a new instance of the `HyperwalletPaypalAccount`.
        ///
        /// - Returns: a new instance of the `HyperwalletPaypalAccount`.
        public func build() -> HyperwalletPaypalAccount {
            return HyperwalletPaypalAccount(data: self.storage)
        }
    }
}
