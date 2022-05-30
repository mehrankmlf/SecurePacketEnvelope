//
//  String + Extension.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import Foundation

public extension String {
    func aesEncrypt(key: String, iv: String) -> String? {
        guard
            let data = self.data(using: .utf8),
            let key = key.data(using: .utf8),
            let iv = iv.data(using: .utf8),
            let encrypt = data.encryptAES256(key: key, iv: iv)
            else { return nil }
        let base64Data = encrypt.base64EncodedData()
        return String(data: base64Data, encoding: .utf8)
    }

    func aesDecrypt(key: String, iv: String) -> String? {
        guard
            let data = Data(base64Encoded: self),
            let key = key.data(using: .utf8),
            let iv = iv.data(using: .utf8),
            let decrypt = data.decryptAES256(key: key, iv: iv)
            else { return nil }
        return String(data: decrypt, encoding: .utf8)
    }
    
    /// - bytesHexLiteral: Hex string of bytes
    /// - base64: Base64 string
    enum ExpandedEncoding {
        /// Hex string of bytes
        case bytesHexLiteral
        /// Base64 string
        case base64
    }
    
    /// Convert to `Data` with expanded encoding
    ///
    /// - Parameter encoding: Expanded encoding
    /// - Returns: data
    func data(using encoding: ExpandedEncoding) -> Data? {
        switch encoding {
        case .bytesHexLiteral:
            guard self.count % 2 == 0 else { return nil }
            var data = Data()
            var byteLiteral = ""
            for (index, character) in self.enumerated() {
                if index % 2 == 0 {
                    byteLiteral = String(character)
                } else {
                    byteLiteral.append(character)
                    guard let byte = UInt8(byteLiteral, radix: 16) else { return nil }
                    data.append(byte)
                }
            }
            return data
        case .base64:
            return Data(base64Encoded: self)
        }
    }
}
