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
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel : MainViewModel, contentView: MainView){
        self.viewModel = viewModel
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = contentView
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
    // Step 1
    func getUserData() -> UserModel {
        return UserModel.init(fullName: self.contentView?.txtFullName.text,
                              email: self.contentView?.txtEmail.text,
                              age: Int(self.contentView?.txtAge.text ?? ""))
    }
    // Step 2
    func convertUserDataToJson() -> String? {
        return getUserData().convertToStringJSON
    }
    // Step 3
    func createSecruePacketEnvelope() -> (String, String, String) {
        // generate IV and sercret Key for AES Data encryption.
        let aes : AESHelperProtocol = AESKeyManager.generateAESKeys()
        // encrypt converted string json with AES128 algorithm.
        let encryptedAES : String = aes.aesEncrypt(data: convertUserDataToJson() ?? "")!
        // encrypt AES key with RSA
        
        // generate RSA keypair.
        let rsa : RSAKeyPair = try! RSAKeyManager.generateRSAKeyPair()
        // fetch RSA public key
        let rsaPublicKey: RSAPublicKey = rsa.fetchPublicKey()!
        // encrypt AES secret key with RSA.
        let encryptedRSA : String = rsaPublicKey.encryptBase64(text: aes.key)!
        // retrun encrypted data
        return (encryptedAES, encryptedRSA, aes.iv)
    }
    // Step 4
    func createSecureEnvelop() -> SecureEnvelopRequest {
        let (data, key, iv) = createSecruePacketEnvelope()
        return SecureEnvelopRequest(encryptedData: data, encryptedKey: key, iv: iv)
    }
    
    func encryptAndPushToServerVC() {
        let vc = DetailViewController(contentView: DetailView())
        vc.data = self.createSecureEnvelop()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController {
    private func bindViewModel() {
        viewModel?.fullNameMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                
                guard let `self` = self, let textField = self.contentView?.txtFullName else {
                    return
                }
                
                if text != "" {
                    self.contentView?.txtFullName.addRightView(txtField:  textField, str: "")
                } else {
                    self.contentView?.txtFullName.addRightView(txtField:  textField, str: "👍🏻")
                }
            }.store(in: &cancellables)
        
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
            .store(in: &cancellables)
    }
}

