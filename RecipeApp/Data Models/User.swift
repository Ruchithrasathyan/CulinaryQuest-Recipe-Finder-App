//
//  User.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/13/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable{
    var email: String
    var name: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
