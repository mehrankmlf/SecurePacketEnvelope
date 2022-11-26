//
//  UserModelTest.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/14/22.
//

import XCTest
@testable import SecurePacketEnvelope

final class UserModelTest: XCTestCase {
    
    var sut : UserModel!

    override func setUp() {
        sut = UserModel.mockData
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_userModel_shouldNotBeNil() {
        XCTAssertNotNil(sut)
    }
        
    func test_userModel_sholudBeCodable() {
        XCTAssertTrue((sut as Any) is Codable)
    }
    
    func test_userModel_DataTypeValidate() {
        XCTAssertTrue((sut.fullName as Any) is String)
        XCTAssertTrue((sut.email as Any) is String)
        XCTAssertTrue((sut.age as Any) is Int)
    }
    
    func test_ValidData() {
        XCTAssertTrue(sut.fullName == "fullName")
        XCTAssertTrue(sut.email == "email")
        XCTAssertTrue(sut.age == 10)
    }
}
