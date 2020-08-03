//
//  Profile.swift
//  Game In-Depth
//
//  Created by Indra Permana on 03/08/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import Foundation
import Combine

class Profile: ObservableObject {
    @Published var nickname: String {
        didSet {
            UserDefaults.standard.set(nickname, forKey: "nickname")
        }
    }
    
    @Published var email: String {
        didSet {
            UserDefaults.standard.set(email, forKey: "email")
        }
    }
    
    init() {
        self.nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
    func sync() {
        self.nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
    }
}
