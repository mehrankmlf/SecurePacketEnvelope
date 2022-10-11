//
//  Detail(Server).swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 9/22/22.
//

import UIKit

class DetailView: UIView {
    
    private var safeArea: UILayoutGuide!
    
    var viewContainer : UIView = {
        let viewContainer = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        return viewContainer
    }()
    
    lazy var lblTitle : UILabel = {
        let label = UILabel()
        label.text = "Decrypt Data"
        label.textAlignment = .left
        label.textColor = Color.fontTextColor
        label.font = UIFont.boldSystemFont(ofSize: 35)
        return label
    }()
    
    lazy var lblDecrypt : UITopAlignedLabel = {
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
    
    lazy var btnDecrypt : UIButton = {
       let btnSubmit = UIButton()
       btnSubmit.setTitle("Decrypt Secure Envelope", for: .normal)
       btnSubmit.backgroundColor = Color.buttonBackgroundColor
       btnSubmit.setTitleColor(UIColor.white, for: .normal)
       btnSubmit.clipsToBounds = true
       btnSubmit.layer.cornerRadius = 10.0
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
        addSubview(viewContainer)
        [lblTitle, lblDecrypt, btnDecrypt]
            .forEach {
                viewContainer.addSubview($0)
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
        viewContainer.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        viewContainer.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        
        lblTitle.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 20).isActive = true
        lblTitle.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10).isActive = true
        lblTitle.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10).isActive = true
        lblTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true

        lblDecrypt.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20).isActive = true
        lblDecrypt.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10).isActive = true
        lblDecrypt.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10).isActive = true
        lblDecrypt.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        btnDecrypt.topAnchor.constraint(equalTo: lblDecrypt.bottomAnchor, constant: 20).isActive = true
        btnDecrypt.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10).isActive = true
        btnDecrypt.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10).isActive = true
        btnDecrypt.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
