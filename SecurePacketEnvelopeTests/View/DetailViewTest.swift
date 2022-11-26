//
//  DetailView.swift
//  SecurePacketEnvelopeTests
//
//  Created by Mehran Kamalifard on 11/22/22.
//

import XCTest
@testable import SecurePacketEnvelope

final class DetailViewTest: XCTestCase {

    var sut: DetailView!
    
    override func setUp() {
        sut = DetailView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_initDetailView_whenInitCoder() {
        sut = DetailView(coder: NSCoder())
        XCTAssertNil(sut)
    }
    
    func test_initDetailView_setLabels() {
        XCTAssertTrue(sut.subviews.contains(sut.lblTitle))
    }
    
    func test_initDetailView_setStackViewOBjects() {
        XCTAssertTrue(sut.subviews.contains(sut.lblTitle))
        XCTAssertTrue(sut.subviews.contains(sut.lblDecrypt))
        XCTAssertTrue(sut.subviews.contains(sut.btnDecrypt))
    }
    
    func test_initDetailView_setBgColor() {
        XCTAssertEqual(sut.backgroundColor, Color.backGroundColor)
    }
}
