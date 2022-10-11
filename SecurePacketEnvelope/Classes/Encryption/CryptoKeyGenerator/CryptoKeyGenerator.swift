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
struct CryptoKeyGenerator {
    // generate and set AES random IV and random KEY string
    static func generateAESKeys() -> AESHelper? {
        func generateRandomString(length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in letters.randomElement()! })
        }
        return AESHelper(iv: generateRandomString(length: 16), key: generateRandomString(length: 16))
    }
    
    //MARK: - generate RSA keypair
    static func generateRSAKeyPair() -> RSAKeyPair? {

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
            print(error)
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

class RSAKeyEncoding: NSObject {
    
    // ASN.1 identifiers
    private let bitStringIdentifier: UInt8 = 0x03
    private let sequenceIdentifier: UInt8 = 0x30
    
    // ASN.1 AlgorithmIdentfier for RSA encryption: OID 1 2 840 113549 1 1 1 and NULL
    private let algorithmIdentifierForRSAEncryption: [UInt8] = [0x30, 0x0d, 0x06,
                                                                0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00]
    
    /// Converts the DER encoding of an RSA public key that is either fetched from the
    /// keychain (e.g. by using `SecItemCopyMatching(_:_:)`) or retrieved in another way
    /// (e.g. by using `SecKeyCopyExternalRepresentation(_:_:)`), to a format typically
    /// used by tools and programming languages outside the Apple ecosystem (such as
    /// OpenSSL, Java, PHP and Perl). The DER encoding of an RSA public key created by
    /// iOS is represented with the ASN.1 RSAPublicKey type as defined by PKCS #1.
    /// However, many systems outside the Apple ecosystem expect the DER encoding of a
    /// key to be represented with the ASN.1 SubjectPublicKeyInfo type as defined by
    /// X.509. The two types are related in a way that if the SubjectPublicKeyInfo’s
    /// algorithm field contains the rsaEncryption object identifier as defined by
    /// PKCS #1, the subjectPublicKey field shall contain the DER encoding of an
    /// RSAPublicKey type.
    ///
    /// - Parameter rsaPublicKeyData: A data object containing the DER encoding of an
    ///     RSA public key, which is represented with the ASN.1 RSAPublicKey type.
    /// - Returns: A data object containing the DER encoding of an RSA public key, which
    ///     is represented with the ASN.1 SubjectPublicKeyInfo type.
    func convertToX509EncodedKey(_ rsaPublicKeyData: Data) -> Data {
        var derEncodedKeyBytes = [UInt8](rsaPublicKeyData)
        
        // Insert ASN.1 BIT STRING bytes at the beginning of the array
        derEncodedKeyBytes.insert(0x00, at: 0)
        derEncodedKeyBytes.insert(contentsOf: lengthField(of: derEncodedKeyBytes), at: 0)
        derEncodedKeyBytes.insert(bitStringIdentifier, at: 0)
        
        // Insert ASN.1 AlgorithmIdentifier bytes at the beginning of the array
        derEncodedKeyBytes.insert(contentsOf: algorithmIdentifierForRSAEncryption, at: 0)
        
        // Insert ASN.1 SEQUENCE bytes at the beginning of the array
        derEncodedKeyBytes.insert(contentsOf: lengthField(of: derEncodedKeyBytes), at: 0)
        derEncodedKeyBytes.insert(sequenceIdentifier, at: 0)
        
        return Data(derEncodedKeyBytes)
    }
    
    private func lengthField(of valueField: [UInt8]) -> [UInt8] {
        var length = valueField.count
        
        if length < 128 {
            return [ UInt8(length) ]
        }
        
        // Number of bytes needed to encode the length
        let lengthBytesCount = Int((log2(Double(length)) / 8) + 1)
        
        // First byte encodes the number of remaining bytes in this field
        let firstLengthFieldByte = UInt8(128 + lengthBytesCount)
        
        var lengthField: [UInt8] = []
        for _ in 0..<lengthBytesCount {
            // Take the last 8 bits of length
            let lengthByte = UInt8(length & 0xff)
            // Insert them at the beginning of the array
            lengthField.insert(lengthByte, at: 0)
            // Delete the last 8 bits of length
            length = length >> 8
        }
        
        // Insert firstLengthFieldByte at the beginning of the array
        lengthField.insert(firstLengthFieldByte, at: 0)
        
        return lengthField
    }
}

extension SecKey {
    func asBase64() -> String {
        var dataPtr: CFTypeRef?
        let query: [String:Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: RSAConfig.kRSAApplicationTag, // Same unique tag here
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnData as String: kCFBooleanTrue!
        ]
        let result = SecItemCopyMatching(query as CFDictionary, &dataPtr)
        
        switch (result, dataPtr) {
        case (errSecSuccess, .some(let data)):
            
            // convert to X509 encoded key
            let convertedData = RSAKeyEncoding().convertToX509EncodedKey(data as! Data)
            
            // convert to Base64 string
            let base64PublicKey = convertedData.base64EncodedString(options: [])
            return base64PublicKey
        default:
            return ""
        }
    }
}
