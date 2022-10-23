//
//  MainViewController.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    var viewModel : MainViewModel?
    var contentView : MainView?
    var bag = Set<AnyCancellable>()
    
    init(viewModel : MainViewModel,
         contentView : MainView){
        self.viewModel = viewModel
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
        self.bindViewModel()
        self.setUpTargets()
    }
    
    private func setUpTargets() {
        contentView?.txtFullName.addTarget(self, action: #selector(txtFullName_EditingChanged)
                                           , for: UIControl.Event.editingChanged)
        contentView?.txtEmail.addTarget(self, action: #selector(txtEmail_EditingChanged)
                                        , for: UIControl.Event.editingChanged)
        contentView?.btnEncrypt.addTarget(self, action: #selector(encryptAction)
                                          , for: .touchUpInside)
    }
    
    @objc func encryptAction() {
        self.encryptAndPushToServerVC()
    }
    
    @objc func txtFullName_EditingChanged(textField: UITextField) {
        self.viewModel?.fullName = textField.text ?? ""
    }
    
    @objc func txtEmail_EditingChanged(textField: UITextField) {
        self.viewModel?.email = textField.text ?? ""
    }
    
    private func jsonModel() -> String {
        let userData = UserModel.init(name: self.contentView?.txtFullName.text,
                                      familyName: self.contentView?.txtEmail.text,
                                      age: Int(self.contentView?.txtAge.text ?? ""))
        return userData.convertToString ?? ""
    }  
    
    private func createSecruePacketEnvelope() -> (String, String, String) {
        // generate IV and sercret Key for AES Data encryption.
        let aes : AESHelper = CryptoKeyGenerator.generateAESKeys()!
        // encrypt converted string json with AES128 algorithm.
        let encryptedAES : String = aes.aesEncrypt(data: self.jsonModel())!
        // encrypt AES key with RSA
        
        // generate RSA keypair.
        let rsa : RSAKeyPair = CryptoKeyGenerator.generateRSAKeyPair()!
        // fetch RSA public key
        let rsaPublicKey: RSAPublicKey = rsa.fetchPublicKey()!
        // encrypt AES secret key with RSA.
        let encryptedRSA : String = rsaPublicKey.encryptBase64(text: aes.key)!
        // retrun encrypted data
        return (encryptedAES, encryptedRSA, aes.iv)
    }
    
    private func createSecureWalletEnvelop() -> RequestSecureEnvelop {
        let (data, key, iv) = createSecruePacketEnvelope()
        return RequestSecureEnvelop(encryptedData: data, encryptedKey: key, iv: iv)
    }
    
    private func encryptAndPushToServerVC() {
        let vc = DetailViewController(contentView: DetailView())
        vc.data = self.createSecureWalletEnvelop()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController {
    private func bindViewModel() {
        viewModel?.fullNameMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                
                guard let `self` = self, let txtFullName = self.contentView?.txtFullName else {
                    return
                }
                
                if text != "" {
                    self.contentView?.txtFullName.addRightView(txtField: txtFullName, str: "")
                } else {
                    self.contentView?.txtFullName.addRightView(txtField: txtFullName, str: "👍🏻")
                }
            }.store(in: &bag)
        
        viewModel?.formValidation
            .map { $0 != nil}
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (isEnable) in
                if isEnable {
                    self.contentView?.btnEncrypt.isEnabled = true
                    return
                } else {
                    self.contentView?.btnEncrypt.isEnabled = false
                }
                self.contentView?.btnEncrypt.isEnabled = false
            })
            .store(in: &bag)
    }
}

