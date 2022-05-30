//
//  RSAKeyHelper.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 5/28/22.
//

import Foundation
import Security
import CommonCrypto

class RSAHelper {

    func CreatePublickey() {
        let attributes: CFDictionary =
             [kSecAttrKeyType as String: kSecAttrKeyTypeRSA, // 1
              kSecAttrKeySizeInBits as String: 2048, // 2
              kSecPrivateKeyAttrs as String:
                  [kSecAttrIsPermanent as String: true, // 3
                   kSecAttrApplicationTag as String: tag ] // 4
             ] as CFDictionary

         var error: Unmanaged<CFError>?

         do {
             guard SecKeyCreateRandomKey(attributes, &error) != nil else { // 5
                 throw error!.takeRetainedValue() as Error
             }
             print("key created")
             return true
         } catch {
             print(error.localizedDescription)
             return false
         }

    }

}
