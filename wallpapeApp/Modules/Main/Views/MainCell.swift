//
//  MainCell.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 29.01.22.
//

import UIKit
import Kingfisher

final class MainCVCell: UICollectionViewCell {
    // MARK: - Nested Types
    private enum Constants {
        static let mainImageCornerRadius: CGFloat = 10
    }
    // MARK: - Properties
    static let identifier = "MainCVCell"
   
    // MARK: - UI Properties
    private lazy var mainImageView : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = Constants.mainImageCornerRadius
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configureCell(url: URL) {
        let processor = DownsamplingImageProcessor(size: mainImageView.bounds.size)
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
    
    // MARK: - Private Methods
    private func configureSubviews() {
        addSubview(mainImageView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalTo: widthAnchor),
            mainImageView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}



