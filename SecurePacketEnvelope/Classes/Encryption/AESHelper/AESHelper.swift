//
//  AESHelper.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 6/1/22.
//

import Foundation

protocol RandomStringProtocol {
    func generateRandomString(length: Int) -> String
}

struct AESHelper {
     func generateIV() -> String {
        return generateRandomString(length: 16)
    }
     func genereteSecret() -> String {
        return generateRandomString(length: 16)
    }
}

extension AESHelper : RandomStringProtocol {
     func generateRandomString(length: Int) -> String {
     let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
     return String((0..<length).map{ _ in letters.randomElement()! })
   }
}



