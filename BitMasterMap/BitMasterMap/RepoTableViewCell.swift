//
//  TableViewCell.swift
//  BitMasterMap
//
//  Created by user167101 on 6/13/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var repoNameLabel: UILabel!
    
    @IBOutlet private weak var starGazingCountLabel: UILabel!
    
    @IBOutlet private weak var openMapButton: UIButton!
    
    @IBAction private func didTapOpeningMap(_ sender: Any) {
        print("butto was clicked")
        closure?()
    }
    
    @IBOutlet private weak var starImageView: UIImageView!
    
//    let button: UIButton = UIButton(type: .custom)
    var closure: (() -> ())?
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
//        self.contentView.addSubview(button)
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        button.setTitle("кнопка!!!!!", for: .normal)
//        button.backgroundColor = .red
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setBackgroundColorForOpenMapButton(color: UIColor) {
        openMapButton.backgroundColor = color
    }
    
    func configureCellWith(repoModel: RepoModel) {
        repoNameLabel.text = repoModel.name
        if let starCount = repoModel.stargazersCount {
            starGazingCountLabel.text = String(starCount.intValue)
        }
    }
}
