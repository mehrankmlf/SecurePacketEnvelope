//
//  AESTest.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/13/22.
//

import XCTest
@testable import SecurePacketEnvelope

class AESTest: XCTestCase {
    
    var aesHelper : AESHelperProtocol!

    override func setUp() {
        aesHelper = MockAESHelper()
    }
    
    override func tearDown() {
        aesHelper = nil
        super.tearDown()
    }
    
    func test_encryption_withAES_SouldReturnBase64String() {
        let plainText = "PlainText"
        
        let encrypted = aesHelper.aesEncrypt(data: plainText)
        
        XCTAssertTrue(encrypted as Any is String)
        XCTAssertNotNil(Data(base64Encoded: encrypted!))
    }
}
