//
//  ArticleCell.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/30.
//

import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var label: UILabel!
    var article: Article? {
        didSet {
            guard let article = article else { return }
            setup(with: article)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setup(with content: Article) {
        label.text = content.title
    }
    
}
