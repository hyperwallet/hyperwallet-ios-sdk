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

/// The 'HyperwalletTransferMethodConfigurationResult' class processes the GraphQL transfer method configuration result
final class TransferMethodConfigurationResult: HyperwalletTransferMethodConfigurationFieldResult,
HyperwalletTransferMethodConfigurationKeyResult {
    private let response: Connection<TransferMethodConfiguration>

    /// Creates a new instance of the 'HyperwalletTransferMethodConfigurationResult' based on the
    /// transfer method configuration result
    ///
    /// - Parameter response: the GraphQL `Connection<TransferMethodConfiguration>`
    init(response: Connection<TransferMethodConfiguration>) {
        self.response = response
    }

    /// Returns a list of `HyperwalletField`
    ///
    /// - Returns: a list of `HyperwalletField`
    func fields() -> [HyperwalletField] {
        var fields = [HyperwalletField]()

        guard  let nodes = response.nodes else {
            return fields
        }

        nodes.forEach({ (node) in
            if let fieldList = node.fields {
                fields.append(contentsOf: fieldList) //node.fields
            }
        })

        return fields
    }

    /// Returns the list of countries
    ///
    /// - Returns: a list of countries
    func countries() -> [String] {
        var countrySet = Set<String>()

        guard let nodes = response.nodes else {
            return []
        }

        nodes.forEach { (node) in
            countrySet = countrySet.union(node.countries)
        }

        return Array(countrySet)
    }

    /// Returns the list of currencies based on the country
    ///
    /// - Parameter country: the 2 letter ISO 3166-1 country code
    /// - Returns: a list of currencies
    func currencies(from country: String) -> [String] {
        guard let nodes = response.nodes else {
            return []
        }
        var currencySet = Set<String>()

        nodes.filter { $0.countries.contains(country) } // Filter the node contains the country
            .forEach { $0.currencies.forEach { (currency) in //$0 is node
                currencySet.insert(currency) // Add an unique currency
            }
            }

        return Array(currencySet)
    }

    /// Returns the list of transfer method types based on the parameters
    ///
    /// - Parameters:
    ///   - country: the 2 letter ISO 3166-1 country code
    ///   - currency: the 3 letter ISO 4217-1 currency code
    ///   - profileType: the `TransferMethodType`
    /// - Returns: a list of transfer method types
    func transferMethodTypes(country: String, currency: String, profileType: String) -> [String] {
        let filteredNodes = filterTransferMethodConfigurations(country: country,
                                                               currency: currency,
                                                               profileType: profileType)
        return filteredNodes.map { (transferMethod) in transferMethod.transferMethodType }
    }

    /// Returns the list of transaction fees based on the parameters
    ///
    /// - Parameters:
    ///   - country: the 2 letter ISO 3166-1 country code
    ///   - currency: the 3 letter ISO 4217-1 currency code
    ///   - profileType: the `TransferMethodType`
    ///   - transferMethodType: `INDIVIDUAL` or `BUSINESS`
    /// - Returns: a list of transaction fees, or nil if none exists
    func fees(country: String, currency: String, profileType: String, transferMethodType: String) -> [HyperwalletFee]? {
        let filteredNodes = filterTransferMethodConfigurations(country: country,
                                                               currency: currency,
                                                               profileType: profileType)
        let transferMethodConfiguration = filteredNodes.first { $0.transferMethodType == transferMethodType }
        return transferMethodConfiguration?.fees?.nodes
    }

    /// Returns the processing time based on the parameters
    ///
    /// - Parameters:
    ///   - country: the 2 letter ISO 3166-1 country code
    ///   - currency: the 3 letter ISO 4217-1 currency code
    ///   - profileType: the `TransferMethodType`
    ///   - transferMethodType: `INDIVIDUAL` or `BUSINESS`
    /// - Returns: a processing time, or nil if none exists
    func processingTime(country: String, currency: String, profileType: String, transferMethodType: String) -> String? {
        let filteredNodes = filterTransferMethodConfigurations(country: country,
                                                               currency: currency,
                                                               profileType: profileType)
        let transferMethodConfiguration = filteredNodes.first { $0.transferMethodType == transferMethodType }
        return transferMethodConfiguration?.processingTime
    }

    /// Returns the list of `TransferMethodConfiguration` based on `country`, `currency` and `profileType`
    ///
    /// - parameters: country - The country criteria to filter.
    /// - parameters: currency - The currency criteria to filter.
    /// - parameters: profileType - The profileType criteria to filter.
    ///
    /// - returns: list of transferMethodConfiguration
    private func filterTransferMethodConfigurations(country: String, currency: String, profileType: String)
        -> [TransferMethodConfiguration] {
            guard let nodes = response.nodes else {
                return []
            }

            return nodes.filter {
                $0.countries.contains(country) &&
                    $0.currencies.contains(currency) &&
                    $0.profile == profileType
            }
    }
}
