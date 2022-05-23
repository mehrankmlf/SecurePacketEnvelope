//
//  MainViewModel.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 5/23/22.
//

import Foundation
import Combine

class MainViewModel {
    
    @Published var fullName : String = ""
    @Published var email : String = ""
    @Published var age : String = ""
    
    let fullNameMessagePublisher = PassthroughSubject<String, Never>()
    let emailMessagePublisher = PassthroughSubject<String, Never>()
}

extension MainViewModel {
    
    var validateFullName : AnyPublisher<String?, Never> {
        
        $fullName
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { fullName in
                guard fullName.count != 0 else {
                    self.fullNameMessagePublisher.send("Username can't be blank")
                    return nil
                }
                
                guard fullName.count > 2 else {
                    self.fullNameMessagePublisher.send("Minimum of 3 characters required")
                    return nil
                }
                
                self.fullNameMessagePublisher.send("")
                
                return fullName
            }.eraseToAnyPublisher()
    }
    
    var validateEmail : AnyPublisher<String?, Never> {
        
        $email
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { validateEmail in
                guard validateEmail.count != 0 else {
                    self.emailMessagePublisher.send("Username can't be blank")
                    return nil
                }
                
                guard validateEmail.count > 2 else {
                    self.emailMessagePublisher.send("Minimum of 3 characters required")
                    return nil
                }
                return validateEmail
            }.eraseToAnyPublisher()
    }
    
     var formValidation: AnyPublisher<(String, String)?, Never> {
        
       return Publishers.CombineLatest(validateFullName, validateEmail)
            .map { name, pass in
                guard let name = name, let pass = pass else {
                    return nil
                }
                return (name, pass)
            }
            .eraseToAnyPublisher()
    }
}
