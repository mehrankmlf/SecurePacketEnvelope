//
//  DetailViewController.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 9/22/22.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var contentView : DetailView?
    var data : RequestSecureEnvelop?
    
    init(contentView : DetailView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.backGroundColor
        self.setUpTargets()
    }
    
    private func setUpTargets() {
        contentView?.btnDecrypt.addTarget(self, action: #selector(decryptAction)
                                          , for: .touchUpInside)
    }
    
    @objc func decryptAction() {
        guard let data = self.data else {return}
        self.decryptData(data: data)
    }
    
    private func decryptData(data : RequestSecureEnvelop) {
        print(data)
        print()
        // create a instance from RSAHelper
        let rsa : RSAKeyPair = RSAKeyPair()
        // decrypt AES Secret Key with RSA
        let decryptedSecretKey : String = rsa.decpryptBase64(encrpted: data.encryptedKey)!
        // create a instance from AESHelper
        let aes : AESHelper = AESHelper()
        //
        let decryptedAES : String = aes.aesDecrypt(data: data.encryptedData, key: decryptedSecretKey, iv: data.iv)!
        
        self.showJsonContent(data: decryptedAES)
    }
    
    private func showJsonContent(data: String) {
        self.contentView?.lblDecrypt.text = data
    }
}
