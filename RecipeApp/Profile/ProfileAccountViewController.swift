//
//  ProfileAccountViewController.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileAccountViewController: UIViewController {
    
    
    var gradientLayer: CAGradientLayer!

    var scrollView: UIScrollView!
    var labelTitle: UILabel!
    var labelEmail: UILabel!
    var labelEmail2: UILabel!
    var logoutButton: UIButton!
    
    var serveContextView: UIView!
    
    var LogoutButton:UIButton!
    
    var currentUser: FirebaseAuth.User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
            tapRecognizer.cancelsTouchesInView = false
            view.addGestureRecognizer(tapRecognizer)
        
        
        setup()
        initConstraints()
        
        
    }
    
    func setup() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        
        labelTitle = UILabel()
        labelTitle.font = UIFont(name: "Zapfino", size: 29)
        labelTitle.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.text = "Profile"
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(labelTitle)
        
        labelEmail = UILabel()
        labelEmail.font = UIFont(name: "Georgia-Bold", size: 25)
        labelEmail.numberOfLines = 0
        labelEmail.lineBreakMode = .byWordWrapping
        labelEmail.text = "Welcome \(self.currentUser!.displayName!) ❤️"
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(labelEmail)
        
        serveContextView = UIView()
        serveContextView.backgroundColor = .black
        serveContextView.alpha = 0.25
        serveContextView.layer.cornerRadius = 6.0
        serveContextView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(serveContextView)
        
        labelEmail2 = UILabel()
        labelEmail2.font = UIFont(name: "Georgia-Bold", size: 16)
        labelEmail2.textColor = .white
        labelEmail2.numberOfLines = 0
        labelEmail2.lineBreakMode = .byWordWrapping
        labelEmail2.text = "Email: \(self.currentUser!.email!)"
        labelEmail2.translatesAutoresizingMaskIntoConstraints = false
        serveContextView.addSubview(labelEmail2)
        
        logoutButton = UIButton()
        scrollView.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .black
        logoutButton.alpha = 0.4
        logoutButton.layer.cornerRadius = 6.0
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            labelTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            labelTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            labelEmail.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 15),
            labelEmail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            serveContextView.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 10),
            serveContextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            serveContextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            labelEmail2.topAnchor.constraint(equalTo: serveContextView.topAnchor, constant: 10),
            labelEmail2.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            serveContextView.bottomAnchor.constraint(equalTo: labelEmail2.bottomAnchor, constant: 10),
            
            logoutButton.topAnchor.constraint(equalTo: serveContextView.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 91)
        ])
    }
    
    @objc func logoutButtonTapped() {
                do {
                    // Perform logout
                    print("signout1")
                    try Auth.auth().signOut()
                    print("signout")
    
                   
    
                    var updatedViewController = navigationController?.viewControllers
                    updatedViewController?.removeAll()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "FirstViewControllerId") as? ViewController {
                        updatedViewController?.append(viewController)
                    }
    
                    navigationController?.setViewControllers(updatedViewController!, animated: true)
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    func setupGradient() {
        view.backgroundColor = .white
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.brown.cgColor, UIColor.darkGray.cgColor, ]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    
    
    
}
