//
//  RSAHelperProtocol.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 10/18/22.
//

import Foundation

protocol RSAHelperProtocol {
    func decpryptBase64(encrpted: String) -> String?
    func fetchPublicKey() -> RSAPublicKey?
}

protocol RSAPublicKeyProtocol {
    func encryptBase64(text: String) -> String?
}
