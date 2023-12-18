//
//  saveRecipeToFireStore.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/15/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension DisplayViewController {
    
    @objc func saveBarButtonTapped() {
        if let isRecipeSaved = isRecipeSaved {
            if isRecipeSaved {
                self.showMessageAttentinoAlert("The recipe is already saved in your account. View the recipe in the saved items tab.")
          } else {
                print("Saving the recipe to firestore.")
                self.saveRecipeToFirestore(recipe: self.currentRecipe!)
            }
        }
    }
    
    func showMessageAttentinoAlert(_ messageText: String) {
        let alert = UIAlertController(title: "Attention!", message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func saveRecipeToFirestore(recipe: Recipe){
        let collectionRecipes = database.collection("recipes")

        do {
            let documentReference = try collectionRecipes.addDocument(from: recipe)
            documentReference.addSnapshotListener { documentSnapshot, error in
                if error != nil {
                    print("Error adding document: \(error!)")
                } else if let documentSnap = documentSnapshot, documentSnap.exists {
                    do {
                        let updatedRecipe = try documentSnap.data(as: Recipe.self)
                        self.createRecipeReferences(fromRecipe: updatedRecipe)
                    } catch {
                        print("Error parsing the recipe: \(error)")
                    }
                }
                else {
                    print("No error adding the recipe, but the returned document has errors.")
                }
            }
        } catch {
            print("Error saving recipe!")
        }
    }
    
    func createRecipeReferences(fromRecipe: Recipe){
        if let recipeId = fromRecipe.id,
           let user = currentUser,
           let currentUserEmail = user.email {
            let recipeReference = RecipeReference(recipeId: recipeId, isShared: false)
            saveRecipeReferenceToFirestore(reference: recipeReference, forUser: currentUserEmail)
        } else {
            print("Error creating recipe reference for user")
        }
        
    }
    
    func saveRecipeReferenceToFirestore(reference: RecipeReference, forUser: String) {
        let collectionUserRecipes = database
            .collection("users")
            .document(forUser)
            .collection("recipes")

        do {
            let collectionReference = try collectionUserRecipes.addDocument(from: reference)
            collectionReference.addSnapshotListener { documentSnapshot, error in
                if error == nil {
                    self.isRecipeSaved = true
                    self.showMessageAttentinoAlert("Successfully saved the recipe to your account!")
                }
                else {
                    print("Error adding document: \(error!)")
                }
            }
        } catch {
            print("Error sending message!")
        }
    }
}
