//
//  TableViewCell.swift
//  News
//
//  Created by Egor Tereshonok on 11/25/19.
//  Copyright © 2019 Egor Tereshonok. All rights reserved.
//

import UIKit
import ExpandableLabel


class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet var expandableLabel: ExpandableLabel!
    override func prepareForReuse() {
        newsImage.image = UIImage(named: "noImg")
           super.prepareForReuse()
           expandableLabel.collapsed = true
           expandableLabel.text = nil
    }
}
