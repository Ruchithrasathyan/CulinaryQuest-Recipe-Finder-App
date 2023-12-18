//
//  RecipeReference.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/15/23.
//

import Foundation
import FirebaseFirestoreSwift

struct RecipeReference: Codable{
    @DocumentID var id: String?
    var recipeId: String
    var isShared: Bool
    
    init(recipeId: String, isShared: Bool) {
        self.recipeId = recipeId
        self.isShared = isShared
    }
}
