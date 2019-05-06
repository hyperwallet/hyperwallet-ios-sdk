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

        /// Sets the bank account number, IBAN or equivalent. If you are providing an IBAN, the first two
        /// letters of the IBAN must match the `transferMethodCountry`
        ///
        /// - Parameter bankAccountId: The bank account number, IBAN or equivalent.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func bankAccountId(_ bankAccountId: String) -> Builder {
            storage[TransferMethodField.bankAccountId.rawValue] = AnyCodable(value: bankAccountId)
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

        /// Sets the bank account branch code, transit number, routing number or equivalent.
        ///
        /// - Parameter branchId: The branch code, transit number, routing number or equivalent.
        /// - Returns: a self `HyperwalletBankAccount.Builder` instance.
        public func branchId(_ branchId: String) -> Builder {
            storage[TransferMethodField.branchId.rawValue] = AnyCodable(value: branchId)
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
