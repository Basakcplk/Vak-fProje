//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Apple on 26.08.2024.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ) {
    self.title = title
    self.subtitle = subtitle
    self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {  //Haber başlığı için bir etiket (UILabel) oluşturur
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {  //Haber alt başlığı için bir etiket oluşturur
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {   //Haber resmi için bir görüntü alanı (UIImageView) oluşturur
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //Hücrenin başlatıcısı, Alt bileşenleri hücreye ekler
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {     //Alt bileşenlerin yerleşimini ayarlar
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(
            x: 5,
            y: 10,
            width: contentView.frame.size.width - 170,
            height: 70
        )
        
        subtitleLabel.frame = CGRect(
            x: 5,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2
        )
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width-160,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
        
    }

    
    func configure(with viewModel: NewsTableViewCellViewModel) {  
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        
        //Image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data     //görüntüyü tekrar indirmeyecek
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}

