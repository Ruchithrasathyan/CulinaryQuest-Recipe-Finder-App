//
//  shareRecipeToUsers.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/15/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

extension DisplayViewController {
    
    @objc func shareBarButtonTapped() {
        let shareRecipeAlert = UIAlertController(
            title: "Share Recipe",
            message: "Enter the email of the user you want to share this budget plan.",
            preferredStyle: .alert)
        
        //MARK: setting up user email textField in the alert...
        shareRecipeAlert.addTextField{ textField in
            textField.placeholder = "Enter email Id"
            textField.contentMode = .center
        }
        
        //MARK: Add user to plan
        let createUserAction = UIAlertAction(title: "Share", style: .default, handler: {(_) in
            if let email = shareRecipeAlert.textFields![0].text,
               let currentRecipe = self.currentRecipe,
               let recipeId = currentRecipe.id {
                let recipeReference = RecipeReference(recipeId: recipeId, isShared: true)
                self.saveSharedRecipeReferenceToFirestore(recipeReference: recipeReference, forUser: email)
            }
        })
        
        shareRecipeAlert.addAction(createUserAction)
        
        self.present(shareRecipeAlert, animated: true, completion: {() in
            shareRecipeAlert.view.superview?.isUserInteractionEnabled = true
            shareRecipeAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        })
    }
    
    func saveSharedRecipeReferenceToFirestore(recipeReference: RecipeReference, forUser userEmail: String) {
        let userDocument = database.collection("users").document(userEmail)

        // Check if user document exists
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                // User exists, proceed to add BudgetPlanReference
                do {
                    try userDocument.collection("recipes").addDocument(from: recipeReference) { error in
                        if error != nil {
                            print("Error adding document: \(error!)")
                        } else {
                            print("Recipe reference shared successfully!")
                            self.showErrorAlert(title: "Success", message: "Successfully Shared Recipe!")
                        }
                    }
                } catch {
                    print("Error adding budget plan reference: \(error)")
                }
            } else {
                // User does not exist
                self.showErrorAlert(title: "Error sharing recipe", message: "User does not exist.")
            }
        }
    }
    
    func showErrorAlert(title: String, message: String){
        let alert = UIAlertController(
            title: title, message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    @objc func onTapOutsideAlert(){
        self.dismiss(animated: true)
    }
}
