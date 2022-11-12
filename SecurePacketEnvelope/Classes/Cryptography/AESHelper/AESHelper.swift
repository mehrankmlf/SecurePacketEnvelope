//
//  AESHelper.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 6/13/22.
//

import Foundation
import CommonCrypto

protocol AESHelperProtocol {
    func aesEncrypt(data: String) -> String?
    func aesDecrypt(data : String, key: String, iv: String) -> String?
}

final class AESHelper : AESHelperProtocol {
    
    var iv : String
    var key : String
    
    init(iv : String, key: String) {
        self.iv = iv
        self.key = key
    }

    convenience init() {
        self.init(iv: "", key: "")
    }
    
    func aesEncrypt(data: String) -> String? {
        guard
            let data = data.data(using: .utf8),
            let key = self.key.data(using: .utf8),
            let iv = self.iv.data(using: .utf8),
            let encrypt = data.encryptAES256(key: key, iv: iv)
        else { return nil }
        let base64Data = encrypt.base64EncodedData()
        return String(data: base64Data, encoding: .utf8)
    }
    
    func aesDecrypt(data : String, key: String, iv: String) -> String? {
        guard
            let data = Data(base64Encoded: data),
            let key = key.data(using: .utf8),
            let iv = iv.data(using: .utf8),
            let decrypt = data.decryptAES256(key: key, iv: iv)
        else { return nil }
        return String(data: decrypt, encoding: .utf8)
    }
}

/// @see http://www.splinter.com.au/2019/06/09/pure-swift-common-crypto-aes-encryption/
private extension Data {
    /// Encrypts for you with all the good options turned on: CBC, an IV, PKCS7
    /// padding (so your input data doesn't have to be any particular length).
    /// Key can be 128, 192, or 256 bits.
    /// Generates a fresh IV for you each time, and prefixes it to the
    /// returned ciphertext.
    func encryptAES256(key: Data, iv: Data, options: Int = kCCOptionPKCS7Padding) -> Data? {
        // No option is needed for CBC, it is on by default.
        return aesCrypt(operation: kCCEncrypt,
                        algorithm: kCCAlgorithmAES,
                        options: options,
                        key: key,
                        initializationVector: iv,
                        dataIn: self)
    }
    
    /// Decrypts self, where self is the IV then the ciphertext.
    /// Key can be 128/192/256 bits.
    func decryptAES256(key: Data, iv: Data, options: Int = kCCOptionPKCS7Padding) -> Data? {
        guard count > kCCBlockSizeAES128 else { return nil }
        return aesCrypt(operation: kCCDecrypt,
                        algorithm: kCCAlgorithmAES,
                        options: options,
                        key: key,
                        initializationVector: iv,
                        dataIn: self)
    }
    
    // swiftlint:disable:next function_parameter_count
    private func aesCrypt(operation: Int,
                          algorithm: Int,
                          options: Int,
                          key: Data,
                          initializationVector: Data,
                          dataIn: Data) -> Data? {
        return initializationVector.withUnsafeBytes { ivUnsafeRawBufferPointer in
            return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
                return dataIn.withUnsafeBytes { dataInUnsafeRawBufferPointer in
                    // Give the data out some breathing room for PKCS7's padding.
                    let dataOutSize: Int = dataIn.count + kCCBlockSizeAES128 * 2
                    let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize, alignment: 1)
                    defer { dataOut.deallocate() }
                    var dataOutMoved: Int = 0
                    let status = CCCrypt(CCOperation(operation),
                                         CCAlgorithm(algorithm),
                                         CCOptions(options),
                                         keyUnsafeRawBufferPointer.baseAddress, key.count,
                                         ivUnsafeRawBufferPointer.baseAddress,
                                         dataInUnsafeRawBufferPointer.baseAddress, dataIn.count,
                                         dataOut, dataOutSize,
                                         &dataOutMoved)
                    guard status == kCCSuccess else { return nil }
                    return Data(bytes: dataOut, count: dataOutMoved)
                }
            }
        }
    }
}
