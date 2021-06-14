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

/// The `Hyperwallet` class is an iOS specific implementation of the
/// [Hyperwallet platform User APIs.](https://portal.hyperwallet.com/docs)
///
/// A single instance of the `Hyperwallet` class is maintained. Resetting the current instance by calling
/// `setup(_: HyperwalletAuthenticationTokenProvider)` is critical when switching between authenticated Users.
/// Failure to do so will result in incorrect access and incorrect modifications to User data.
///
/// Authentication with the Hyperwallet platform is accomplished through the usage of JSON Web Tokens. At
/// instantiation an `HyperwalletAuthenticationTokenProvider` is set as a member variable to provide
/// the `Hyperwallet` class with an authentication token upon request.
@objcMembers
public final class Hyperwallet: NSObject {
    private var httpTransaction: HTTPTransaction!
    private static var instance: Hyperwallet?
    private var provider: HyperwalletAuthenticationTokenProvider

    /// Returns the previously initialized instance of the Hyperwallet Core SDK interface object
    public static var shared: Hyperwallet {
        guard let instance = instance else {
            fatalError("Call Hyperwallet.setup(_:) before accessing Hyperwallet.shared")
        }
        return instance
    }

    private init(_ provider: HyperwalletAuthenticationTokenProvider) {
        self.provider = provider
        self.httpTransaction = HTTPTransaction(provider: provider)
    }

    /// Clears Hyperwallet instance.
    public static func clearInstance() {
        if let httpTransaction = instance?.httpTransaction {
            httpTransaction.invalidate()
        }
        instance = nil
    }

    /// Creates a new instance of the Hyperwallet Core SDK interface object. If a previously created instance exists,
    /// it will be replaced.
    ///
    /// - Parameter provider: a provider of Hyperwallet authentication tokens.
    public static func setup(_ provider: HyperwalletAuthenticationTokenProvider) {
        if instance == nil {
            instance = Hyperwallet(provider)
        }
    }

    /// Retrieves a configuration if one exists - else using the authentication token from the provider,
    /// it tries to fetch the configuration object again and returns it else error
    ///
    /// - Parameter completion: the callback handler of responses from the Hyperwallet platform
    public func getConfiguration(completion: @escaping (Configuration?, HyperwalletErrorType?) -> Void ) {
        if let configuration = httpTransaction.configuration {
            completion(configuration, nil)
        } else {
            provider.retrieveAuthenticationToken(
                completionHandler: retrieveAuthenticationTokenResponseHandler(completion: completion))
        }
    }

    /// Returns the `HyperwalletUser` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)` or nil
    /// if none exists.
    ///
    /// The `completion: @escaping (HyperwalletUser?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletUser) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameter completion: the callback handler of responses from the Hyperwallet platform
    public func getUser(completion: @escaping (HyperwalletUser?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Creates a `HyperwalletBankAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletBankAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletBankAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletBankAccount` to be created
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func createBankAccount(account: HyperwalletBankAccount,
                                  completion: @escaping (HyperwalletBankAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/bank-accounts",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Creates a `HyperwalletPaperCheck` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletPaperCheck?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful response(HyperwalletPaperCheck)
    /// or error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletPaperCheck` to be created
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func createPaperCheck(
        account: HyperwalletPaperCheck,
        completion: @escaping (HyperwalletPaperCheck?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/paper-checks",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Creates a `HyperwalletBankCard` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletBankCard?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletBankCard) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// @param bankCard
    /// @param listener
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletBankCard` to be created
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func createBankCard(account: HyperwalletBankCard,
                               completion: @escaping (HyperwalletBankCard?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/bank-cards",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Creates a `HyperwalletPayPalAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletPayPalAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletPayPalAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletPayPalAccount` to be created
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func createPayPalAccount(account: HyperwalletPayPalAccount,
                                    completion: @escaping (HyperwalletPayPalAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/paypal-accounts",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Creates a `HyperwalletTransfer` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletTransfer?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletTransfer) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transfer: the `HyperwalletTransfer` to be created
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func createTransfer(transfer: HyperwalletTransfer,
                               completion: @escaping (HyperwalletTransfer?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "transfers",
                                    payload: transfer,
                                    completionHandler: completion)
    }

    /// Creates a `HyperwalletVenmoAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletVenmoAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletVenmoAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletVenmoAccount` to be created
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func createVenmoAccount(account: HyperwalletVenmoAccount,
                                   completion: @escaping (HyperwalletVenmoAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/venmo-accounts",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Deactivates the `HyperwalletBankAccount` linked to the transfer method token specified. The
    /// `HyperwalletBankAccount` being deactivated must belong to the User that is associated with the
    /// authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletStatusTransition?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletStatusTransition) or
    /// error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via  HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletBankAccount`
    ///                          being deactivated
    ///   - notes: a note regarding the status change
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func deactivateBankAccount(transferMethodToken: String,
                                      notes: String? = nil,
                                      completion: @escaping (HyperwalletStatusTransition?,
                                                             HyperwalletErrorType?) -> Void) {
        let statusTransition = HyperwalletStatusTransition.Builder(notes: notes, transition: .deactivated).build()
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/bank-accounts/\(transferMethodToken)/status-transitions",
                                    payload: statusTransition,
                                    completionHandler: completion)
    }

    /// Deactivates the `HyperwalletPaperCheck` linked to the transfer method token specified. The
    /// `HyperwalletPaperCheck` being deactivated must belong to the User that is associated with the
    /// authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletStatusTransition?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletStatusTransition) or
    /// error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via  HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletPaperCheck`
    ///                          being deactivated
    ///   - notes: a note regarding the status change
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func deactivatePaperCheck(transferMethodToken: String,
                                     notes: String? = nil,
                                     completion: @escaping (HyperwalletStatusTransition?,
                                                             HyperwalletErrorType?) -> Void) {
        let statusTransition = HyperwalletStatusTransition.Builder(notes: notes, transition: .deactivated).build()
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/paper-checks/\(transferMethodToken)/status-transitions",
                                    payload: statusTransition,
                                    completionHandler: completion)
    }

    /// Deactivates the `HyperwalletBankCard` linked to the transfer method token specified. The
    /// `HyperwalletBankCard` being deactivated must belong to the User that is associated with the
    /// authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletStatusTransition?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletStatusTransition) or
    /// error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletBankCard`
    ///                          being deactivated
    ///   - notes: a note regarding the status change
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func deactivateBankCard(transferMethodToken: String,
                                   notes: String? = nil,
                                   completion: @escaping (HyperwalletStatusTransition?,
                                                          HyperwalletErrorType?) -> Void) {
        let statusTransition = HyperwalletStatusTransition.Builder(notes: notes, transition: .deactivated).build()
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/bank-cards/\(transferMethodToken)/status-transitions",
                                    payload: statusTransition,
                                    completionHandler: completion)
    }

    /// Deactivates the `HyperwalletPayPalAccount` linked to the transfer method token specified. The
    /// `HyperwalletPayPalAccount` being deactivated must belong to the User that is associated with the
    /// authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletStatusTransition?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletStatusTransition) or
    /// error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletPayPalAccount`
    ///                          being deactivated
    ///   - notes: a note regarding the status change
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func deactivatePayPalAccount(transferMethodToken: String,
                                        notes: String? = nil,
                                        completion: @escaping (HyperwalletStatusTransition?,
                                                               HyperwalletErrorType?) -> Void) {
        let statusTransition = HyperwalletStatusTransition.Builder(notes: notes, transition: .deactivated).build()
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/paypal-accounts/\(transferMethodToken)/status-transitions",
                                    payload: statusTransition,
                                    completionHandler: completion)
    }

    /// Deactivates the `HyperwalletVenmoAccount` linked to the transfer method token specified. The
    /// `HyperwalletVenmoAccount` being deactivated must belong to the User that is associated with the
    /// authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletStatusTransition?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletStatusTransition) or
    /// error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletVenmoAccount`
    ///                          being deactivated
    ///   - notes: a note regarding the status change
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func deactivateVenmoAccount(transferMethodToken: String,
                                       notes: String? = nil,
                                       completion: @escaping (HyperwalletStatusTransition?,
                                                              HyperwalletErrorType?) -> Void) {
        let statusTransition = HyperwalletStatusTransition.Builder(notes: notes, transition: .deactivated).build()
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/venmo-accounts/\(transferMethodToken)/status-transitions",
                                    payload: statusTransition,
                                    completionHandler: completion)
    }

    /// Schedules the `HyperwalletTransfer` linked to the transfer method token specified.
    ///
    /// The `completion: @escaping (HyperwalletStatusTransition?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletStatusTransition) or
    /// error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferToken: the Hyperwallet specific unique identifier for the `HyperwalletTransfer`
    ///                    being commited
    ///   - notes: a note regarding the status change
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func scheduleTransfer(transferToken: String,
                                 notes: String? = nil,
                                 completion: @escaping (HyperwalletStatusTransition?, HyperwalletErrorType?) -> Void) {
        let statusTransition = HyperwalletStatusTransition.Builder(notes: notes, transition: .scheduled).build()
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "transfers/\(transferToken)/status-transitions",
                                    payload: statusTransition,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletBankAccount` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletBankAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletBankAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletBankAccount`
    ///                          being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getBankAccount(transferMethodToken: String,
                               completion: @escaping (HyperwalletBankAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/bank-accounts/\(transferMethodToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletPaperCheck` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletPaperCheck?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful response(HyperwalletPaperCheck)
    /// or error(HyperwalletErrorType) from processing the request.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletPaperCheck`
    ///                          being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getPaperCheck(
        transferMethodToken: String,
        completion: @escaping (HyperwalletPaperCheck?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/paper-checks/\(transferMethodToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletBankCard` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletBankCard?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletBankCard) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletBankCard`
    ///                          being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getBankCard(transferMethodToken: String,
                            completion: @escaping (HyperwalletBankCard?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/bank-cards/\(transferMethodToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletPayPalAccount` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletPayPalAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletPayPalAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletPayPalAccount`
    ///                          being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getPayPalAccount(transferMethodToken: String,
                                 completion: @escaping (HyperwalletPayPalAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/paypal-accounts/\(transferMethodToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletPrepaidCard` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletPrepaidCard?, HyperwalletErrorType?) -> Void` that is passed in to
    /// this method invocation will receive the successful response(HyperwalletPrepaidCard) or
    /// error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletPrepaidCard`
    ///                          being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getPrepaidCard(transferMethodToken: String,
                               completion: @escaping (HyperwalletPrepaidCard?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/prepaid-cards/\(transferMethodToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletTransfer` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletTransfer?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletTransfer) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// - Parameters:
    ///   - transferToken: the Hyperwallet specific unique identifier for the `HyperwalletTransfer`
    ///                    being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getTransfer(transferToken: String,
                            completion: @escaping (HyperwalletTransfer?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "transfers/\(transferToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletVenmoAccount` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletVenmoAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletVenmoAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletVenmoAccount`
    ///                          being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getVenmoAccount(transferMethodToken: String,
                                completion: @escaping (HyperwalletVenmoAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/venmo-accounts/\(transferMethodToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the list of `HyperwalletBankAccount`s for the User associated with the authentication token
    /// returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletBankAccount`s will be based on the criteria specified within
    /// the `HyperwalletBankAccountQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied:
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Type: Bank Account
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletBankAccount>?, HyperwalletErrorType?) -> Void` that
    /// is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletBankAccount>?) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listBankAccounts(queryParam: HyperwalletBankAccountQueryParam? = nil,
                                 completion: @escaping (HyperwalletPageList<HyperwalletBankAccount>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/bank-accounts",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the list of `HyperwalletPaperCheck`s for the User associated with the authentication token
    /// returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletPaperCheck`s will be based on the criteria specified within
    /// the `HyperwalletPaperCheckQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied:
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Type: Paper Check
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletPaperCheck>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletPaperCheck>?) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listPaperChecks(queryParam: HyperwalletPaperCheckQueryParam? = nil,
                                completion: @escaping (HyperwalletPageList<HyperwalletPaperCheck>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/paper-checks",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletBankCard` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletBankCard` will be based on the criteria specified within the
    /// `HyperwalletBankAccountQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Type: Bank Card
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletBankCard>?, HyperwalletErrorType?) -> Void` that is
    /// passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletBankCard>?) or error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listBankCards(queryParam: HyperwalletBankCardQueryParam? = nil,
                              completion: @escaping (HyperwalletPageList<HyperwalletBankCard>?,
                                                     HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/bank-cards",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletPayPalAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletPayPalAccount` will be based on the criteria specified within the
    /// `HyperwalletPayPalAccountQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletPayPalAccount>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletPayPalAccount>?) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listPayPalAccounts(queryParam: HyperwalletPayPalAccountQueryParam? = nil,
                                   completion: @escaping (HyperwalletPageList<HyperwalletPayPalAccount>?,
                                                          HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/paypal-accounts",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletTransferMethod` (Bank Account, Bank Card, PayPay Account, Prepaid Card, Paper Checks)
    /// for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletBankCard` will be based on the criteria specified within the
    /// `HyperwalletBankAccountQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Type: All
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletTransferMethod>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletTransferMethod>?) or error(HyperwalletErrorType) from processing
    /// the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listTransferMethods(queryParam: HyperwalletTransferMethodQueryParam? = nil,
                                    completion: @escaping (HyperwalletPageList<HyperwalletTransferMethod>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/transfer-methods",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletPrepaidCard`
    /// for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletPrepaidCard` will be based on the criteria specified within the
    /// `HyperwalletPrepaidCardQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletPrepaidCard>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletPrepaidCard>?) or error(HyperwalletErrorType) from processing
    /// the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listPrepaidCards(queryParam: HyperwalletPrepaidCardQueryParam? = nil,
                                 completion: @escaping (HyperwalletPageList<HyperwalletPrepaidCard>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/prepaid-cards",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletVenmoAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletVenmoAccount` will be based on the criteria specified within the
    /// `HyperwalletVenmoQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletVenmoAccount>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletVenmoAccount>?) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listVenmoAccounts(queryParam: HyperwalletVenmoQueryParam? = nil,
                                  completion: @escaping (HyperwalletPageList<HyperwalletVenmoAccount>?,
                                                         HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/venmo-accounts",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the list of receipts for the User associated with the authentication token.
    ///
    /// The ordering and filtering of `HyperwalletReceipt` will be based on the criteria specified within the
    /// `HyperwalletReceiptQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Currency: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletReceipt>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletReceipt>?) or error(HyperwalletErrorType) from processing
    /// the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listUserReceipts(queryParam: HyperwalletReceiptQueryParam? = nil,
                                 completion: @escaping (HyperwalletPageList<HyperwalletReceipt>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/receipts",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    // Returns the list of receipts for the User associated with the Prepaid card token.
    ///
    /// The filtering of `HyperwalletReceipt` will be based on the criteria specified within the
    /// `HyperwalletReceiptQueryParam` object. CreatedAfter needs to be provided to get the receipts.
    /// Receipts are returned sorted in ascending order of creation date
    ///
    /// * Created Before: N/A
    /// * Created After: “Some Date”
    /// * Currency: All
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletReceipt>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletReceipt>?) or error(HyperwalletErrorType) from processing
    /// the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listPrepaidCardReceipts(prepaidCardToken: String,
                                        queryParam: HyperwalletReceiptQueryParam? = nil,
                                        completion: @escaping (HyperwalletPageList<HyperwalletReceipt>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/prepaid-cards/\(prepaidCardToken)/receipts",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the list of transfers for the User associated with the authentication token.
    ///
    /// The ordering and filtering of `HyperwalletTransfer` will be based on the criteria specified within the
    /// `HyperwalletTransferQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * clientTransferId: N/A
    /// * destinationToken: N/A
    /// * sourceToken: N/A
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletTransfer>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletTransfer>?) or error(HyperwalletErrorType) from processing
    /// the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listTransfers(queryParam: HyperwalletTransferQueryParam? = nil,
                              completion: @escaping (HyperwalletPageList<HyperwalletTransfer>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "transfers",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the transfer method configuration field set for the User that is associated with the authentication
    /// token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletTransferMethodConfigurationField?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletTransferMethodConfigurationField) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - request: containing a transfer method configuration key tuple of country, currency,
    ///              transfer method type and profile
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func retrieveTransferMethodConfigurationFields(
        request: HyperwalletTransferMethodConfigurationFieldQuery,
        completion: @escaping (HyperwalletTransferMethodConfigurationField?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performGraphQl(request,
                                       completionHandler: transferMethodConfigurationFieldResponseHandler(completion))
    }

    /// Returns the transfer method update configuration fields set for the User that is associated with
    /// the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletTransferMethodUpdateConfigurationField?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletTransferMethodUpdateConfigurationField) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - request: GraphQL query  containing  transfer method token  and required configuration fields
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func retrieveTransferMethodUpdateConfigurationFields(
        request: HyperwalletTransferMethodUpdateConfigurationFieldQuery,
        completion: @escaping (HyperwalletTransferMethodUpdateConfigurationField?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performGraphQl(request, completionHandler:
            transferMethodUpdateConfigurationFiledResponseHandler(completion))
    }

    /// Returns the transfer method configuration key set for the User that is associated
    /// with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletTransferMethodConfigurationKey?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletTransferMethodConfigurationKey) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - request: containing the transfer method configuration key query
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func retrieveTransferMethodConfigurationKeys(
        request: HyperwalletTransferMethodConfigurationKeysQuery,
        completion: @escaping (HyperwalletTransferMethodConfigurationKey?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performGraphQl(request,
                                       completionHandler: transferMethodConfigurationKeyResponseHandler(completion))
    }

    /// Returns the transfer method configuration processing times, and fees for the User that is associated
    /// with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletTransferMethodConfigurationKey?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletTransferMethodConfigurationFeeAndProcessingTime) or
    /// error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - request: containing the transfer method configuration key query
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func retrieveFeeAndProcessingTime(
        request: HyperwalletTransferMethodConfigurationFeeAndProcessingTimeQuery,
        completion: @escaping (HyperwalletTransferMethodConfigurationKey?,
                               HyperwalletErrorType?) -> Void) {
        httpTransaction.performGraphQl(request,
                                       completionHandler: transferMethodConfigurationKeyResponseHandler(completion))
    }

    /// Updates the `HyperwalletBankAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// To identify the `HyperwalletBankAccount` that is going to be updated, the transfer method token must be
    /// set as part of the `HyperwalletBankAccount` object passed in.
    ///
    /// The `completion: @escaping (HyperwalletBankAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletBankAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - parameters: account: the `HyperwalletBankAccount` to be updated
    /// - parameters: completion: the callback handler of responses from the Hyperwallet platform
    public func updateBankAccount(account: HyperwalletBankAccount,
                                  completion: @escaping (HyperwalletBankAccount?, HyperwalletErrorType?) -> Void) {
        let token = account.token ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/bank-accounts/\(token)",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Updates the `HyperwalletPaperCheck` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// To identify the `HyperwalletPaperCheck` that is going to be updated, the transfer method token must be
    /// set as part of the `HyperwalletPaperCheck` object passed in.
    ///
    /// The `completion: @escaping (HyperwalletPaperCheck?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful response(HyperwalletPaperCheck)
    /// or error(HyperwalletErrorType) from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - parameters: account: the `HyperwalletPaperCheck` to be updated
    /// - parameters: completion: the callback handler of responses from the Hyperwallet platform
    public func updatePaperCheck(
        account: HyperwalletPaperCheck,
        completion: @escaping (HyperwalletPaperCheck?, HyperwalletErrorType?) -> Void) {
        let token = account.token ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/paper-checks/\(token)",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Updates the `HyperwalletBankCard` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// To identify the `HyperwalletBankCard` that is going to be updated, the transfer method token must be
    /// set as part of the `HyperwalletBankCard` object passed in.
    ///
    /// The `completion: @escaping (HyperwalletBankCard?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletBankCard) or error(HyperwalletErrorType) from
    /// processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletBankCard` to be updated
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func updateBankCard(account: HyperwalletBankCard,
                               completion: @escaping (HyperwalletBankCard?, HyperwalletErrorType?) -> Void) {
        let token = account.token ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/bank-cards/\(token)",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Updates the `HyperwalletPayPalAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// To identify the `HyperwalletPayPalAccount` that is going to be updated, the transfer method token must be
    /// set as part of the `HyperwalletPayPalAccount` object passed in.
    ///
    /// The `completion: @escaping (HyperwalletPayPalAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletPayPalAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletPayPalAccount` to be updated
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func updatePayPalAccount(account: HyperwalletPayPalAccount,
                                    completion: @escaping (HyperwalletPayPalAccount?, HyperwalletErrorType?) -> Void) {
        let token = account.token ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/paypal-accounts/\(token)",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Updates the `HyperwalletVenmoAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// To identify the `HyperwalletVenmoAccount` that is going to be updated, the transfer method token must be
    /// set as part of the `HyperwalletVenmoAccount` object passed in.
    ///
    /// The `completion: @escaping (HyperwalletVenmoAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletVenmoAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletVenmoAccount` to be updated
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func updateVenmoAccount(account: HyperwalletVenmoAccount,
                                   completion: @escaping (HyperwalletVenmoAccount?, HyperwalletErrorType?) -> Void) {
        let token = account.token ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/venmo-accounts/\(token)",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Returns the list of balances for the User associated with the authentication token.
    ///
    /// The ordering and filtering of `HyperwalletBalance` will be based on the criteria specified within the
    /// `HyperwalletBalanceQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Currency: All
    /// * Sort By: currency
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletBalance>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletBalance>?) or error(HyperwalletErrorType) from processing
    /// the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listUserBalances(queryParam: HyperwalletBalanceQueryParam? = nil,
                                 completion: @escaping (HyperwalletPageList<HyperwalletBalance>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/balances",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    /// Returns the list of prepaid card balances for the User associated with the authentication token.
    ///
    /// The ordering and filtering of `HyperwalletBalance` will be based on the criteria specified within the
    /// `HyperwalletPrepaidCardBalanceQueryParam` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Sort By: currency
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletBalance>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletBalance>?) or error(HyperwalletErrorType) from processing
    /// the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - prepaidCardToken: the prepaid card token
    ///   - queryParam: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listPrepaidCardBalances(prepaidCardToken: String,
                                        queryParam: HyperwalletPrepaidCardBalanceQueryParam? = nil,
                                        completion: @escaping (HyperwalletPageList<HyperwalletBalance>?,
                                                               HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/prepaid-cards/\(prepaidCardToken)/balances",
                                    payload: "",
                                    queryParam: queryParam,
                                    completionHandler: completion)
    }

    private func transferMethodConfigurationFieldResponseHandler(_ completionHandler:
            @escaping (TransferMethodConfigurationFieldResult?, HyperwalletErrorType?) -> Void)
        -> (TransferMethodConfigurationField?, HyperwalletErrorType?) -> Void { { (response, error) in
                let result =
                    TransferMethodConfigurationFieldResult(response?.transferMethodCreateUIConfigurations?.nodes,
                                                           response?.countries?.nodes?.first)
                completionHandler(result, error)
            }
    }

    private func transferMethodUpdateConfigurationFiledResponseHandler(_ completionHandler:
            @escaping (TransferMethodUpdateConfigurationFieldResult?, HyperwalletErrorType?) -> Void)
        -> (TransferMethodUpdateConfigurationField?, HyperwalletErrorType?) -> Void { { (response, error) in
                let result = TransferMethodUpdateConfigurationFieldResult(response?
                    .transferMethodUpdateUIConfigurations?
                    .nodes)
                completionHandler(result, error)
            }
    }

    private func transferMethodConfigurationKeyResponseHandler(_ completionHandler:
            @escaping (TransferMethodConfigurationKeyResult?, HyperwalletErrorType?) -> Void)
        -> (TransferMethodConfigurationKey?, HyperwalletErrorType?) -> Void { { (response, error) in
                completionHandler(TransferMethodConfigurationKeyResult(response?.countries?.nodes), error)
            }
    }

    private func retrieveAuthenticationTokenResponseHandler(
        completion: @escaping (Configuration?, HyperwalletErrorType?) -> Void)
        -> (String?, Error?) -> Void { {(authenticationToken, error) in
            guard error == nil else {
                completion(nil, ErrorTypeHelper.authenticationError(
                    message: "Error occured while retrieving authentication token",
                    for: error as? HyperwalletAuthenticationErrorType ?? HyperwalletAuthenticationErrorType
                        .unexpected("Authentication token cannot be retrieved"))
                )
                return
            }
            do {
                let configuration = try AuthenticationTokenDecoder.decode(from: authenticationToken)
                self.httpTransaction.configuration = configuration
                completion(configuration, nil)
            } catch {
                if let error = error as? HyperwalletErrorType {
                    completion(nil, error)
                }
            }
        }
    }
}
