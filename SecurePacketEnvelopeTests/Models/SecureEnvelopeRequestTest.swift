//
//  SecureEnvelopeRequestTest.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/14/22.
//

import XCTest
@testable import SecurePacketEnvelope

final class SecureEnvelopeRequestTest: XCTestCase {
    
    var sut : SecureEnvelopRequest!

    override func setUp() {
        self.whenSUTShouldReturnValidRequest()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_secureEnvelope_shouldNotBeNil() {
        XCTAssertNotNil(sut)
    }
    
    func whenSUTShouldReturnValidRequest(encryptedData : String = "data",
                                         encryptedKey: String = "key",
                                         iv: String = "iv") {
        sut = SecureEnvelopRequest(encryptedData: encryptedData, encryptedKey: encryptedKey, iv: iv)
    }
    
    func test_userModel_DataTypeValidate() {
        XCTAssertTrue((sut.encryptedData as Any) is String)
        XCTAssertTrue((sut.encryptedKey as Any) is String)
        XCTAssertTrue((sut.iv as Any) is String)
    }
}
