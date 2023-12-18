//
//  RegisterViewController.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 11/26/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    
    
    @IBOutlet var label: UILabel!
    
    
    @IBOutlet var userLabel: UILabel!
    
    
    
    @IBOutlet var emailLabel: UILabel!
    
    
    
    @IBOutlet var PassLabel: UILabel!
    
    
    @IBOutlet var RegisterName: UITextField!
    
    
    @IBOutlet var SignupLabel: UIButton!
    
    
    @IBOutlet var RegisterEmail: UITextField!
    
    
    @IBOutlet var RegisterPassword: UITextField!
    
    var gradientLayer: CAGradientLayer!
    
    let database = Firestore.firestore()
    
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupScrollView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
            tapRecognizer.cancelsTouchesInView = false
            view.addGestureRecognizer(tapRecognizer)
       setup()
       initConstrainsts()
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    func setupScrollView() {
            // Initialize the scroll view and add it to the view
            scrollView = UIScrollView(frame: .zero)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scrollView)
            
            // Constrain the scroll view to the entire view
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            // Add the previously added subviews to the scroll view instead
            scrollView.addSubview(label)
            scrollView.addSubview(userLabel)
            scrollView.addSubview(emailLabel)
            scrollView.addSubview(PassLabel)
            scrollView.addSubview(RegisterName)
            scrollView.addSubview(SignupLabel)
            scrollView.addSubview(RegisterEmail)
            scrollView.addSubview(RegisterPassword)
        }
    
    func setup()
    {
        SignupLabel.tintColor = .black
        SignupLabel.alpha = 0.4
        SignupLabel.layer.cornerRadius = 10.0
        
        RegisterPassword.isSecureTextEntry = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints =  false
        PassLabel.translatesAutoresizingMaskIntoConstraints = false
        RegisterName.translatesAutoresizingMaskIntoConstraints = false
        SignupLabel.translatesAutoresizingMaskIntoConstraints = false
        RegisterEmail.translatesAutoresizingMaskIntoConstraints = false
        RegisterPassword.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    
    func initConstrainsts()
    {
        let contentLayoutGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 82),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),
            userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            RegisterName.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 22),
            RegisterName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: RegisterName.bottomAnchor, constant: 32),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            RegisterEmail.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 18),
            RegisterEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            PassLabel.topAnchor.constraint(equalTo: RegisterEmail.bottomAnchor, constant: 42),
            PassLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            RegisterPassword.topAnchor.constraint(equalTo: PassLabel.bottomAnchor, constant: 19),
            RegisterPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            SignupLabel.topAnchor.constraint(equalTo: RegisterPassword.bottomAnchor, constant: 61),
            SignupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            RegisterName.widthAnchor.constraint(equalToConstant: 233),
            RegisterEmail.widthAnchor.constraint(equalToConstant: 233),
            RegisterPassword.widthAnchor.constraint(equalToConstant: 233),
            SignupLabel.widthAnchor.constraint(equalToConstant: 91),
            
            SignupLabel.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -20)
        
        ])
        
        
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
    
    
    @IBAction func RegisterSubmit(_ sender: Any) {
        
        if let name = RegisterName.text, !name.isEmpty , let password = RegisterPassword.text, !password.isEmpty, let email = RegisterEmail.text,!email.isEmpty {
            if isValidEmail(email){
                if password.count >= 6{
                    Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
                        if error == nil {
                            //MARK: The user creation is successful...
                            self.setNameOfTheUserInFirebaseAuth(name: name, email: email)
                        } else {
                            //MARK: There is an error creating the user...
                            showAlert(message: "Error creating user: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }else{
                    showAlert(message: "Password must be at least 6 characters long.")
                }
                
            }else{
                showAlert(message: "Please enter a valid email address.")
            }
        }else{
            showAlert(message: "Please enter all required information.")
        }
    
        
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        // Simple email validation, you might want to use a more robust method
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String, email: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { [weak self] error in
            if error == nil {
                // MARK: The profile update is successful...
                let user = User(name: name, email: email)
                self?.saveUserToFirestore(user: user)
            } else {
                // MARK: There was an error updating the profile...
               // print("Error occurred: \(String(describing: error))")
                // You can handle the error further if needed, e.g., display an alert to the user
                let errorMessage = "Error updating profile: \(error?.localizedDescription ?? "Unknown error")"
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    func saveUserToFirestore(user: User) {
        let collectionUsers = database.collection("users")
        collectionUsers.document(user.email.lowercased()).setData([
            "email": user.email.lowercased(),
            "name": user.name
        ]) { error in
            if error != nil {
                print(error!)
            } else {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }

    
}
