//
//  NewsCellTableViewCell.swift
//  NewsApp
//
//  Created by DG on 18/09/2022.
//

import UIKit
import SDWebImage

class NewsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var author: UILabel!

    @IBOutlet weak var newsImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configur(artical : Articale)  {
        self.author.text = "Author :\n" + (artical.author ?? "")
        self.dateLbl.text = "Publish At :\n" + (artical.publishedAt ?? "")
        self.titleLbl.text = artical.title ?? ""
        self.newsImageView.sd_setImage(with: URL(string: artical.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
    }
}
