//
//  MainViewController.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    let PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArdklK4kIsOMuxTZ8jG1PRPfXqSDmaCIQ+xEpIRSssQ6jiuvhYZTMUbV22osgtivuyKdnHm+cvzGuZCSB8QFyCcM7l09HZVs0blLkrBAU5CVSv+6BzPQTVJytoi/VO4mlf6me1Y9bXWrrPw1YtC1mnB2Ix9cuaxOLpucglfGbUaGEigsUZMTD2vuEODN5cJi39ap+G9ILitbrnt+zsW9354pokVnHw4Oq837Fd7ZtP0nAA5F6nE3FNDGQqLy2WYRoKC9clDecD8T933azUD98b5FSUGzIhwiuqHHeylfVbevbBW91Tvg9s7vUMr0Y2YDpEmPAf0q4PlDt8QsjctT9kQIDAQAB"

    let PRIVATE_KEY = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCt2SUriQiw4y7FNnyMbU9E99epIOZoIhD7ESkhFKyxDqOK6+FhlMxRtXbaiyC2K+7Ip2ceb5y/Ma5kJIHxAXIJwzuXT0dlWzRuUuSsEBTkJVK/7oHM9BNUnK2iL9U7iaV/qZ7Vj1tdaus/DVi0LWacHYjH1y5rE4um5yCV8ZtRoYSKCxRkxMPa+4Q4M3lwmLf1qn4b0guK1uue37Oxb3fnimiRWcfDg6rzfsV3tm0/ScADkXqcTcU0MZCovLZZhGgoL1yUN5wPxP3fdrNQP3xvkVJQbMiHCK6ocd7KV9Vt69sFb3VO+D2zu9QyvRjZgOkSY8B/Srg+UO3xCyNy1P2RAgMBAAECggEAInVN9skcneMJ3DEmkrb/5U2yw2UwBifqcbk/C72LVTTvmZOTgsH5laCARGUbQMCIfeEggVniGcuBI3xQ/TIqJmE6KI2gOyjOxadMiAZP/cCgHEbsF3Gxey3rBKCyhTCNSzaVswLNO0D8C+1bTatKEVuRRvsRykt/fL+HJ/FRteYYO9LuLv2WESJGE6zsi03P6snNiRracvYqz+Rnrvf1Xuyf58wC1C6JSjZ9D6tootPDBTEYaIIbpEnV+qP/3k5OFmA9k4WbkZI6qYzqSK10bTQbjMySbatovnCD/oqIUOHLwZpL051E9lz1ZUnDbrxKwT0BIU7y4DYaHSzrKqRsIQKBgQDTQ9DpiuI+vEj0etgyJgPBtMa7ClTY+iSd0ccgSE9623hi1CHtgWaYp9C4Su1GBRSF0xlQoVTuuKsVhI89far2Z0hR9ULr1J1zugMcNESaBBC17rPoRvXPJT16U920Ntwr00LviZ/DEyvmpVDagYy+mSK0Wq+kH7p5aR5zAHXWrQKBgQDSqQ6TBr5bDMvhpRi94unghiWyYL6srSRV9XjqDpiNU+yFwCLzSG610DyXFa3pV138P+ryunqg1LtKsOOtZJONzbS1paINnwkvfwzMpI7TjCq1+8rxeEhZ3AVmumDtPQK+YfGbxCQ+LAOJZOu8lGv1O7tsbXFp0vh5RmWHWHvy9QKBgCMGPi9JsCJ4cpvdddQyizLk9oFxwAlMxx9G9P08H7kdg4LW6l0Gs+yg/bBf86BFHVbmXW8JoBwHj418sYafO+Wnz8yOna6dTBEwiG13mNvzypVu4nKiuQPDh8Ks/rdu1OeLGbC+nzbnCcMuKw5epee/WYqO8kmCXRbdv4ePTvntAoGBAJYQ9F7saOI3pW2izJNIeE8HgQcnP+2GkeHiMjaaGzZiWJWXH86rBKLkKqV+PhuBr2QorFgpW34CzUER7b7xbOORbHASA/UsG8EIArgtacltimeFbTbC9td8kyRxFOcrlS7GWvUZrq/TbtmLWRtHp/hUitlcxXQbZAIQkfbuo62ZAoGBAKBURvLGM0ethkvUHFyGae2YGG/s+u+EYd2zNba7A6qnfzrlMHVPiPO6lx31+HwhuJ0tBZWMJKhEZ5PWByZzreVKVH5fE5LoQLo+B3VCTyTc1fJ9RKLAPrPqHuvzPHHP/n84XHGeit3e4ytd3Mm/6CNbrg7xux2M4RDQmN//1UOY"
    
    var viewModel : MainViewModel?
    var bag = Set<AnyCancellable>()
    
    private var viewContainer : UIView = {
        let viewContainer = UIView()
        viewContainer.backgroundColor = .white
        return viewContainer
    }()
    
    private lazy var lblTitle : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Enter Your Data"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: 35)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
    private lazy var lblFullName : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Full Name"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: 15)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
    private lazy var lblEmail : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Email"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: 15)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
    private lazy var lblAge : UILabel = {
        let lblAge = UILabel()
        lblAge.text = "Age"
        lblAge.textColor = Color.fontTextColor
        lblAge.font = UIFont.boldSystemFont(ofSize: 15)
        lblAge.translatesAutoresizingMaskIntoConstraints = false
        return lblAge
    }()
    
    private lazy var txtFullName : UITextField = {
        let txtFullName = UITextField()
        txtFullName.textColor = UIColor.gray
        txtFullName.borderStyle = .line
        txtFullName.layer.borderColor = UIColor.gray.cgColor
        txtFullName.layer.borderWidth = 1.0
        txtFullName.addTarget(self, action: #selector(txtFullName_EditingChanged)
                              , for: UIControl.Event.editingChanged)
        return txtFullName
    }()
    
    private lazy var txtEmail : UITextField = {
        let txtEmail = UITextField()
        txtEmail.textColor = UIColor.gray
        txtEmail.borderStyle = .line
        txtEmail.layer.borderColor = UIColor.gray.cgColor
        txtEmail.layer.borderWidth = 1.0
        txtEmail.addTarget(self, action: #selector(txtEmail_EditingChanged)
                           , for: UIControl.Event.editingChanged)

        return txtEmail
    }()
    
    private lazy var txtAge : UITextField = {
        let txtAge = UITextField()
        txtAge.textColor = UIColor.gray
        txtAge.borderStyle = .line
        txtAge.layer.borderColor = UIColor.gray.cgColor
        txtAge.layer.borderWidth = 1.0
        txtAge.keyboardType = .numberPad
        return txtAge
    }()
    
    private lazy var lblEncrypted : UITopAlignedLabel = {
        let lblEncrypted = UITopAlignedLabel()
        lblEncrypted.text = ""
        lblEncrypted.textColor = Color.fontTextColor
        lblEncrypted.layer.borderWidth = 1
        lblEncrypted.layer.borderColor = UIColor.gray.cgColor
        lblEncrypted.numberOfLines = 0
        lblEncrypted.font = UIFont.boldSystemFont(ofSize: 15)
        lblEncrypted.translatesAutoresizingMaskIntoConstraints = false
        return lblEncrypted
    }()
    
    
    private lazy var statsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lblFullName,
                                                       txtFullName,
                                                       lblEmail,
                                                       txtEmail,
                                                       lblAge,
                                                       txtAge])
        stackView.axis  = .vertical
        stackView.distribution  = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var btnEncrypt : UIButton = {
        let btnSubmit = UIButton()
        btnSubmit.setTitle("Create Secure Envelope", for: .normal)
        btnSubmit.backgroundColor = Color.buttonBackgroundColor
        btnSubmit.setTitleColor(UIColor.white, for: .normal)
        btnSubmit.clipsToBounds = true
        btnSubmit.layer.cornerRadius = 10.0
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        btnSubmit.addTarget(self, action: #selector(encryptAction), for: .touchUpInside)
        return btnSubmit
    }()
    
    init(viewModel : MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.backGroundColor
        setupUI()
        bindViewModel()
    
        
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
    
    private func setupUI() {
        let elements = [viewContainer,
                        lblTitle,
                        statsView,
                        btnEncrypt,
                        lblEncrypted]
        for element in elements {
            view.addSubview(element)
        }
        makeAutolayout()
    }
    
    private func createSecruePacketEnvelope() {
        let rawData = UserModel.init(name: self.txtFullName.text,
                                     familyName: self.txtEmail.text,
                                     age: Int(self.txtAge.text ?? ""))
        let iv = generateRandomString(length: 16)
        let secret = generateRandomString(length: 16)
        let encryptData = rawData.convertToString?.aesEncrypt(key: secret, iv: iv)
        self.lblEncrypted.text = encryptData

        let encRSA = MZRSA.encryptString(secret, publicKey: PUBLIC_KEY)!
        print(encRSA)
        let decRSA = MZRSA.decryptString(encRSA, privateKey: PRIVATE_KEY)!
        print(decRSA)
    }
    
    private func bindViewModel() {
        viewModel?.fullNameMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                
                guard let `self` = self else {
                    return
                }
                
                if text != "" {
                    self.txtFullName.addRightView(txtField: self.txtFullName, str: "")
                } else {
                    self.txtFullName.addRightView(txtField: self.txtFullName, str: "👍🏻")
                }
            }.store(in: &bag)
        
        viewModel?.formValidation
            .map { $0 != nil}
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (isEnable) in
                if isEnable {
                    self.btnEncrypt.isEnabled = true
                    return
                } else {
                    self.btnEncrypt.isEnabled = false
                }
                self.btnEncrypt.isEnabled = false
            })
            .store(in: &bag)
    }
    
      func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
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

extension MainViewController {
    private func makeAutolayout() {
        lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        lblTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        lblTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        lblTitle.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        statsView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20).isActive = true
        statsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        statsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
        btnEncrypt.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 30).isActive = true
        btnEncrypt.leadingAnchor.constraint(equalTo: statsView.leadingAnchor).isActive = true
        btnEncrypt.trailingAnchor.constraint(equalTo: statsView.trailingAnchor).isActive = true
        btnEncrypt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lblEncrypted.topAnchor.constraint(equalTo: btnEncrypt.bottomAnchor, constant: 30).isActive = true
        lblEncrypted.leadingAnchor.constraint(equalTo: btnEncrypt.leadingAnchor).isActive = true
        lblEncrypted.trailingAnchor.constraint(equalTo: btnEncrypt.trailingAnchor).isActive = true
        lblEncrypted.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
