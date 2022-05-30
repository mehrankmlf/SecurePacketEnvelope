//
//  Data + Extension.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import Foundation
import CommonCrypto

/// @see http://www.splinter.com.au/2019/06/09/pure-swift-common-crypto-aes-encryption/
public extension Data {
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
