//
//  MockRSAHelperFactory.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 10/18/22.
//

import Foundation
@testable import SecurePacketEnvelope

final class MockRSAHelperFactory : RSAHelperProtocol {
    
    func decpryptBase64(encrpted: String) -> String? {
        guard let data = Data(base64Encoded: encrpted, options: Data.Base64DecodingOptions(rawValue: 0)) else {return nil}
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func fetchPublicKey() -> RSAPublicKey? {
        return nil
    }
}

