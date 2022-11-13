//
//  RSAHelper.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 6/8/22.
//

import Foundation
import CommonCrypto
import Security

enum RSAConfig {
    static let keySize : UInt = 2048
    static let kRSAApplicationTag = "com.app.bundle"
    static let rsaAlgorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
}

struct RSAKeyPair : RSAHelperProtocol {
    
    var privateKey: SecKey?
    var publicKey: SecKey?
    
    init(privateKey: SecKey? = nil, publicKey: SecKey? = nil) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    //MARK: - Decrypt Function
    func decpryptBase64(encrpted: String) -> String? {
        
        guard let privateKey = RSAKeyManager.getPrivateKey() else {return nil}
        let data = NSData(base64Encoded: encrpted, options: .ignoreUnknownCharacters)!
        var error: Unmanaged<CFError>?
        if let decryptedData: Data = SecKeyCreateDecryptedData(privateKey,
                                                               RSAConfig.rsaAlgorithm,
                                                               data as CFData, &error) as? Data {
            if error != nil {
                return nil
            } else {
                return String(decoding: decryptedData, as: UTF8.self)
            }
        } else {
            return nil
        }
    }
    
    func fetchPublicKey() -> RSAPublicKey? {
        guard let pubKey = self.publicKey else {return nil}
        return RSAPublicKey(publicKey: pubKey)
    }
}

struct RSAPublicKey : RSAPublicKeyProtocol {
    
    var publicKey : SecKey?
    
    init(publicKey : SecKey) {
        self.publicKey = publicKey
    }
    
    //MARK: - Encrypt Function
    func encryptBase64(text: String) -> String? {
        
        guard let pubKey = RSAKeyManager.getPublicKey() else {return nil}
        guard let data = text.data(using: String.Encoding.utf8) else {return nil}
        var error: Unmanaged<CFError>?
        if let encryptedData: Data = SecKeyCreateEncryptedData(pubKey,
                                                               RSAConfig.rsaAlgorithm,
                                                               data as CFData, &error) as? Data {
            if error != nil {
                return nil
            } else {
                return encryptedData.base64EncodedString()
            }
        } else {
            return nil
        }
    }
}

