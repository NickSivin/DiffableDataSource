//
//  ProfileHeaderView.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ProfileHeaderView: UIView {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    
    func configure(viewModel: ProfileHeaderViewModel) {
        imageView.image = ImageAsset.image(named: viewModel.image)
        nameLabel.text = viewModel.name
    }
    
    private func setup() {
        addSubview(imageView)
        imageView.constraintsSupport.makeConstraints { make in
            make.topEqualTo(self, offset: 24)
            make.centerEqualTo(self, anchor: .xAnchor)
            make.sizeEqualTo(120)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.base2.cgColor
        
        addSubview(nameLabel)
        nameLabel.constraintsSupport.makeConstraints { make in
            make.topEqualTo(imageView, anchor: .bottom, offset: 8)
            make.centerEqualTo(imageView, anchor: .xAnchor)
            make.bottomEqualTo(self, offset: -24)
        }
        nameLabel.textColor = .base3
        nameLabel.font = .systemFont(ofSize: 18, weight: .light)
    }
}
