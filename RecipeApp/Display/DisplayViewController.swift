//
//  DisplayViewController.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/14/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DisplayViewController: UIViewController {
    
    let database = Firestore.firestore()
    
    var currentUser:FirebaseAuth.User?
    var currentRecipe: Recipe?
    var gradientLayer: CAGradientLayer!
    
    var scrollView: UIScrollView!
    var labelTitle: UILabel!
    var labelServes: UILabel!
    var labelTime: UILabel!
    var serveContextView: UIView!
    
    var ingedientsView: UIView!
    var ingredientsLabel: UILabel!
    var labelIngredientsList = [UILabel]()
    
    var stepsView: UIView!
    var stepsLabel: UILabel!
    var labelStepsList = [UILabel]()
    
    var isRecipeSaved:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupGradient()
        
        // Do any additional setup after loading the view.
        print("Dispaly Page")
        print(self.currentRecipe!.title)
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
        
        if isRecipeSaved! {
            self.setupShareBarButton()
        } else {
            self.setupSaveBarButton()
        }
        
        setup()
        initConstraints()
        
    }
    
    func setupSaveBarButton() {
//        let button = UIButton(type: .custom)
//        if let image = UIImage(systemName: "arrow.down.circle.fill") {
//            button.setImage(image, for: .normal)
//        }
//        button.imageView?.contentMode = .scaleAspectFit
//        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        button.addTarget(self, action: #selector(saveBarButtonTapped), for: .touchUpInside)
        
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "arrow.down.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(saveBarButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = barIcon
    }
    
    func setupShareBarButton() {
//        let button = UIButton(type: .custom)
//        if let image = UIImage(systemName: "square.and.arrow.up.circle.fill") {
//            button.setImage(image, for: .normal)
//        }
//        button.imageView?.contentMode = .scaleAspectFit
//        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        button.addTarget(self, action: #selector(shareBarButtonTapped), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(shareBarButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = barIcon
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
    
    func setup() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        labelTitle = UILabel()
        labelTitle.font = UIFont(name: "Zapfino", size: 24)
        labelTitle.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.text = self.currentRecipe!.title
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(labelTitle)
        
        serveContextView = UIView()
        serveContextView.backgroundColor = .black
        serveContextView.layer.cornerRadius = 10
        serveContextView.alpha = 0.25
        serveContextView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(serveContextView)
        
        labelTime = UILabel()
        labelTime.font = UIFont.boldSystemFont(ofSize: 18)
        labelTime.textColor = .white
        labelTime.numberOfLines = 0
        labelTime.lineBreakMode = .byWordWrapping
        labelTime.text = "Approx. Time: \(self.currentRecipe!.time)"
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        serveContextView.addSubview(labelTime)
        
        labelServes = UILabel()
        labelServes.font = UIFont.boldSystemFont(ofSize: 18)
        labelServes.textColor = .white
        labelServes.numberOfLines = 0
        labelServes.lineBreakMode = .byWordWrapping
        labelServes.text = "Serves: \(self.currentRecipe!.servings) people"
        labelServes.translatesAutoresizingMaskIntoConstraints = false
        serveContextView.addSubview(labelServes)
        
        ingedientsView = UIView()
        ingedientsView.backgroundColor = .black
        ingedientsView.layer.cornerRadius = 10
        ingedientsView.alpha = 0.25
        ingedientsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(ingedientsView)
        
        ingredientsLabel = UILabel()
        ingredientsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        ingredientsLabel.textColor = .white
        ingredientsLabel.text = "Ingredients:"
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingedientsView.addSubview(ingredientsLabel)
        
        for ingredient in self.currentRecipe!.ingredients {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.text = ingredient
            label.translatesAutoresizingMaskIntoConstraints = false
            ingedientsView.addSubview(label)
            labelIngredientsList.append(label)
        }
        
        stepsView = UIView()
        stepsView.backgroundColor = .black
        stepsView.layer.cornerRadius = 10
        stepsView.alpha = 0.25
        stepsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stepsView)
        
        stepsLabel = UILabel()
        stepsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stepsLabel.textColor = .white
        stepsLabel.text = "Steps:"
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsView.addSubview(stepsLabel)
        
        for step in self.currentRecipe!.steps {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.text = step
            label.translatesAutoresizingMaskIntoConstraints = false
            stepsView.addSubview(label)
            labelStepsList.append(label)
        }
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            labelTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            labelTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            serveContextView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            serveContextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            serveContextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            serveContextView.heightAnchor.constraint(equalToConstant: 50),
            
            labelTime.topAnchor.constraint(equalTo: serveContextView.topAnchor, constant: 10),
            labelTime.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            labelServes.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: 10),
            labelServes.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            serveContextView.bottomAnchor.constraint(equalTo: labelServes.bottomAnchor, constant: 10),
            
            ingedientsView.topAnchor.constraint(equalTo: serveContextView.bottomAnchor, constant: 10),
            ingedientsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            ingedientsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            ingredientsLabel.leadingAnchor.constraint(equalTo: ingedientsView.leadingAnchor, constant: 10),
            ingredientsLabel.trailingAnchor.constraint(equalTo: ingedientsView.trailingAnchor, constant: -10),
            ingredientsLabel.topAnchor.constraint(equalTo: ingedientsView.topAnchor, constant: 10)
        ])
        
        var lastIngredientLabel: UILabel? = nil
        
        for iLabel in labelIngredientsList {
            NSLayoutConstraint.activate([
                iLabel.leadingAnchor.constraint(equalTo: ingedientsView.leadingAnchor, constant: 10),
                iLabel.trailingAnchor.constraint(equalTo: ingedientsView.trailingAnchor, constant: -10),
                iLabel.topAnchor.constraint(equalTo: lastIngredientLabel?.bottomAnchor ?? ingredientsLabel.bottomAnchor, constant: 10)
            ])
            
            lastIngredientLabel = iLabel
        }
        
        NSLayoutConstraint.activate([
            ingedientsView.bottomAnchor.constraint(equalTo: lastIngredientLabel!.bottomAnchor, constant: 10),
            
            stepsView.topAnchor.constraint(equalTo: ingedientsView.bottomAnchor, constant: 10),
            stepsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stepsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stepsLabel.leadingAnchor.constraint(equalTo: stepsView.leadingAnchor, constant: 10),
            stepsLabel.trailingAnchor.constraint(equalTo: stepsView.trailingAnchor, constant: -10),
            stepsLabel.topAnchor.constraint(equalTo: stepsView.topAnchor, constant: 10),
        ])
        
        var lastStepLabel: UILabel? = nil
        
        for iLabel in labelStepsList {
            NSLayoutConstraint.activate([
                iLabel.leadingAnchor.constraint(equalTo: stepsView.leadingAnchor, constant: 10),
                iLabel.trailingAnchor.constraint(equalTo: stepsView.trailingAnchor, constant: -10),
                iLabel.topAnchor.constraint(equalTo: lastStepLabel?.bottomAnchor ?? stepsLabel.bottomAnchor, constant: 10)
            ])
            
            lastStepLabel = iLabel
        }
        
        NSLayoutConstraint.activate([
            stepsView.bottomAnchor.constraint(equalTo: lastStepLabel!.bottomAnchor, constant: 10),
            stepsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    

    
}
