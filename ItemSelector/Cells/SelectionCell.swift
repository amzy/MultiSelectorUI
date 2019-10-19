//
//  SelectionCell.swift
//  ItemSelector
//
//  Created by Amzad Khan on 19/10/19.
//  Copyright © 2019 Amzad Khan. All rights reserved.
//

import UIKit

class UserCollectionCell: UICollectionViewCell {
    
    typealias CellTapHandler = (UICollectionViewCell) ->Void
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    var didTapRemove: CellTapHandler?
    @IBAction func didTapRemoveButton(_ sender: Any) {
        didTapRemove?(self)
    }
}

class UserSearchCell : UITableViewCell {
    
    @IBOutlet var selectImage: UIImageView!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    override var isSelected: Bool {
        didSet {
            selectImage.isHidden = !isSelected
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectImage.isHidden = !selected
    }
}

