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

/// The `HyperwalletTransferMethodUpdateConfigurationField` protocol for processing the update transfer method
/// configuration field result from the Hyperwallet platform.
public protocol HyperwalletTransferMethodUpdateConfigurationField {
    /// Returns `TransferMethodConfiguration`
    ///
    /// - Returns: `TransferMethodConfiguration`
    func transferMethodUpdateConfiguration() -> HyperwalletTransferMethodConfiguration?
}

final class TransferMethodUpdateConfigurationFieldResult: HyperwalletTransferMethodUpdateConfigurationField {
    private let transferMethodUpdateUIConfigurations: [HyperwalletTransferMethodConfiguration]?

    /// Creates a new instance of the 'TransferMethodUpdateConfigurationFieldResult' based on the
    /// transfer method configuration result
    ///
    /// - Parameters:
    ///   - transferMethodUpdateUIConfigurations: the GraphQL `[TransferMethodConfiguration]`
    init(_ transferMethodUpdateUIConfigurations: [HyperwalletTransferMethodConfiguration]?) {
        self.transferMethodUpdateUIConfigurations = transferMethodUpdateUIConfigurations
    }

    func transferMethodUpdateConfiguration() -> HyperwalletTransferMethodConfiguration? {
        transferMethodUpdateUIConfigurations?.first
    }
}
