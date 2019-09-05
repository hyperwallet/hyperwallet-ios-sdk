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

/// Representation of the user's bank card
public class HyperwalletBankCard: HyperwalletTransferMethod {
    override private init(data: [String: AnyCodable]) {
        super.init(data: data)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    /// The card brand
    public var cardBrand: String? {
        return getField(TransferMethodField.cardBrand.rawValue)
    }

    /// The card number
    public var cardNumber: String? {
        return getField(TransferMethodField.cardNumber.rawValue)
    }

    /// The card type
    public var cardType: String? {
        return getField(TransferMethodField.cardType.rawValue)
    }

    /// The card security code which is embossed or printed on the card.
    public var cvv: String? {
        return getField(TransferMethodField.cvv.rawValue)
    }

    /// The expiration date.
    public var dateOfExpiry: String? {
        return getField(TransferMethodField.dateOfExpiry.rawValue)
    }

    /// A helper class to build the `HyperwalletBankCard` instance.
    public final class Builder {
        private var storage = [String: AnyCodable]()

        /// Creates a new instance of the `HyperwalletBankCard.Builder` based on the required parameter to update
        /// Bank card.
        ///
        /// - Parameter token: The bank card token.
        public init(token: String) {
            storage[TransferMethodField.token.rawValue] = AnyCodable(value: token)
        }

        /// Creates a new instance of the `HyperwalletBankCard.Builder` based on the required parameters to create
        /// Bank card.
        ///
        /// - Parameters:
        ///   - transferMethodCountry: The bank card country.
        ///   - transferMethodCurrency: The bank card currency.
        ///   - transferMethodProfileType: The method profile type
        public init(transferMethodCountry: String, transferMethodCurrency: String, transferMethodProfileType: String) {
            storage[TransferMethodField.type.rawValue] = AnyCodable(value: TransferMethodType.bankCard.rawValue)
            storage[TransferMethodField.transferMethodCountry.rawValue] = AnyCodable(value: transferMethodCountry)
            storage[TransferMethodField.transferMethodCurrency.rawValue] = AnyCodable(value: transferMethodCurrency)
            storage[TransferMethodField.profileType.rawValue] = AnyCodable(value: transferMethodProfileType)
        }

        /// Builds a new instance of the `HyperwalletBankCard`.
        ///
        /// - Returns: a new instance of the `HyperwalletBankCard`.
        public func build() -> HyperwalletBankCard {
            return HyperwalletBankCard(data: self.storage)
        }

        /// Sets the card number
        ///
        /// - Parameter cardNumber: The 16-digit card number
        /// - Returns: a self reference of `HyperwalletBankCard.Builder` instance.
        public func cardNumber(_ cardNumber: String) -> Builder {
            storage[TransferMethodField.cardNumber.rawValue] = AnyCodable(value: cardNumber)
            return self
        }

        /// Sets the card security code which is embossed or printed on the card.
        ///
        /// - Parameter cvv: the card security code which is embossed or printed on the card
        /// - Returns: a self reference of `HyperwalletBankCard.Builder` instance.
        public func cvv(_ cvv: String) -> Builder {
            storage[TransferMethodField.cvv.rawValue] = AnyCodable(value: cvv)
            return self
        }

        /// Sets the expiration date.
        ///
        /// - Parameter dateOfExpiry: the expiration date for the card (YYYY-MM).
        /// - Returns: a self reference of `HyperwalletBankCard.Builder` instance.
        public func dateOfExpiry(_ dateOfExpiry: String) -> Builder {
            storage[TransferMethodField.dateOfExpiry.rawValue] = AnyCodable(value: dateOfExpiry)
            return self
        }
    }
}
