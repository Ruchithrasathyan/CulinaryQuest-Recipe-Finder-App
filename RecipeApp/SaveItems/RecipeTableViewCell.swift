//
//  RecipeTableViewCell.swift
//  RecipeApp
//
//  Created by Ruchithra Neu on 12/15/23.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    var wrapperView: UIView!
    var labelRecipe: UILabel!
    var sliderButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setupWrapperView()
        setupLabelRecipe()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperView() {
        wrapperView = UIView()
        wrapperView.backgroundColor = .black
        wrapperView.alpha = 0.4
        wrapperView.layer.cornerRadius = 5.0
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperView)
    }
    
    func setupLabelRecipe() {
        labelRecipe = UILabel()
        labelRecipe.font = UIFont.boldSystemFont(ofSize: 18)
        labelRecipe.textColor = .white
        labelRecipe.numberOfLines = 0
        labelRecipe.lineBreakMode = .byWordWrapping
        labelRecipe.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(labelRecipe)
        
        sliderButton = UIButton()
//        let chevronImage = UIImage(systemName: "slider.horizontal.3")
        let chevronImage = UIImage(systemName: "minus.circle")
        sliderButton.setImage(chevronImage, for: .normal)
        sliderButton.tintColor = UIColor.systemYellow
        sliderButton.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(sliderButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            wrapperView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            wrapperView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            wrapperView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            
            labelRecipe.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 12),
            labelRecipe.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 10),
            labelRecipe.trailingAnchor.constraint(equalTo: sliderButton.trailingAnchor, constant: -10),
            labelRecipe.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -12),
            
            sliderButton.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 12),
            sliderButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -10),
            sliderButton.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -12),
            sliderButton.widthAnchor.constraint(equalToConstant: 30),
            sliderButton.heightAnchor.constraint(equalToConstant: 30),
            
//            wrapperView.heightAnchor.constraint(equalToConstant: 36)
            
        ])
    }

}
