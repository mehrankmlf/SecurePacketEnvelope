//
//  Encryption.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 6/8/22.
//

import Foundation
import CommonCrypto

///
/// Constants
///
private enum SimpleSwiftCryptoConstants {
    static let rsaKeySizeInBits: NSNumber = 2048
    static let aes256KeySize: Int = kCCKeySizeAES256
    static let aesAlgorithm: CCAlgorithm = CCAlgorithm(kCCAlgorithmAES)
    static let aesOptions: CCOptions = CCOptions(kCCOptionPKCS7Padding)
    static let rsaAlgorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
}

///
/// The namespace responsible for cryptographic work in `SimpleSwiftCrypto`
///
public enum SimpleSwiftCrypto {
    ///
    /// Will create a brand new AES private key for symmetric cryptography. Will not
    /// store the key anywhere special (i.e. Keychain), but only stores the new
    /// key in memory and returns.
    ///
    public static func generateRandomAES256Key() -> AES256Key? {
        func makeSecRandomData(_ count: Int) -> Data? {
            var result = [UInt8](repeating: 0, count: count)
            if SecRandomCopyBytes(kSecRandomDefault, count, &result) != 0 {
                return nil
            }
            return Data(result)
        }
        if let iv = makeSecRandomData(SimpleSwiftCryptoConstants.aes256KeySize), let aes256Key = makeSecRandomData(SimpleSwiftCryptoConstants.aes256KeySize) {
            return AES256Key(iv: iv, aes256Key: aes256Key)
        } else {
            return nil
        }
        
    }
    ///
    /// Will create a brand new RSA private and public key pair for asymmetric
    /// cryptography. Will not store the key pair anywhere special (i.e. Keychain),
    /// but only stores the new key in memory and returns.
    ///
    public static func generateRandomRSAKeyPair() -> RSAKeyPair? {
        let privateAttributes: [NSObject : Any] = [
            kSecAttrIsPermanent: false
        ]
        let publicAttributes: [NSObject : Any] = [:]
        let pairAttributes: [NSObject : Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: SimpleSwiftCryptoConstants.rsaKeySizeInBits,
            kSecPublicKeyAttrs: publicAttributes,
            kSecPrivateKeyAttrs: privateAttributes
        ]
        
        var error: Unmanaged<CFError>?
        if let privateKey: SecKey = SecKeyCreateRandomKey(pairAttributes as CFDictionary, &error),
           let publicKey: SecKey = SecKeyCopyPublicKey(privateKey) {
            if error != nil {
                return nil
            } else {
                return RSAKeyPair(privateKey: privateKey, publicKey: publicKey)
            }
        } else {
            return nil
        }
    }
}

///
/// The AES key. Contains both the initialization vector and secret key.
///
public struct AES256Key {
    /// Initialization vector
    private let iv: Data
    private let aes256Key: Data
    #if DEBUG
    public var __debug_iv: Data { iv }
    public var __debug_aes256Key: Data { aes256Key }
    #endif
    fileprivate init(iv: Data, aes256Key: Data) {
        self.iv = iv
        self.aes256Key = aes256Key
    }
    ///
    /// Takes the data and uses the private key to encrypt it. Will call `CCCrypt` in CommonCrypto
    /// and provide it `ivData` for the initialization vector. Will use cipher block chaining (CBC) as
    /// the mode of operation.
    ///
    /// Returns the encrypted data.
    ///
    public func encrypt(data: Data) -> Data? {
        let dataBytes = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
        let dataLength = data.count
        
        if let result = NSMutableData(length: dataLength + self.aes256Key.count + self.iv.count) {
            let keyData = (self.aes256Key as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.aes256Key.count)
            let keyLength = size_t(self.aes256Key.count)
            let ivData = (iv as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.iv.count)
            
            let encryptedData = UnsafeMutablePointer<UInt8>(result.mutableBytes.assumingMemoryBound(to: UInt8.self))
            let encryptedDataLength = size_t(result.length)
            
            var encryptedLength: size_t = 0
            
            let status = CCCrypt(CCOperation(kCCEncrypt), SimpleSwiftCryptoConstants.aesAlgorithm, SimpleSwiftCryptoConstants.aesOptions, keyData, keyLength, ivData, dataBytes, dataLength, encryptedData, encryptedDataLength, &encryptedLength)
            
            if status == Int32(kCCSuccess) {
                result.length = Int(encryptedLength)
                return result as Data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    ///
    /// Takes the data and uses the private key to decrypt it. Will call `CCCrypt` in CommonCrypto
    /// and provide it `ivData` for the initialization vector. Will use cipher block chaining (CBC) as
    /// the mode of operation.
    ///
    /// Returns the decrypted data.
    ///
    public func decrypt(data: Data) -> Data? {
        let encryptedData = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
        let encryptedDataLength = data.count
        
        if let result = NSMutableData(length: encryptedDataLength) {
            let keyData = (self.aes256Key as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.aes256Key.count)
            let keyLength = size_t(self.aes256Key.count)
            let ivData = (iv as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.iv.count)
            
            let decryptedData = UnsafeMutablePointer<UInt8>(result.mutableBytes.assumingMemoryBound(to: UInt8.self))
            let decryptedDataLength = size_t(result.length)
            
            var decryptedLength: size_t = 0
            
            let status = CCCrypt(CCOperation(kCCDecrypt), SimpleSwiftCryptoConstants.aesAlgorithm, SimpleSwiftCryptoConstants.aesOptions, keyData, keyLength, ivData, encryptedData, encryptedDataLength, decryptedData, decryptedDataLength, &decryptedLength)
            
            if UInt32(status) == UInt32(kCCSuccess) {
                result.length = Int(decryptedLength)
                return result as Data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    ///
    /// Allows you to export the RSA public key to a format (so you can send over the net).
    ///
    public func exportIvAndPrivateAES256Key() -> Data {
        return self.iv + self.aes256Key
    }
    
    
    ///
    /// Allows you to load an RSA public key (i.e. one downloaded from the net).
    ///
    public static func loadIvAndPrivateAES256Key(ivAndPrivateAES256Key: Data) -> AES256Key? {
        guard ivAndPrivateAES256Key.count == SimpleSwiftCryptoConstants.aes256KeySize * 2 else {
            return nil
        }
        return AES256Key(
            iv: ivAndPrivateAES256Key[0 ..< SimpleSwiftCryptoConstants.aes256KeySize],
            aes256Key: ivAndPrivateAES256Key[SimpleSwiftCryptoConstants.aes256KeySize ..< SimpleSwiftCryptoConstants.aes256KeySize*2]
        )
    }
}

///
/// The RSA keypair. Includes both private and public key.
///
public struct RSAKeyPair {
    private let privateKey: SecKey
    private let publicKey: SecKey
    
    #if DEBUG
    public var __debug_privateKey: SecKey { self.privateKey }
    public var __debug_publicKey: SecKey { self.publicKey }
    #endif
    
    fileprivate init(privateKey: SecKey, publicKey: SecKey) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    public func extractPublicKey() -> RSAPublicKey {
        RSAPublicKey(publicKey: publicKey)
    }
    
    ///
    /// Takes the data and uses the private key to decrypt it.
    /// Returns the decrypted data.
    ///
    public func decrypt(data: Data) -> Data? {
        var error: Unmanaged<CFError>?
        if let decryptedData: CFData = SecKeyCreateDecryptedData(self.privateKey, SimpleSwiftCryptoConstants.rsaAlgorithm, data as CFData, &error) {
            if error != nil {
                return nil
            } else {
                return decryptedData as Data
            }
        } else {
            return nil
        }
    }
}


///
/// The RSA public key.
///
public struct RSAPublicKey {
    private let publicKey: SecKey
    
    #if DEBUG
    public var __debug_publicKey: SecKey { self.publicKey }
    #endif
    
    fileprivate init(publicKey: SecKey) {
        self.publicKey = publicKey
    }
    ///
    /// Takes the data and uses the public key to encrypt it.
    /// Returns the encrypted data.
    ///
    public func encrypt(data: Data) -> Data? {
        var error: Unmanaged<CFError>?
        if let encryptedData: CFData = SecKeyCreateEncryptedData(self.publicKey, SimpleSwiftCryptoConstants.rsaAlgorithm, data as CFData, &error) {
            if error != nil {
                return nil
            } else {
                return encryptedData as Data
            }
        } else {
            return nil
        }
    }
    
    
    ///
    /// Allows you to export the RSA public key to a format (so you can send over the net).
    ///
    public func export() -> Data? {
        return publicKey.exportToData()
    }
    
    
    ///
    /// Allows you to load an RSA public key (i.e. one downloaded from the net).
    ///
    public static func load(rsaPublicKeyData: Data) -> RSAPublicKey? {
        if let publicKey: SecKey = .loadFromData(rsaPublicKeyData) {
            return RSAPublicKey(publicKey: publicKey)
        } else {
            return nil
        }
    }
}

fileprivate extension SecKey {
    func exportToData() -> Data? {
        var error: Unmanaged<CFError>?
        if let cfData = SecKeyCopyExternalRepresentation(self, &error) {
            if error != nil {
                return nil
            } else {
                return cfData as Data
            }
        } else {
            return nil
        }
    }
    static func loadFromData(_ data: Data) -> SecKey? {
        let keyDict: [NSObject : NSObject] = [
           kSecAttrKeyType: kSecAttrKeyTypeRSA,
           kSecAttrKeyClass: kSecAttrKeyClassPublic,
           kSecAttrKeySizeInBits: SimpleSwiftCryptoConstants.rsaKeySizeInBits
        ]
        return SecKeyCreateWithData(data as CFData, keyDict as CFDictionary, nil)
    }
}
