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

/// The `HyperwalletTransferMethodConfigurationKey` protocol for processing the transfer method configuration
/// key result from the Hyperwallet platform.
public protocol HyperwalletTransferMethodConfigurationKey {
    /// Returns the list of countries
    ///
    /// - Returns: a list of HyperwalletCountry object
    func countries() -> [HyperwalletCountry]?

    /// Returns the list of currencies based on the country
    ///
    /// - Parameter countryCode: the 2 letter ISO 3166-1 country code
    /// - Returns: a list of HyperwalletCurrency object
    func currencies(from countryCode: String) -> [HyperwalletCurrency]?

    /// Returns the list of transfer method types based on the parameters
    ///
    /// - Parameters:
    ///   - countryCode: the 2 letter ISO 3166-1 country code
    ///   - currencyCode: the 3 letter ISO 4217-1 currency code
    /// - Returns: a list of HyperwalletTransferMethodTypes
    func transferMethodTypes(countryCode: String, currencyCode: String) -> [HyperwalletTransferMethodType]?
}

/// The 'TransferMethodConfigurationKeyResult' class processes the GraphQL transfer method configuration result
final class TransferMethodConfigurationKeyResult: HyperwalletTransferMethodConfigurationKey {
    private let hyperwalletCountries: [HyperwalletCountry]?

    /// Creates a new instance of the 'HyperwalletTransferMethodConfigurationKey' based on the
    /// transfer method configuration result
    ///
    /// - Parameter hyperwalletCountries: the GraphQL `Connection<HyperwalletCountry>`
    init(_ hyperwalletCountries: [HyperwalletCountry]?) {
        self.hyperwalletCountries = hyperwalletCountries
    }

    /// Returns the list of countries
    ///
    /// - Returns: a list of countries
    func countries() -> [HyperwalletCountry]? {
        hyperwalletCountries
    }

    /// Returns the list of currencies based on the country
    ///
    /// - Parameter countryCode: the 2 letter ISO 3166-1 country code
    /// - Returns: a list of currencies
    func currencies(from countryCode: String) -> [HyperwalletCurrency]? {
        hyperwalletCountries?.first(where: { $0.code == countryCode })?.currencies?.nodes
    }

    /// Returns the list of transfer method types based on the parameters
    ///
    /// - Parameters:
    ///   - countryCode: the 2 letter ISO 3166-1 country code
    ///   - currencyCode: the 3 letter ISO 4217-1 currency code
    /// - Returns: a list of transfer method types
    func transferMethodTypes(countryCode: String, currencyCode: String) -> [HyperwalletTransferMethodType]? {
        currencies(from: countryCode)?.first(where: { $0.code == currencyCode })?.transferMethodTypes?.nodes
    }
}
