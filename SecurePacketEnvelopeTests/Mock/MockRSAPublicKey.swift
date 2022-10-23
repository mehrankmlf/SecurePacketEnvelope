//
//  MockRSAPublicKey.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 10/18/22.
//

import Foundation
@testable import SecurePacketEnvelope

final class MockRSAPublicKey : RSAPublicKeyProtocol {
    func encryptBase64(text: String) -> String? {
       return Data(text.utf8).base64EncodedString()
    }
}
