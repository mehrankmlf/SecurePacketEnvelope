//
//  RSATest.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 10/18/22.
//

import XCTest
@testable import SecurePacketEnvelope

final class RSATest: XCTestCase {
    
    var rsaPublicKeyHelper : RSAPublicKeyProtocol!

    override func setUp() {
        rsaPublicKeyHelper = MockRSAPublicKey()
    }
    
    override func tearDown() {
        rsaPublicKeyHelper = nil
    }
    
    func test_encryption_withRSA_SouldReturnBase64String() {
        let plainText = "PlainText"
        
        let encrypted = rsaPublicKeyHelper.encryptBase64(text: plainText)
        
        XCTAssertTrue(encrypted as Any is String)
        XCTAssertNotNil(Data(base64Encoded: encrypted!) )
    }
}
