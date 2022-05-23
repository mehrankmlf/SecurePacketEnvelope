//
//  UserMockData.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import Foundation

extension UserModel {
    static func fakeData() -> UserModel {
        return UserModel.init(name: "Mehran", familyName: "Kmlf", age: 29)
    }
}
