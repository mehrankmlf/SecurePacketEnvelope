//
//  CryptoKeyGenerator.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 9/19/22.
//

import Foundation

public enum CryptoException: Error {
    case unknownError
    case duplicateFoundWhileTryingToCreateKey
    case keyNotFound
    case authFailed
    case unableToAddPublicKeyToKeyChain
    case wrongInputDataFormat
    case unableToEncrypt
    case unableToDecrypt
    case unableToSignData
    case unableToVerifySignedData
    case unableToPerformHashOfData
    case unableToGenerateAccessControlWithGivenSecurity
    case outOfMemory
}

struct AESKeyManager {
    // generate and set AES random IV and random KEY string
    static func generateAESKeys() -> AESHelper? {
        func generateRandomString(length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in letters.randomElement()! })
        }
        return AESHelper(iv: generateRandomString(length: 16), key: generateRandomString(length: 16))
    }
}

struct RSAKeyManager {
    
    //MARK: - generate RSA keypair
    static func generateRSAKeyPair() throws -> RSAKeyPair {
        
        // private key parameters
        let privateKeyParams: [String: AnyObject] = [
            kSecAttrIsPermanent as String: true as AnyObject,
            kSecAttrApplicationTag as String: RSAConfig.kRSAApplicationTag as AnyObject
        ]
        
        // public key parameters
        let publicKeyParams: [String: AnyObject] = [
            kSecAttrIsPermanent as String: true as AnyObject,
            kSecAttrApplicationTag as String: RSAConfig.kRSAApplicationTag as AnyObject
        ]
        
        // global parameters for our key generation
        let parameters: [String: AnyObject] = [
            kSecAttrKeyType as String:          kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String:    RSAConfig.keySize as AnyObject,
            kSecPublicKeyAttrs as String:       publicKeyParams as AnyObject,
            kSecPrivateKeyAttrs as String:      privateKeyParams as AnyObject,
        ]
        
        // check status after Key generation
        var pubKey, privKey: SecKey?
        let status = SecKeyGeneratePair(parameters as CFDictionary, &pubKey, &privKey)
        
        if status != errSecSuccess {
            var error = CryptoException.unknownError
            switch (status) {
            case errSecDuplicateItem: error = .duplicateFoundWhileTryingToCreateKey
            case errSecItemNotFound: error = .keyNotFound
            case errSecAuthFailed: error = .authFailed
            default: break
            }
            throw error
        }
        return RSAKeyPair(privateKey: privKey, publicKey: pubKey)
    }
    
    // fetch RSA public key
    static func getPublicKey() -> SecKey? {
        let parameters = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrApplicationTag as String: RSAConfig.kRSAApplicationTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecReturnRef as String: true,
        ] as [String : Any]
        var ref: AnyObject?
        let status = SecItemCopyMatching(parameters as CFDictionary, &ref)
        if status == errSecSuccess { return ref as! SecKey? } else { return nil }
    }
    
    // fetch RSA private key
    static func getPrivateKey() -> SecKey? {
        let parameters = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrApplicationTag as String: RSAConfig.kRSAApplicationTag ,
            kSecReturnRef as String: true,
        ] as [String : Any]
        var ref: AnyObject?
        let status = SecItemCopyMatching(parameters as CFDictionary, &ref)
        if status == errSecSuccess { return ref as! SecKey? } else { return nil }
    }
}
