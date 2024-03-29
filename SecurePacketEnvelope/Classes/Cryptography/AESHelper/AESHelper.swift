//
//  AESHelper.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 6/13/22.
//

import Foundation
import CommonCrypto

enum AESConfig {
    static let padding : Int = kCCOptionPKCS7Padding
    static let encryptOperation = kCCEncrypt
    static let decryptOperation = kCCDecrypt
    static let algorithm = kCCAlgorithmAES
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
            let encrypt = aes_CBC_256(operation: AESConfig.encryptOperation,
                                   algorithm: AESConfig.algorithm,
                                   options: AESConfig.padding,
                                   key: key,
                                   initializationVector: iv,
                                   dataIn: data)
        else { return nil }
        let base64Data = encrypt.base64EncodedData()
        return String(data: base64Data, encoding: .utf8)
    }
    ///  Key can be 128/192/256 bits.
    /// Encrypts for you with all the good options turned on: CBC, an IV, PKCS7
    /// padding (so your input data doesn't have to be any particular length).
    /// Key can be 128, 192, or 256 bits.
    /// Generates a fresh IV for you each time, and prefixes it to the
    /// returned ciphertext.
    func aesDecrypt(data : String, key: String, iv: String) -> String? {
        guard
            let data = Data(base64Encoded: data),
            let key = key.data(using: .utf8),
            let iv = iv.data(using: .utf8),
            let decrypt = aes_CBC_256(operation: AESConfig.decryptOperation,
                                   algorithm: AESConfig.algorithm,
                                   options: AESConfig.padding,
                                   key: key,
                                   initializationVector: iv,
                                   dataIn: data)
        else { return nil }
        return String(data: decrypt, encoding: .utf8)
    }
    
    private func aes_CBC_256(operation: Int,
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
