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

/// Decodes a Authentication token into an object that holds the decoded body.
/// If the token cannot be decoded a `Hyperwallet ErrorType` will be thrown.
struct AuthenticationTokenDecoder {
    /// Retrieves the `Configuration` based on the Authentication Token payload
    ///
    /// - parameter from: The authentication token data.
    ///
    /// - throws: An error if the authentication token cannot be decoded
    ///
    /// - returns: A `Configuration` instance.
    static func decode(from token: String?) throws -> Configuration {
        guard let token = token else {
            throw ErrorTypeHelper.parseError(message: "Invalid Authnetication token")
        }
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3,
            !parts[1].isEmpty,
            let payload = base64UrlDecode(parts[1]),
            var config = try? JSONDecoder().decode(Configuration.self, from: payload) else {
                throw ErrorTypeHelper.parseError(message: "Invalid Authnetication token")
        }

        config.authorization = token
        return config
    }

    /// Converts the `value` encoded in Base64URL to Base64
    ///
    /// - returns: an `Data` encoded in base64.
    private static func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        // Add the mandatory `=` if the length is different
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64.append(padding)
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}
