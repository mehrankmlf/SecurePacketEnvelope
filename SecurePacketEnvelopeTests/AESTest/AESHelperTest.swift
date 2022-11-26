//
//  AESHelperTest.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/21/22.
//

import XCTest
@testable import SecurePacketEnvelope

final class AESHelperTest: XCTestCase {
    
    var iv: String!
    var key: String!
    var sut: AESHelper!
    
    override func setUp() {
        iv = "qwertyuiopasdfgh"
        key = "zxcvbnmasdfghjkr"
        sut = AESHelper(iv: iv, key: key)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_aesEncrypt_ShouldReturnEncryptedString() {
       let encryptedText = sut.aesEncrypt(data: "plaintext")
       XCTAssertTrue((encryptedText as Any) is String)
       XCTAssertNotNil(Data(base64Encoded: encryptedText!))
    }
    
    func test_aesDecrypt_SouldReturnDecryptedString() {
        let cipherText = "+6LQgAfRihNkBNqQeaTYMw=="
        let decryptText = sut.aesDecrypt(data: cipherText, key: key, iv: iv)
        XCTAssertTrue((decryptText as Any) is String)
        XCTAssertTrue(decryptText == "plaintext")
    }
}
