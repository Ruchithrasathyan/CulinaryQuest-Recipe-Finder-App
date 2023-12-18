//
//  SavedItemsViewController.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/15/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SavedItemsViewController: UIViewController {
    
    var currentUser: FirebaseAuth.User?
    var database = Firestore.firestore()
    var gradientLayer: CAGradientLayer!
    var savedRecipes = [Recipe]()
    var savedRecipeReferneces = [RecipeReference]()
    var sharedRecipes = [Recipe]()
    var sharedRecipeReferneces = [RecipeReference]()
    var selectedRecipe: Recipe?
    
    var labelTitle: UILabel!
    var tableViewRecipes: UITableView!
    
    var headerViewlist = [UIView]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecipesFromFireStore()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = .yellow
        setupGradient()
        setup()
        initConstrainsts()
        
        tableViewRecipes.dataSource = self
        tableViewRecipes.delegate = self
        
        print("Loading saved Recipes for \(currentUser!.displayName!)")
    }
    
    func loadRecipesFromFireStore() {
        if let current = currentUser, let currentEmail = current.email {
            print("Loading saved recipes for \(currentEmail)")
            self.database.collection("users")
                .document(currentEmail)
                .collection("recipes")
                .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                    self.savedRecipeReferneces.removeAll()
                    self.sharedRecipeReferneces.removeAll()
                    
                    if let documents = querySnapshot?.documents{
                        print("Found \(documents.count) recipes associated to this user")
                        var recipeReferences = [RecipeReference]()
                        var recipefromAPIReferences = [RecipeReference]()
                        var recipefromOtherUsersReferences = [RecipeReference]()
                        
                        for document in documents{
                            do {
                                let recipeReference = try document.data(as: RecipeReference.self)
                                if recipeReference.isShared {
                                    recipeReferences.append(recipeReference)
                                    recipefromOtherUsersReferences.append(recipeReference)
                                } else {
                                    recipeReferences.append(recipeReference)
                                    recipefromAPIReferences.append(recipeReference)
                                }
                            } catch {
                                print("Error parsing recipe references \(error)")
                            }
                        }
                        self.savedRecipeReferneces = recipefromAPIReferences
                        self.sharedRecipeReferneces = recipefromOtherUsersReferences
                        self.loadRecipes(fromList: recipeReferences)
                    }
                    else {
                        print("The query did not return any recipe references")
                    }
                })
        }
    }
    
    func loadRecipes(fromList: [RecipeReference]) {
        self.savedRecipes.removeAll()
        self.sharedRecipes.removeAll()
        
        for recipeReference in fromList {
            self.database.collection("recipes")
                .document(recipeReference.recipeId)
                .addSnapshotListener(includeMetadataChanges: false, listener: {documentSnapshot, error in
                    if let document = documentSnapshot, document.exists {
                        do {
                            let recipe = try document.data(as: Recipe.self)
                            if recipeReference.isShared {
                                self.sharedRecipes.append(recipe)
                                self.tableViewRecipes.reloadData()
                            } else {
                                self.savedRecipes.append(recipe)
                                self.tableViewRecipes.reloadData()
                            }
                            
                        }catch{
                            print("Error parsing recipe \(error)")
                        }
                    }
                    else {
                        print("The query did not return any recipes")
                    }
                })
        }

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
        labelTitle = UILabel()
        labelTitle.font = UIFont(name: "Zapfino", size: 24)
        labelTitle.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.text = "Saved Recipes"
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelTitle)
        
        tableViewRecipes = UITableView()
        tableViewRecipes.backgroundColor = .clear
        tableViewRecipes.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        tableViewRecipes.rowHeight = UITableView.automaticDimension
        tableViewRecipes.estimatedRowHeight = 44
        tableViewRecipes.separatorStyle = .none
        tableViewRecipes.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableViewRecipes)
    }
    
    func initConstrainsts() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            tableViewRecipes.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            tableViewRecipes.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableViewRecipes.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableViewRecipes.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    

}

extension SavedItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.savedRecipes.count
        } else {
            return self.sharedRecipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var recipeList = [Recipe]()
        var recipeRefList = [RecipeReference]()
        
        if indexPath.section == 0 {
            recipeList = self.savedRecipes
            recipeRefList = self.savedRecipeReferneces
        } else {
            recipeList = self.sharedRecipes
            recipeRefList = self.sharedRecipeReferneces
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        cell.labelRecipe.text = recipeList[indexPath.row].title
        
        cell.sliderButton.showsMenuAsPrimaryAction = true
        cell.sliderButton.menu = UIMenu(title: "Delete?",
                                        children: [
                                            UIAction(title: "Delete",handler: {(_) in
                                                self.deleteSelectedFor(item: recipeRefList[indexPath.row])
                                            }),
                                        ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var recipeList = [Recipe]()
        
        if indexPath.section == 0 {
            recipeList = self.savedRecipes
        } else {
            recipeList = self.sharedRecipes
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedRecipe = recipeList[indexPath.row]
//        displaySaved
        self.performSegue(withIdentifier: "displaySaved", sender: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.layer.cornerRadius = 5.0

        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: 30))
        if section == 0 {
            if self.savedRecipes.isEmpty {
                headerLabel.text = ""
            } else {
                headerLabel.text = "Your Recipes"
            }
        } else {
            if self.sharedRecipes.isEmpty {
                headerLabel.text = ""
            } else {
                headerLabel.text = "Recipes Shared with You"
            }
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16) // Customize font
        headerLabel.textColor = .systemGray2

        headerView.addSubview(headerLabel)
        headerViewlist.append(headerView)
        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        var headerView1 = self.headerViewlist.first
        if offsetY > 0 {
            headerView1!.isHidden = true
        } else {
            headerView1!.isHidden = false
        }
    }

    
    func deleteSelectedFor(item: RecipeReference) {
        let deleteAlert = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this Recipe?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.deleteRecipe(item: item)
        }
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(deleteAlert, animated: true)
    }
    
    func deleteRecipe(item: RecipeReference) {
        if let currentUser = self.currentUser {
            let recipeRef = self.database.collection("users")
                .document(currentUser.email!)
                .collection("recipes")
                .document(item.id!)
            
            recipeRef.delete { error in
                if let error = error {
                    print("Error deleting document in subcollection: \(error.localizedDescription)")
                } else {
                    print("Recipe successfully deleted!")
                    self.showMessageSuccessAlert(messageText: "Successfully deleted the Recipe")
                }
            }
        }
    }
    
    func showMessageSuccessAlert(messageText: String) {
        let alert = UIAlertController(title: "Success!", message: messageText, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySaved" {
            if let DisplayVC = segue.destination as? DisplayViewController {
                DisplayVC.currentUser = self.currentUser
                DisplayVC.currentRecipe = self.selectedRecipe
                self.selectedRecipe = nil
                DisplayVC.isRecipeSaved = true
            }
        }
    }
    
    
}
