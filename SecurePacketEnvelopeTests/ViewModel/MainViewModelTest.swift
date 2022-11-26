//
//  MainViewModelTest.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/22/22.
//

import XCTest
import Combine
@testable import SecurePacketEnvelope

final class MainViewModelTest: XCTestCase {
    
    var sut: MainViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        sut = MainViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_MainViewModel_InvalidFullName() {
        sut.fullName = "test"
        let expectation = XCTestExpectation(description: "State is set to populated")
        
        sut.fullNameMessagePublisher
            .dropFirst()
            .sink { state in
                
                XCTAssertEqual(state, "")
                expectation.fulfill()
                
            }.store(in: &cancellables)
    }
    
    func test_MainViewModel_ValidFullName() {
        sut.fullName = "test fullName"
        let expectation = XCTestExpectation(description: "State is set to populated")
        
        sut.fullNameMessagePublisher
            .dropFirst()
            .sink { state in
                
                XCTAssertNotNil(state)
                expectation.fulfill()
                
            }.store(in: &cancellables)
    }
    
    func test_MainViewModel_InvalidEmail() {
        sut.email = ""
        let expectation = XCTestExpectation(description: "State is set to populated")
        
        sut.emailMessagePublisher
            .dropFirst()
            .sink { value in
                
                XCTAssertEqual(value, "")
                expectation.fulfill()
                
            }.store(in: &cancellables)
    }
    
    func test_MainViewModel_ValidEmail() {
        sut.email = "email@email.com"
        let expectation = XCTestExpectation(description: "State is set to populated")
        
        sut.emailMessagePublisher
            .dropFirst()
            .sink { value in
                
                XCTAssertEqual(value, "email@email.com")
                expectation.fulfill()
                
            }.store(in: &cancellables)
    }
    
    func test_MainViewModel_ValidForm() {
        sut.email = "email@email.com"
        sut.fullName = "test fullName"
        let expectation = XCTestExpectation(description: "State is set to populated")

        sut.formValidation
            .sink(receiveValue: { (value) in
                
                XCTAssertEqual(value?.0, "email@email.com")
                XCTAssertEqual(value?.1, "test fullName")
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }
}
