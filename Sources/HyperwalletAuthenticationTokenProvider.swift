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

/// The `HyperwalletAuthenticationTokenProvider` protocol provides the Hyperwallet iOS Core SDK with an
/// abstraction to retrieve an authentication token. An authentication token is a JSON Web Token that will be used
/// to authenticate the User to the Hyperwallet platform.
///
/// Implementations of `HyperwalletAuthenticationTokenProvider` are expected to be non-blocking and thread safe.
public protocol HyperwalletAuthenticationTokenProvider {
    /// A callback interface to handle the submission of an authentication token or an error message in case of failure.
    ///
    /// The authentication token is a JSON web token that contains as part of its claim set the principal that will
    /// be interacting with the Hyperwallet platform.
    ///
    /// Authentication token will be used until it expires.
    ///
    /// The `HyperwalletAuthenticationErrorType` will contain error in case authentication token
    /// is not retrieved successfully.
    ///
    /// - Parameters:
    ///   - authenticationToken: a JWT token identifying a Hyperwallet User principal
    ///   - error: an `HyperwalletAuthenticationErrorType` indicating the cause of the authentication
    ///            token retrieval error
    typealias CompletionHandler = (_ authenticationToken: String?, _ error: HyperwalletAuthenticationErrorType?) -> Void

    /// Invoked when the Hyperwallet iOS Core SDK requires an authentication token.
    ///
    /// Implementations of this function are expected to call the
    /// `HyperwalletAuthenticationTokenProvider.CompletionHandler(String, nil)` method when an authentication token is
    /// retrieved and the `HyperwalletAuthenticationTokenProvider.CompletionHandler(nil, AuthenticationErrorType)`
    /// when an authentication token is not retrieved.
    ///
    /// - Parameter completionHandler: A completion handler for authentication tokens
    func retrieveAuthenticationToken(completionHandler: @escaping CompletionHandler)
}
