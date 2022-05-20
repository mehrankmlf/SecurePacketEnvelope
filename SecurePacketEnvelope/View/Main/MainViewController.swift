//
//  MainViewController.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import UIKit

class MainViewController: UIViewController {
    
        override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
            createSecruePacketEnvelope()
    }
    
    private func createSecruePacketEnvelope() {
        
        let encryptedData = UserModel.fakeData()
        let data = encryptedData.convertToString
    }
}
