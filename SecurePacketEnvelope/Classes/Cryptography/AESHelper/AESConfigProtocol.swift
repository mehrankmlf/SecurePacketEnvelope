//
//  AESConfigProtocol.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 11/13/22.
//

import Foundation

protocol AESHelperProtocol {
    var iv : String { get }
    var key : String { get }
    func aesEncrypt(data: String) -> String?
    func aesDecrypt(data : String, key: String, iv: String) -> String?
}
