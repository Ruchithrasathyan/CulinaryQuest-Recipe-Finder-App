//
//  recipe.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/14/23.
//

import Foundation
import FirebaseFirestoreSwift

struct RecipeAPI: Codable {
    var title: String
    var ingredients: [String]
    var steps: [String]
    var servings: Int
    var time: String
}

struct Recipe: Codable {
    @DocumentID var id: String?
    var title: String
    var ingredients: [String]
    var steps: [String]
    var servings: Int
    var time: String
    
    init(recipeInput: RecipeAPI) {
        self.title = recipeInput.title
        self.ingredients  = recipeInput.ingredients
        self.servings = recipeInput.servings
        self.time = recipeInput.time
        self.steps = recipeInput.steps
    }
    
}
