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

/// The `HyperwalletTransferMethodConfigurationKeyResult` protocol for processing the transfer method configuration
/// key result from the Hyperwallet platform.
public protocol HyperwalletTransferMethodConfigurationKeyResult:
HyperwalletTransferMethodConfigurationTransactionResult {
    /// Returns the list of countries
    ///
    /// - Returns: a list of countries
    func countries() -> [String]

    /// Returns the list of currencies based on the country
    ///
    /// - Parameter country: the 2 letter ISO 3166-1 country code
    /// - Returns: a list of currencies
    func currencies(from country: String) -> [String]

    /// Returns the list of transfer method types based on the parameters
    ///
    /// - Parameters:
    ///   - country: the 2 letter ISO 3166-1 country code
    ///   - currency: the 3 letter ISO 4217-1 currency code
    ///   - profileType: the `TransferMethodType`
    /// - Returns: a list of transfer method types
    func transferMethodTypes(country: String, currency: String, profileType: String) -> [String]
}
