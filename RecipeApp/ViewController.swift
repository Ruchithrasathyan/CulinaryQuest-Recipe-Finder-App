//
//  ViewController.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 11/23/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var cQLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var signupButton: UIButton!
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            print("Auth listener is working")
            if user == nil {
                print("User is NOT logged in, setting currentUser to nil")
                self.currentUser = nil
            }else{
                print("User is logged in, setting currentUser")
                self.currentUser = user
                var updatedViewController = self.navigationController?.viewControllers
                updatedViewController?.removeAll()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
                if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController {
                    
                    if let homeVC = tabBarVC.viewControllers?[0] as? HomeViewController {
                        homeVC.currentUser = self.currentUser
                    }
                    if let profileVC = tabBarVC.viewControllers?[2] as? ProfileAccountViewController {
                        profileVC.currentUser = self.currentUser
                    }
                    if let savedVC = tabBarVC.viewControllers?[1] as? SavedItemsViewController {
                        savedVC.currentUser = self.currentUser
                    }
                    
                    updatedViewController?.append(tabBarVC)
                }

                self.navigationController?.setViewControllers(updatedViewController!, animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        initConstrainsts()
    }
    
    func setup() {
        loginButton.tintColor = .black
        loginButton.alpha = 0.8
        loginButton.layer.cornerRadius = 10.0
        
        signupButton.tintColor = .black
        signupButton.alpha = 0.8
        signupButton.layer.cornerRadius = 10.0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cQLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initConstrainsts() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cQLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 82),
            cQLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -39),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: signupButton.topAnchor, constant: -34),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signupButton.widthAnchor.constraint(equalToConstant: 156),
            loginButton.widthAnchor.constraint(equalToConstant: 156),
            
            signupButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.heightAnchor.constraint(equalToConstant: 40)

        ])
    }


}

