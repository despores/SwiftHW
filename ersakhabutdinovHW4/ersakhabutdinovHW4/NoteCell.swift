//
//  NoteCell.swift
//  ersakhabutdinovHW4
//
//  Created by Эрнест Сахабутдинов on 28.10.2021.
//

import UIKit

class NoteCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
    }
}
