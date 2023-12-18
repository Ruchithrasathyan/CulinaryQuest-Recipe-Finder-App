//
//  SearchRecipiesInAPI.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/13/23.
//

import Foundation
import UIKit

extension HomeViewController {
    
    func showMessageErrorAlert(_ messageText: String) {
        let alert = UIAlertController(title: "Error!", message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showActivityIndicator() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.center = view.center
            activityIndicator?.color = .orange
            view.addSubview(activityIndicator!)
        }

        activityIndicator?.startAnimating()
    }

    // Function to hide the activity indicator
    func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
    
    func sendPromptToAPI(promptString: String) {
        print("Connecting to API")
        
        let prompt = "give me a recipe for \(promptString) with in the following format 1. \"title\", 2. \"ingredients\", 3.\"servings\", 4. \"steps\", 5. \"time\". The output should be in a json format with the above keys. The \"servings\" should be an int. The output should not have anything but the json."
        
        guard let url = Utilities.APIUrl
        else {
            print("The API URL is nil")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Utilities.APIKey)", forHTTPHeaderField: "Authorization")
        
        let chatRequest = ChatRequest(
            model: "gpt-3.5-turbo",
            messages: [
                ChatMessage(role: "user", content: prompt)
            ]
        )
        
        self.showActivityIndicator()
        
        do {
            let requestjsonData = try JSONEncoder().encode(chatRequest)
            if let requestjsonString = String(data: requestjsonData, encoding: .utf8) {
                print(requestjsonString)
                request.httpBody = requestjsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print(error)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        let statusCode = httpResponse.statusCode
                        switch statusCode{
                            case 200...299:
                                print("Found a recipe")
                            if let data = data {
                                do {
                                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                                    if let dict = jsonResponse as? [String:Any],
                                       let answers = dict["choices"] as? [[String: Any]],
                                       let firstAnswer = answers.first,
                                       let message = firstAnswer["message"] as? [String: Any],
                                       let content = message["content"] as? String{
                                        print(content)
                                        if let contentData = content.data(using: .utf8),
                                           let contentJson = try? JSONSerialization.jsonObject(with: contentData, options: []) as? [String: Any] {
                                            // Now 'json' contains the parsed JSON object
                                            print(contentJson)
                                            do {
                                                let newRecipe = try JSONDecoder().decode(RecipeAPI.self, from: contentData)
                                                print("created a new recipe")
                                                print(newRecipe.title)
                                                self.selectedRecipe = Recipe(recipeInput: newRecipe)
                                                
                                                DispatchQueue.main.async {
                                                    self.clearTextFields()
                                                    self.hideActivityIndicator()
                                                    self.performSegue(withIdentifier: "DisplayRecipe", sender: self)
                                                }
                                            } catch {
                                                print("Error decoding JSON: \(error)")
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.hideActivityIndicator()
                                                self.showMessageErrorAlert(content)
                                            }
                                        }
                                    }
                                } catch {
                                    print("error creating a json dictionary from the respnse data.")
                                }
                            }
                            break
                                        
                            case 400...499:
                            print(statusCode)
                            if let data = data {
                                do {
                                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                        print(jsonResponse)
                                    }
                                } catch {
                                    print("error parsing 400 response")
                                }
                            }
                            break
                        
                            default:
                            print(data ?? " 500 none")
                            break
                        }
                    }
                }
                task.resume()
            }
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }
    
    func clearTextFields() {
        self.ingredientsTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayRecipe" {
            if let DisplayVC = segue.destination as? DisplayViewController {
                DisplayVC.currentUser = self.currentUser
                DisplayVC.currentRecipe = self.selectedRecipe
                DisplayVC.isRecipeSaved = false
            }
        }
    }
}
