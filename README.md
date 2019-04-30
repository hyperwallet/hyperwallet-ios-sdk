# Hyperwallet iOS Core SDK

Welcome to Hyperwallet's iOS SDK. This library will help you create transfer methods in your iOS app, such as bank account, Paypal account, etc. See our [iOS Integration Guide](https://www.hyperwallet.com/developers/) to get started!

Note that this SDK is geared towards those who only require backend data, which means you will have to build your own UI.

We also provide an out-of-the-box  [Hyperwallet iOS UI SDK](https://github.com/hyperwallet/hyperwallet-ios-ui-sdk-sandbox) for you if you decide not to build your own UI.

## Prerequisites
* A Hyperwallet merchant account
* Set Up your server to manage the user's authentication process on the Hyperwallet platform. See the  [Authentication](#Authentication) section for more information.
* iOS 10.0+
* Xcode 10.2+
* Swift 4.2

## Installation
Use [Carthage](https://github.com/Carthage/Carthage) or [CocoaPods](https://cocoapods.org/) to integrate to HyperwalletSDK.
### Carthage
Specify it in your Cartfile:
```ogdl
github "hyperwallet/hyperwallet-ios-sdk" "1.0.0-beta01"
```

### CocoaPods
Specify it in your Podfile:
```ruby
pod 'HyperwalletSDK', '~> 1.0.0-beta01'
```

## Initialization
After you're done installing the SDK, you need to initialize an instance in order to utilize core SDK functions. Also, you need to provide a HyperwalletAuthenticationTokenProvider object to retrieve an authentication token.

Add in the header:
```
import HyperwalletSDK
```

Initialize the `HyperwalletSDK` with a `HyperwalletAuthenticationTokenProvider` implementation instance:
```
Hyperwallet.setup(authenticationTokenProvider :HyperwalletAuthenticationTokenProvider)
```

## Authentication
Your server side should be able to send a POST request to Hyperwallet  endpoint `/rest/v3/users/{user-token}/authentication-token` to retrieve an [authentication token](https://jwt.io/). 
Then, you need to provide a class (an authentication provider) which implements HyperwalletAuthenticationTokenProvider to retrieve an authentication token from your server.

An example implementation using the  `URLRequest` from Swift  Foundation :
```swift
import Foundation
import HyperwalletSDK

public struct AuthenticationTokenProvider: HyperwalletAuthenticationTokenProvider {
    private let url = URL(string: "http://your/server/to/retrieve/authenticationToken")!

    public func retrieveAuthenticationToken(
        completionHandler: @escaping HyperwalletAuthenticationTokenProvider.CompletionHandler) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                    guard let data = data,
                        let clientToken = String(data: data, encoding: .utf8),
                        let response = response as? HTTPURLResponse else {
                            completionHandler(nil, HyperwalletAuthenticationErrorType.unexpected(error?.localizedDescription ??
                                "authentication token cannot be retrieved"))
                            return
                    }

                    switch response.statusCode {
                        case 200 ..< 300:
                            completionHandler(clientToken, nil)

                        default:
                            completionHandler(nil, HyperwalletAuthenticationErrorType
                                .unexpected("authentication token cannot be retrieved"))
                }
            }
        }
        task.resume()
    }
}
```
## Usage
The functions in the core SDK are available to use once the authentication is done.



### Get User
```swift
Hyperwallet.shared.getUser { (user, error) in
    guard error == nil else {
        print(error?.getHyperwalletErrors()?.errorList?)
        return
    } 
    
    print(user?.firstName)
    print(user?.lastName)
}
```

### Create Bank Account

```swift
let bankAccount = HyperwalletBankAccount.Builder(transferMethodCountry: "US", transferMethodCurrency: "USD")
.bankAccountId("12345")
.branchId("123456")
.bankAccountPurpose(.checking)
.build()

Hyperwallet.shared.createBankAccount(account: bankAccount, completion: { (result, error) in
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure of account creation
    guard error == nil else {
        print(error?.getHyperwalletErrors()?.errorList?)
        return
    }   
    
    // In case of successful creation, response (HyperwalletBankAccount in this case) payload will contain information about the account created
    print(result)
})
```
### Get Bank Account
```swift
Hyperwallet.shared.getBankAccount(transferMethodToken: "123123", completion: { (result, error) in
    // In case of successful, response (HyperwalletBankCard? in this case) will contain information about the user’s bank account or nil if not exist.
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure 
})
```

### Update Bank Account

```swift
let bankAccount = HyperwalletBankAccount
.Builder(token: "12345")
.branchId("026009593")
.build()

Hyperwallet.shared.updateBankAccount(account: bankAccount, completion: { (response, error) in
    // Code to handle successful response or error
    // In case of successful creation, response (HyperwalletBankAccount in this case) payload will contain information about the account updated
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure of account updating
})
```

### Deactivate Bank Account

```swift
Hyperwallet.shared.deactivateBankAccount(transferMethodToken: "trm-12345", notes: "deactivate bank account", completion: { (result, error) in
    // Code to handle successful response or error
    // In case of successful creation, response (HyperwalletStatusTransition in this case) will contain information about the status transition
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure of account deactivation
})
```

### List Bank Account
```swift
let bankAccountPagination = HyperwalletBankAccountPagination()
bankAccountPagination.status = .activated
bankAccountPagination.sortBy = .ascendantCreatedOn

Hyperwallet.shared.listBankAccounts(pagination: bankAccountPagination) { (result, error) in 
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure 
    guard error == nil else {
        print(error?.getHyperwalletErrors()?.errorList?)
        return
    }
    
    // In case of successful, response (HyperwalletPageList<HyperwalletBankAccount>? in this case) will contain information about or nil if not exist.
    if let bankAccounts = result?.data {
        for bankAccount in bankAccounts {
            print(bankAccount.getField(fieldName: .token) ?? "")
        }
    }
}
```

### Create Bank Card
```swift
let bankCard = HyperwalletBankCard.Builder(transferMethodCountry: "US", transferMethodCurrency: "USD")
.cardNumber("1234123412341234")
.dateOfExpiry("2022-12")
.cvv("123")
.build()

Hyperwallet.shared.createBankCard(account: bankCard, completion: { (result, error) in
    // Code to handle successful response or error
    // In case of successful creation, response (HyperwalletBankCard in this case) will contain information about the user’s bank card
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure of bank card creation
})
```

### Get Bank Card
```swift
Hyperwallet.shared.getBankCard(transferMethodToken: "123123", completion: { (result, error) in
    // In case of successful, response (HyperwalletBankCard? in this case) will contain information about the user’s bank card or nil if not exist.
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure 
})
```

### Update Bank Card 
```swift
let bankCard = HyperwalletBankCard
.Builder(token: "trm-12345")
.dateOfExpiry("2022-12")
.build()

Hyperwallet.shared.updateBankCard(account: bankCard, completion: { (result, error) in
    // Code to handle successful response or error
    // In case of successful creation, response (HyperwalletBankCard in this case) will contain information about the user’s bank card
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure of bank card updating
})
```

### Deactivate Bank Card
```swift
Hyperwallet.shared.deactivateBankCard(transferMethodToken: "trm-12345", notes: "deactivate bank card", completion: { (result, error) in
    // Code to handle successful response or error
    // In case of successful creation, response (HyperwalletStatusTransition in this case) will contain information about the status transition
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure of bank card deactivation
})
```

### List Bank Card
```swift
let bankCardPagination = HyperwalletBankCardPagination()
bankCardPagination.status = .activated
bankCardPagination.sortBy = .ascendantCreatedOn

Hyperwallet.shared.listBankCards(pagination: bankCardPagination) { (result, error) in
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure 
    guard error == nil else {
        print(error?.getHyperwalletErrors()?.errorList?)
        return
    }
    
    // In case of successful, response (HyperwalletPageList<HyperwalletBankCard>? in this case) will contain information about or nil if not exist.
    if let bankCards = result?.data {
        for bankCard in bankCards {
            print(bankCard.getField(fieldName: .token) ?? "")
        }
    }
}
```

### List Transfer Methods
```swift
let transferMethodPagination = HyperwalletTransferMethodPagination()
transferMethodPagination.sortBy = .ascendantCreatedOn

Hyperwallet.shared.listTransferMethods(pagination: transferMethodPagination) { (result, error) in
    // In case of failure, error (ErrorType) will contain HyperwalletErrors containing information about what caused the failure 
    guard error == nil else {
        print(error?.getHyperwalletErrors()?.errorList?)
        return
    }
    
    // In case of successful, response (HyperwalletPageList<HyperwalletTransferMethod>? in this case) will contain information about or nil if not exist.
    if let transferMethods = result?.data {
        for transferMethod in transferMethods {
            print(transferMethod.getField(fieldName: .token) ?? "")
        }
    }
}
```

## Transfer Method Configurations 

### Get countries, currencies and transfer method types
```swift
let keysQuery = HyperwalletTransferMethodConfigurationKeysQuery()

Hyperwallet.shared.retrieveTransferMethodConfigurationKeys(request: keysQuery) { (result, error) in
    
    guard error == nil else {
        print(error?.getHyperwalletErrors()?.errorList?)
        return
    }

    guard let result = result else { return }
    // Get countries
    let countryCodes = result.countries()
    
    // Get currencies based on the first country
    let transferMethodCurrencies = result.currencies(from: countryCodes.first)
    
    // Get transfer method types based on the country, currency and profile type
    let transferMethodTypes = result.transferMethodTypes(country: countryCodes.first,
                                                         currency: transferMethodCurrencies.first,
                                                         profileType: "INDIVIDUAL") // Could be INDIVIDUAL or BUSINESS
                               
    print(countryCodes)
    print(transferMethodCurrencies)
    print(transferMethodTypes)
}
```

### Get fields for a transfer method type
```swift
let fieldQuery = HyperwalletTransferMethodConfigurationFieldQuery(country: "CA",
                                                                  currency: "USD",
                                                                  transferMethodType: "BANK_ACCOUNT",
                                                                  profile: "INDIVIDUAL")

Hyperwallet.shared.retrieveTransferMethodConfigurationFields(request: fieldQuery) { (result, error) in

    guard error == nil else {
        print(error?.getHyperwalletErrors()?.errorList?)
        return
    }

    guard let result = result else { return }
    
    print(result.fields())
}
```

## License
The Hyperwallet iOS SDK is open source and available under the [MIT](https://github.com/hyperwallet/hyperwallet-ios-sdk/blob/master/LICENSE) license
