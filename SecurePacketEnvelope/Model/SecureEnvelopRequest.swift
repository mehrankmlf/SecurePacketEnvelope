//
//  RequestSecureEnvelop.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 9/26/22.
//

import Foundation

struct SecureEnvelopRequest {
    var encryptedData : String
    var encryptedKey : String
    var iv : String
}
