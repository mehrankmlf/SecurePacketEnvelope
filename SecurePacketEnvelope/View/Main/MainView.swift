//
//  MainView.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 6/12/22.
//

import UIKit

class MainView: UIView {
    
    private enum Constants {
        static let titleFontSize  : CGFloat = 35
        static let normalFontSize : CGFloat = 15
        static let border         : CGFloat = 1.0
        static let cornerRadius   : CGFloat = 10.0
        static let padding1       : CGFloat = 20.0
        static let padding2       : CGFloat = 30.0
        static let generalHeight  : CGFloat = 25.0
    }
    
    private var safeArea: UILayoutGuide!
    
    lazy var lblTitle : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Enter Your Data"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        return lblTop
    }()
    
    lazy var lblFullName : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Full Name"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: Constants.normalFontSize)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
    lazy var lblEmail : UILabel = {
        let lblTop = UILabel()
        lblTop.text = "Email"
        lblTop.textColor = Color.fontTextColor
        lblTop.font = UIFont.boldSystemFont(ofSize: Constants.normalFontSize)
        lblTop.translatesAutoresizingMaskIntoConstraints = false
        return lblTop
    }()
    
    lazy var lblAge : UILabel = {
        let lblAge = UILabel()
        lblAge.text = "Age"
        lblAge.textColor = Color.fontTextColor
        lblAge.font = UIFont.boldSystemFont(ofSize: Constants.normalFontSize)
        lblAge.translatesAutoresizingMaskIntoConstraints = false
        return lblAge
    }()
    
    lazy var txtFullName : UITextField = {
        let txtFullName = UITextField()
        txtFullName.textColor = UIColor.gray
        txtFullName.borderStyle = .line
        txtFullName.layer.borderColor = UIColor.gray.cgColor
        txtFullName.layer.borderWidth = Constants.border
        return txtFullName
    }()
    
    lazy var txtEmail : UITextField = {
        let txtEmail = UITextField()
        txtEmail.textColor = UIColor.gray
        txtEmail.borderStyle = .line
        txtEmail.layer.borderColor = UIColor.gray.cgColor
        txtEmail.layer.borderWidth = Constants.border
        return txtEmail
    }()
    
    lazy var txtAge : UITextField = {
        let txtAge = UITextField()
        txtAge.textColor = UIColor.gray
        txtAge.borderStyle = .line
        txtAge.layer.borderColor = UIColor.gray.cgColor
        txtAge.layer.borderWidth = Constants.border
        txtAge.keyboardType = .numberPad
        return txtAge
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
        return stackView
    }()
    
    lazy var btnEncrypt : UIButton = {
        let btnSubmit = UIButton()
        btnSubmit.setTitle("Create Secure Envelope", for: .normal)
        btnSubmit.backgroundColor = Color.buttonBackgroundColor
        btnSubmit.setTitleColor(UIColor.white, for: .normal)
        btnSubmit.clipsToBounds = true
        btnSubmit.layer.cornerRadius = Constants.cornerRadius
        return btnSubmit
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        addSubviews()
        makeAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [lblTitle,
         statsView,
         btnEncrypt]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setupUI() {
        backgroundColor = Color.backGroundColor
        safeArea = self.safeAreaLayoutGuide
    }
}

extension MainView {
    private func makeAutolayout() {
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.padding1),
            lblTitle.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: Constants.padding2),
            lblTitle.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -Constants.padding2),
            lblTitle.heightAnchor.constraint(equalToConstant: 40.0),
            
            statsView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant:  Constants.padding1),
            statsView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: Constants.padding2),
            statsView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -Constants.padding2),
            
            btnEncrypt.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: Constants.padding2),
            btnEncrypt.leadingAnchor.constraint(equalTo: statsView.leadingAnchor),
            btnEncrypt.trailingAnchor.constraint(equalTo: statsView.trailingAnchor),
            btnEncrypt.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
