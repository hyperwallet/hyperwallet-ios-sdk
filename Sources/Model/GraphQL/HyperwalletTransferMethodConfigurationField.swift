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

/// The `HyperwalletTransferMethodConfigurationField` protocol for processing the transfer method
/// configuration field result from the Hyperwallet platform.
public protocol HyperwalletTransferMethodConfigurationField {
    /// Returns a list of `HyperwalletField`
    ///
    /// - Returns: a list of `HyperwalletFieldGroup`
    func fieldGroups() -> [HyperwalletFieldGroup]?

    /// Returns the list of transfer method types based on the parameters
    ///
    /// - Returns: HyperwalletTransferMethodType
    func transferMethodType() -> HyperwalletTransferMethodType?
}

final class TransferMethodConfigurationFieldResult: HyperwalletTransferMethodConfigurationField {
    private let transferMethodUIConfigurations: [TransferMethodConfiguration]?
    private let country: HyperwalletCountry?

    /// Creates a new instance of the 'HyperwalletTransferMethodConfigurationField' based on the
    /// transfer method configuration result
    ///
    /// - Parameters:
    ///   - transferMethodUIConfigurations: the GraphQL `[TransferMethodUIConfiguration]`
    ///   - country: the GraphQL `HyperwalletCountry`
    init(_ transferMethodUIConfigurations: [TransferMethodConfiguration]?, _ country: HyperwalletCountry?) {
        self.transferMethodUIConfigurations = transferMethodUIConfigurations
        self.country = country
    }

    func fieldGroups() -> [HyperwalletFieldGroup]? {
        transferMethodUIConfigurations?.first?.fieldGroups?.nodes
    }

    func transferMethodType() -> HyperwalletTransferMethodType? {
        country?.currencies?.nodes?.first?.transferMethodTypes?.nodes?.first
    }
}
