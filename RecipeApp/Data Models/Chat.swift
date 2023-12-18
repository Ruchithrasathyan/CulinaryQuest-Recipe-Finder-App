//
//  Chat.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/13/23.
//

import Foundation


struct ChatMessage: Codable {
    var role: String
    var content: String
}

struct ChatRequest: Codable {
    var model: String
    var messages: [ChatMessage]
}
