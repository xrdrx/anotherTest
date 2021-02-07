//
//  PictureTableViewCell.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

import UIKit

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    public var url: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
