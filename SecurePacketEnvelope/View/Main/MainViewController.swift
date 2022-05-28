//
//  MainViewController.swift
//  SecurePacketEnvelope
//
//  Created by Mehran on 2/30/1401 AP.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
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
        let lblTop = UILabel()
        lblTop.text = "Age"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: 15)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
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
        return txtAge
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
                        btnEncrypt]
        for element in elements {
            view.addSubview(element)
        }
        makeAutolayout()
    }
    
    private func createSecruePacketEnvelope() {
        let rawData = UserModel.init(name: self.txtFullName.text,
                                     familyName: self.txtEmail.text,
                                     age: Int(self.txtAge.text ?? ""))
        let jsonData = rawData.convertToString?.aesEncrypt(key: <#T##String#>, iv: <#T##String#>)
        print(jsonData)
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
}

extension MainViewController {
    private func makeAutolayout() {
        lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        lblTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        lblTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        lblTitle.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        statsView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20).isActive = true
        statsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        statsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
        btnEncrypt.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 50).isActive = true
        btnEncrypt.leadingAnchor.constraint(equalTo: statsView.leadingAnchor).isActive = true
        btnEncrypt.trailingAnchor.constraint(equalTo: statsView.trailingAnchor).isActive = true
        btnEncrypt.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
