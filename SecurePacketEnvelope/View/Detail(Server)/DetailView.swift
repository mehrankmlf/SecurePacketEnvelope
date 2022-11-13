//
//  Detail(Server).swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 9/22/22.
//

import UIKit

class DetailView: UIView {
    
    private enum Constants {
        static let titleFontSize  : CGFloat = 35
        static let normalFontSize : CGFloat = 15
        static let border         : CGFloat = 1.0
        static let cornerRadius   : CGFloat = 10.0
        static let padding1       : CGFloat = 10.0
        static let padding2       : CGFloat = 20.0
        static let generalHeight  : CGFloat = 25.0
    }
    
    private var safeArea: UILayoutGuide!
    
    lazy var lblTitle : UILabel = {
        let label = UILabel()
        label.text = "Decrypt Data"
        label.textAlignment = .left
        label.textColor = Color.fontTextColor
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        return label
    }()
    
    lazy var lblDecrypt : UITopAlignedLabel = {
        let lblEncrypted = UITopAlignedLabel()
        lblEncrypted.text = ""
        lblEncrypted.textColor = Color.fontTextColor
        lblEncrypted.layer.borderWidth = Constants.border
        lblEncrypted.layer.borderColor = UIColor.gray.cgColor
        lblEncrypted.numberOfLines = 0
        lblEncrypted.font = UIFont.boldSystemFont(ofSize: Constants.normalFontSize)
        lblEncrypted.translatesAutoresizingMaskIntoConstraints = false
        return lblEncrypted
    }()
    
    lazy var btnDecrypt : UIButton = {
        let btnSubmit = UIButton()
        btnSubmit.setTitle("Decrypt Secure Envelope", for: .normal)
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
        [lblTitle, lblDecrypt, btnDecrypt]
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

extension DetailView {
    private func makeAutolayout() {
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.padding1),
            lblTitle.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -Constants.padding1),
            lblTitle.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: Constants.padding1),
            lblTitle.heightAnchor.constraint(equalToConstant: 50),
            
            lblDecrypt.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: Constants.padding2),
            lblDecrypt.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -Constants.padding1),
            lblDecrypt.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: Constants.padding1),
            lblDecrypt.heightAnchor.constraint(equalToConstant: 200),
            
            btnDecrypt.topAnchor.constraint(equalTo: lblDecrypt.bottomAnchor, constant: Constants.padding2),
            btnDecrypt.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -Constants.padding1),
            btnDecrypt.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: Constants.padding1),
            btnDecrypt.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
