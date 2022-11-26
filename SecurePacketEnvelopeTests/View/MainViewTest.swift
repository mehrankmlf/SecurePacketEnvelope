//
//  MainViewTest.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/22/22.
//

import XCTest
@testable import SecurePacketEnvelope

final class MainViewTest: XCTestCase {
    
    var sut: MainView!
    
    override func setUp() {
        sut = MainView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_initMainView_whenInitCoder() {
        sut = MainView(coder: NSCoder())
        XCTAssertNil(sut)
    }
    
    func test_initMainView_setLabels() {
        XCTAssertTrue(sut.subviews.contains(sut.lblTitle))
    }
    
    func test_initMainView_setStackViewOBjects() {
        XCTAssertTrue(sut.statsView.contains(sut.lblFullName))
        XCTAssertTrue(sut.statsView.contains(sut.txtFullName))
        XCTAssertTrue(sut.statsView.contains(sut.lblEmail))
        XCTAssertTrue(sut.statsView.contains(sut.txtEmail))
        XCTAssertTrue(sut.statsView.contains(sut.lblAge))
        XCTAssertTrue(sut.statsView.contains(sut.txtAge))
    }
    
    func test_initMainView_setStackView() {
        XCTAssertTrue(sut.subviews.contains(sut.statsView))
    }
    
    func test_initHome_setButton() {
        XCTAssertTrue(sut.subviews.contains(sut.btnEncrypt))
    }
    
    func test_initHome_setBgColor() {
        XCTAssertEqual(sut.backgroundColor, Color.backGroundColor)
    }
    
    func test_initHome_setStackViewAxis() {
        XCTAssertEqual(sut.statsView.axis, .vertical)
    }
    
    func test_initHome_setStackViewDistribution() {
        XCTAssertEqual(sut.statsView.distribution, .fillEqually)
    }
    
    func test_initHome_setStackViewAlignment() {
        XCTAssertEqual(sut.statsView.alignment, .fill)
    }
}
