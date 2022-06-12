//
//  MainView.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 6/12/22.
//

import UIKit

class MainView: UIView {

     var viewContainer : UIView = {
        let viewContainer = UIView()
        viewContainer.backgroundColor = .white
        return viewContainer
    }()
    
     lazy var lblRSAKey : UILabel = {
        let lblRSAKey = UILabel()
        lblRSAKey.text = "RSAKeyGenerated"
        lblRSAKey.textAlignment = .right
        lblRSAKey.textColor = Color.fontTextColor
        lblRSAKey.font = UIFont.boldSystemFont(ofSize: 15)
        lblRSAKey.translatesAutoresizingMaskIntoConstraints = false
        return lblRSAKey
    }()
    
    
     lazy var lblTitle : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Enter Your Data"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: 35)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
     lazy var lblFullName : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Full Name"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: 15)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
     lazy var lblEmail : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Email"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: 15)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
     lazy var lblAge : UILabel = {
        let lblAge = UILabel()
        lblAge.text = "Age"
        lblAge.textColor = Color.fontTextColor
        lblAge.font = UIFont.boldSystemFont(ofSize: 15)
        lblAge.translatesAutoresizingMaskIntoConstraints = false
        return lblAge
    }()
    
     lazy var txtFullName : UITextField = {
        let txtFullName = UITextField()
        txtFullName.textColor = UIColor.gray
        txtFullName.borderStyle = .line
        txtFullName.layer.borderColor = UIColor.gray.cgColor
        txtFullName.layer.borderWidth = 1.0
        return txtFullName
    }()
    
     lazy var txtEmail : UITextField = {
        let txtEmail = UITextField()
        txtEmail.textColor = UIColor.gray
        txtEmail.borderStyle = .line
        txtEmail.layer.borderColor = UIColor.gray.cgColor
        txtEmail.layer.borderWidth = 1.0
        return txtEmail
    }()
    
     lazy var txtAge : UITextField = {
        let txtAge = UITextField()
        txtAge.textColor = UIColor.gray
        txtAge.borderStyle = .line
        txtAge.layer.borderColor = UIColor.gray.cgColor
        txtAge.layer.borderWidth = 1.0
        txtAge.keyboardType = .numberPad
        return txtAge
    }()
    
     lazy var lblEncrypted : UITopAlignedLabel = {
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
    
    
     lazy var statsView: UIStackView = {
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
    
     lazy var btnEncrypt : UIButton = {
        let btnSubmit = UIButton()
        btnSubmit.setTitle("Create Secure Envelope", for: .normal)
        btnSubmit.backgroundColor = Color.buttonBackgroundColor
        btnSubmit.setTitleColor(UIColor.white, for: .normal)
        btnSubmit.clipsToBounds = true
        btnSubmit.layer.cornerRadius = 10.0
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        return btnSubmit
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        makeAutolayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        let elements = [viewContainer,
                        lblRSAKey,
                        lblTitle,
                        statsView,
                        btnEncrypt,
                        lblEncrypted]
        for element in elements {
            addSubview(element)
        }
    }
    
    private func setupUI() {
        backgroundColor = Color.backGroundColor
    }
}


extension MainView {
    private func makeAutolayout() {
        
        lblRSAKey.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        lblRSAKey.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        lblRSAKey.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        lblRSAKey.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        lblTitle.topAnchor.constraint(equalTo: lblRSAKey.bottomAnchor, constant: 20).isActive = true
        lblTitle.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        lblTitle.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        lblTitle.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        statsView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20).isActive = true
        statsView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        statsView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
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
