//
//  MockAESKeyManager.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/20/22.
//

import Foundation
@testable import SecurePacketEnvelope

final class MockAESKeyManager : AESKeyManagerProtocol {    
    static func generateAESKeys() -> AESHelperProtocol {
        return MockAESHelper()
    }
}
