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
public final class Hyperwallet {
    private var httpTransaction: HTTPTransaction!
    private static var instance: Hyperwallet?

    /// Returns the previously initialized instance of the Hyperwallet Core SDK interface object
    public static var shared: Hyperwallet {
        guard let instance = instance else {
            fatalError("Call Hyperwallet.setup(_:) before accessing Hyperwallet.shared")
        }
        return instance
    }

    private init(_ provider: HyperwalletAuthenticationTokenProvider) {
        self.httpTransaction = HTTPTransaction(provider: provider)
    }

    /// Creates a new instance of the Hyperwallet Core SDK interface object. If a previously created instance exists,
    /// it will be replaced.
    ///
    /// - Parameter provider: a provider of Hyperwallet authentication tokens.
    public class func setup(_ provider: HyperwalletAuthenticationTokenProvider) {
        if instance?.httpTransaction != nil {
            instance?.httpTransaction.invalidate()
        }
        instance = Hyperwallet(provider)
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

    /// Creates a `HyperwalletPaypalAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletPaypalAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletPaypalAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletPaypalAccount` to be created
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func createPaypalAccount(account: HyperwalletPaypalAccount,
                                    completion: @escaping (HyperwalletPaypalAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/paypal-accounts",
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
        let statusTransition = HyperwalletStatusTransition(transition: .deactivated)
        statusTransition.notes = notes
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/bank-accounts/\(transferMethodToken)/status-transitions",
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
        let statusTransition = HyperwalletStatusTransition(transition: .deactivated)
        statusTransition.notes = notes
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/bank-cards/\(transferMethodToken)/status-transitions",
                                    payload: statusTransition,
                                    completionHandler: completion)
    }

    /// Deactivates the `HyperwalletPaypalAccount` linked to the transfer method token specified. The
    /// `HyperwalletPaypalAccount` being deactivated must belong to the User that is associated with the
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
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletPaypalAccount`
    ///                          being deactivated
    ///   - notes: a note regarding the status change
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func deactivatePaypalAccount(transferMethodToken: String,
                                        notes: String? = nil,
                                        completion: @escaping (HyperwalletStatusTransition?,
                                                               HyperwalletErrorType?) -> Void) {
        let statusTransition = HyperwalletStatusTransition(transition: .deactivated)
        statusTransition.notes = notes
        httpTransaction.performRest(httpMethod: .post,
                                    urlPath: "users/%@/paypal-accounts/\(transferMethodToken)/status-transitions",
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

    /// Returns the `HyperwalletPaypalAccount` linked to the transfer method token specified, or nil if none exists.
    ///
    /// The `completion: @escaping (HyperwalletPaypalAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletPaypalAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// - Parameters:
    ///   - transferMethodToken: the Hyperwallet specific unique identifier for the `HyperwalletPaypalAccount`
    ///                          being requested
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func getPaypalAccount(transferMethodToken: String,
                                 completion: @escaping (HyperwalletPaypalAccount?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/paypal-accounts/\(transferMethodToken)",
                                    payload: "",
                                    completionHandler: completion)
    }

    /// Returns the list of `HyperwalletBankAccount`s for the User associated with the authentication token
    /// returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletBankAccount`s will be based on the criteria specified within
    /// the `HyperwalletBankAccountPagination` object, if it is not nil. Otherwise the default ordering and
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
    ///   - pagination: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listBankAccounts(pagination: HyperwalletBankAccountPagination? = nil,
                                 completion: @escaping (HyperwalletPageList<HyperwalletBankAccount>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/bank-accounts",
                                    payload: "",
                                    pagination: pagination,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletBankCard` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletBankCard` will be based on the criteria specified within the
    /// `HyperwalletBankAccountPagination` object, if it is not nil. Otherwise the default ordering and
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
    ///   - pagination: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listBankCards(pagination: HyperwalletBankCardPagination? = nil,
                              completion: @escaping (HyperwalletPageList<HyperwalletBankCard>?,
                                                     HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/bank-cards",
                                    payload: "",
                                    pagination: pagination,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletPaypalAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletPaypalAccount` will be based on the criteria specified within the
    /// `HyperwalletPaypalAccountPagination` object, if it is not nil. Otherwise the default ordering and
    /// filtering will be applied.
    ///
    /// * Offset: 0
    /// * Limit: 10
    /// * Created Before: N/A
    /// * Created After: N/A
    /// * Status: All
    /// * Sort By: Created On
    ///
    /// The `completion: @escaping (HyperwalletPageList<HyperwalletPaypalAccount>?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletPageList<HyperwalletPaypalAccount>?) or error(HyperwalletErrorType) from processing the
    /// request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - pagination: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listPaypalAccounts(pagination: HyperwalletPaypalAccountPagination? = nil,
                                   completion: @escaping (HyperwalletPageList<HyperwalletPaypalAccount>?,
                                                          HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/paypal-accounts",
                                    payload: "",
                                    pagination: pagination,
                                    completionHandler: completion)
    }

    /// Returns the `HyperwalletTransferMethod` (Bank Account, Bank Card, PayPay Account, Prepaid Card, Paper Checks)
    /// for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`,
    /// or nil if non exist.
    ///
    /// The ordering and filtering of `HyperwalletBankCard` will be based on the criteria specified within the
    /// `HyperwalletBankAccountPagination` object, if it is not nil. Otherwise the default ordering and
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
    ///   - pagination: the ordering and filtering criteria
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func listTransferMethods(pagination: HyperwalletTransferMethodPagination? = nil,
                                    completion: @escaping (HyperwalletPageList<HyperwalletTransferMethod>?,
        HyperwalletErrorType?) -> Void) {
        httpTransaction.performRest(httpMethod: .get,
                                    urlPath: "users/%@/transfer-methods",
                                    payload: "",
                                    pagination: pagination,
                                    completionHandler: completion)
    }

    /// Returns the transfer method configuration field set for the User that is associated with the authentication
    /// token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletTransferMethodConfigurationFieldResult?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletTransferMethodConfigurationFieldResult) or error(HyperwalletErrorType) from processing the
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
        completion: @escaping (HyperwalletTransferMethodConfigurationFieldResult?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performGraphQl(request,
                                       completionHandler: transferMethodConfigurationResponseHandler(completion))
    }

    /// Returns the transfer method configuration key set, processing times, and fees for the User that is associated
    /// with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// The `completion: @escaping (HyperwalletTransferMethodConfigurationKeyResult?, HyperwalletErrorType?) -> Void`
    /// that is passed in to this method invocation will receive the successful
    /// response(HyperwalletTransferMethodConfigurationKeyResult) or error(HyperwalletErrorType) from processing the
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
        completion: @escaping (HyperwalletTransferMethodConfigurationKeyResult?, HyperwalletErrorType?) -> Void) {
        httpTransaction.performGraphQl(request,
                                       completionHandler: transferMethodConfigurationResponseHandler(completion))
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
        let token = account.getField(fieldName: .token) as? String ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/bank-accounts/\(token)",
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
        let token = account.getField(fieldName: .token) as? String ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/bank-cards/\(token)",
                                    payload: account,
                                    completionHandler: completion)
    }

    /// Updates the `HyperwalletPaypalAccount` for the User associated with the authentication token returned from
    /// `HyperwalletAuthenticationTokenProvider.retrieveAuthenticationToken(_ : @escaping CompletionHandler)`.
    ///
    /// To identify the `HyperwalletPaypalAccount` that is going to be updated, the transfer method token must be
    /// set as part of the `HyperwalletPaypalAccount` object passed in.
    ///
    /// The `completion: @escaping (HyperwalletPaypalAccount?, HyperwalletErrorType?) -> Void` that is passed in to this
    /// method invocation will receive the successful response(HyperwalletPaypalAccount) or error(HyperwalletErrorType)
    /// from processing the request.
    ///
    /// This function will request a new authentication token via `HyperwalletAuthenticationTokenProvider`
    /// if the current one is expired or is about to expire.
    ///
    /// - Parameters:
    ///   - account: the `HyperwalletPaypalAccount` to be updated
    ///   - completion: the callback handler of responses from the Hyperwallet platform
    public func updatePaypalAccount(account: HyperwalletPaypalAccount,
                                    completion: @escaping (HyperwalletPaypalAccount?, HyperwalletErrorType?) -> Void) {
        let token = account.getField(fieldName: .token) as? String ?? ""
        httpTransaction.performRest(httpMethod: .put,
                                    urlPath: "users/%@/paypal-accounts/\(token)",
                                    payload: account,
                                    completionHandler: completion)
    }

    private func transferMethodConfigurationResponseHandler(_ completionHandler: @escaping (
        (TransferMethodConfigurationResult?, HyperwalletErrorType?) -> Void))
        -> (Connection<TransferMethodConfiguration>?, HyperwalletErrorType?) -> Void {
            return { (response, error) in
                var result: TransferMethodConfigurationResult?

                if let response = response {
                    result = TransferMethodConfigurationResult(response: response)
                }
                completionHandler(result, error)
            }
    }
}
