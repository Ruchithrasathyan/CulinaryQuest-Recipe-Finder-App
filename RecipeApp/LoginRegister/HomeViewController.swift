//
//  HomeViewController.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 11/27/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    let ingredientsTextField = UITextField()
    var RecipeButton = UIButton()
    var recipeInstructions: String?
    
    var currentUser: FirebaseAuth.User?
    
    var activityIndicator: UIActivityIndicatorView?
    
    var selectedRecipe:Recipe?
    
    var gradientLayer: CAGradientLayer!
    
    var scrollView: UIScrollView!
    var labelTitle: UILabel!
    var logoView: UIImageView!

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
            tapRecognizer.cancelsTouchesInView = false
            view.addGestureRecognizer(tapRecognizer)
        
        print("Welcome \(self.currentUser!.displayName!)")
            if let tabBar = self.tabBarController?.tabBar {
            tabBar.isTranslucent = true
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
            tabBar.barTintColor = .white
            tabBar.backgroundColor = UIColor.clear
        }
        
        setupGradient()
        setup()
        setupIngredientsTextField()
        setupButton()
        
        initConstraints()
        
        self.RecipeButton.addTarget(self, action: #selector(onRecipeButtonClicked), for: .touchUpInside)
        
        //navigationItem.hidesBackButton = true
//        let logoutButton = UIButton(type: .system)
//                logoutButton.setTitle("Logout", for: .normal)
//                logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
//
//                // Add the button to the navigation bar
//                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
         
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       @objc func keyboardWillShow(notification: NSNotification) {
           guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               return
           }
           scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
           scrollView.scrollIndicatorInsets = scrollView.contentInset
       }
       
       @objc func keyboardWillHide(notification: NSNotification) {
           scrollView.contentInset = .zero
           scrollView.scrollIndicatorInsets = .zero
       }
    
    func setup() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        labelTitle = UILabel()
        labelTitle.font = UIFont(name: "Zapfino", size: 29)
        labelTitle.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.text = "Culinary Quest"
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(labelTitle)
    }
    
    func initConstraints() {
        print("here")
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            labelTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            labelTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            ingredientsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            ingredientsTextField.trailingAnchor.constraint(equalTo: RecipeButton.leadingAnchor, constant: -10),
            ingredientsTextField.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            ingredientsTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
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
    
    @objc func onRecipeButtonClicked() {
        
        if let prompt = self.ingredientsTextField.text {
            if prompt.isEmpty {
                self.showFieldEmptyErrorAlert()
            } else {
                self.sendPromptToAPI(promptString: prompt)
            }
        }
    }
    
    func showFieldEmptyErrorAlert() {
        let alert = UIAlertController(title: "Error!", message: "The recipe field is empty! Please Recheck!!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func setupButton()
    {
        view.addSubview(RecipeButton)
        RecipeButton.translatesAutoresizingMaskIntoConstraints = false
        RecipeButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        RecipeButton.backgroundColor = .black
        RecipeButton.alpha = 0.4
        RecipeButton.tintColor = .systemGray2
        RecipeButton.layer.cornerRadius = 6.0
        
        logoView = UIImageView()
        logoView.contentMode = .scaleAspectFit
        logoView.image = UIImage(named: "whiteLogo")
        logoView.alpha = 0.6
        logoView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            
            RecipeButton.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            RecipeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            RecipeButton.widthAnchor.constraint(equalToConstant: 44),
            RecipeButton.heightAnchor.constraint(equalToConstant: 44),
            
            logoView.topAnchor.constraint(equalTo: RecipeButton.topAnchor, constant: 150),
            logoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 230),
            logoView.widthAnchor.constraint(equalToConstant: 230),
            
            logoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
        
        
//        RecipeButton.addTarget(self, action: #selector(self.getRecipesButtonTapped), for: .touchUpInside)
//        view.addSubview(RecipeButton)
        
        
    }
    
//    @objc func getRecipesButtonTapped() {
//            if let recipeName = ingredientsTextField.text {
//                // Call ChatGPT API with the recipe name
//               // fetchRecipes(named: recipeName)
//            }
//        }
    
    func setupIngredientsTextField()
    {
        view.addSubview(ingredientsTextField)
        ingredientsTextField.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTextField.placeholder = "Search for a recipe here"
        ingredientsTextField.font = UIFont.systemFont(ofSize: 16)
        ingredientsTextField.borderStyle = .roundedRect
        ingredientsTextField.layer.cornerRadius = 6.0
        ingredientsTextField.autocorrectionType = .no
        ingredientsTextField.clearButtonMode = .whileEditing
        ingredientsTextField.returnKeyType = .search
        ingredientsTextField.delegate = self
               
        
    }
    
    
    
    
    
    
//    @objc func logoutButtonTapped() {
//            do {
//                // Perform logout
//                try Auth.auth().signOut()
//
//                // Navigate to the login or sign-up page
//                // Replace "YourLoginViewController" with the actual class name of your login view controller
//                //performSegue(withIdentifier: "BackToLoginIdentifier", sender: self)
////                let firstview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewControllerId")
//                
//                var updatedViewController = navigationController?.viewControllers; updatedViewController?.removeLast(2)
//                
//                navigationController?.setViewControllers(updatedViewController!, animated: true)
//            } catch {
//                print("Error signing out: \(error.localizedDescription)")
//            }
//        }


    @objc func SearchText()
    
    {
       
        
    }
    
    
    
}
