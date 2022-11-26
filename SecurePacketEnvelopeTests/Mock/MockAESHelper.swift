//
//  MockAESHelper.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/13/22.
//

import Foundation
@testable import SecurePacketEnvelope

final class MockAESHelper : AESHelperProtocol {
    var iv: String = "iv"
    var key: String = "key"
     
    func aesEncrypt(data: String) -> String? {
        return "encryptedAES"
    }
    
    func aesDecrypt(data: String, key: String, iv: String) -> String? {
        return "decryptedAES"
    }
}
