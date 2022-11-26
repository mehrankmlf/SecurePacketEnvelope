//
//  CryptoKitProtocol.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 11/15/22.
//

import Foundation

protocol AESKeyManagerProtocol {
    static func generateAESKeys() -> AESHelperProtocol
}
