//
//  VideoTableViewCell.swift
//  Alerty
//
//  Created by Viking on 2021. 09. 27..
//

import UIKit

@objc class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @objc var item: [String: Any]? {
        didSet {
            titleLabel.text = item?["title"] as? String
            valueLabel.text = item?["value"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func heightForWidth(_ width: CGFloat, item: [String: Any]?) -> CGFloat {
        let constraintRect = CGSize(width: width - 140, height: .greatestFiniteMagnitude)
        let value = item?["value"] as? String ?? ""
        let rect = value.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 15.0)], context: nil)
        return rect.size.height + 30
    }
}
