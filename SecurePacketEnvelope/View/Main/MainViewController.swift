//
//  MainViewController.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import UIKit
import Combine

class MainViewController: UIViewController {

    var aesHelper : AESHelper?
    var viewModel : MainViewModel?
    var contentView : MainView?
    var bag = Set<AnyCancellable>()
    
    init(viewModel : MainViewModel, contentView : MainView, aesHelper : AESHelper) {
        self.viewModel = viewModel
        self.aesHelper = aesHelper
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
        bindViewModel()
        self.setUpTargets()
        self.generateRSAKeypairs()
    }
    
    private func setUpTargets() {
        contentView?.txtFullName.addTarget(self, action: #selector(txtFullName_EditingChanged)
                                           , for: UIControl.Event.editingChanged)
        contentView?.txtEmail.addTarget(self, action: #selector(txtEmail_EditingChanged)
                                        , for: UIControl.Event.editingChanged)
        contentView?.btnEncrypt.addTarget(self, action: #selector(encryptAction), for: .touchUpInside)
    }
    
    private func generateRSAKeypairs() {
        kRSASwiftGeneratorApplicationTag = "securePacketEnvelope" //setup your id for keychain saving
        kRSASwiftGeneratorKeySize = 1024 //keySize
    // generade new key pair
        RSAHelper.shared.createSecureKeyPair() { (succes,error) in
            if succes {
                self.contentView?.lblRSAKey.textColor = Color.greenTextColor
            }else{
                self.contentView?.lblRSAKey.textColor = Color.redTextColor
                self.contentView?.lblRSAKey.alpha = 0.5
            }
        }
    }
    
    @objc func encryptAction() {
        self.createSecruePacketEnvelope()
    }
    
    @objc func txtFullName_EditingChanged(textField: UITextField) {
        self.viewModel?.fullName = textField.text ?? ""
    }
    
    @objc func txtEmail_EditingChanged(textField: UITextField) {
        self.viewModel?.email = textField.text ?? ""
    }

    private func createSecruePacketEnvelope() {
        let userData = UserModel.init(name: self.contentView?.txtFullName.text,
                                      familyName: self.contentView?.txtEmail.text,
                                      age: Int(self.contentView?.txtAge.text ?? ""))
        
        // generate IV and sercret Key for AES Data encryption.
        guard let iv = aesHelper?.generateIV(), let secret = aesHelper?.genereteSecret() else {return}
        // encrypt userData with AES.
        let encryptData = userData.convertToString?.aesEncrypt(key: secret, iv: iv)
        self.contentView?.lblEncrypted.text = encryptData
        //ecrypt secret key with RSA.
//        RSAHelper.shared.encryptMessageWithPublicKey(secret) { success,data,error in
//            print(success)
//            print(data)
//            print(error)
//        }
        
//        RSAHelper.shared.decryptMessageWithPrivateKey(<#T##encryptedData: Data##Data#>, completion: <#T##(Bool, String?, CryptoException?) -> Void##(Bool, String?, CryptoException?) -> Void##(_ success: Bool, _ result: String?, _ error: CryptoException?) -> Void#>)
//
//        let encRSA = MZRSA.encryptString(secret, publicKey: EncryptionKey.publicKey.key)!
//        print(encRSA)
//        let decRSA = MZRSA.decryptString(encRSA, privateKey: EncryptionKey.privateKey.key)!
//        print(decRSA)
    }
    
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

     func EncryptRSAFromData(data : String, publicKey: SecKey) -> Data? {
        
        let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
        let plainData = data.data(using: .utf8)
        
        if let encryptedMessageData:Data = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, plainData! as CFData,error) as Data? {
 
            let data = encryptedMessageData
            
            return data
        }
        else{
            print("RSA Error encrypting")
        }
        
        return nil
    }
}

