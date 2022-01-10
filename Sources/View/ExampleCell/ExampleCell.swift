//
//  ExampleCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleCell: UIView, TableCell, ReuseIdentifiable {
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    func configure(with viewModel: TableCellViewModel) {
        guard let viewModel = viewModel as? ExampleCellViewModel else { return }
        imageView.image = ImageAsset.image(named: viewModel.image)
        titleLabel.text = viewModel.title
    }
    
    private func setup() {
        setupContentView()
        setupImageView()
        setupTitleLabel()
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(self, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.constraintsSupport.makeConstraints { make in
            make.topEqualTo(contentView, offset: 16)
            make.leadingEqualTo(contentView, offset: 16)
            make.bottomEqualTo(contentView, offset: 16)
            make.widthEqualToHeight()
            make.heightEqualTo(32)
        }
        imageView.tintColor = .base3
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .base1
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.constraintsSupport.makeConstraints { make in
            make.trailingEqualTo(contentView, offset: -16)
            make.leadingEqualTo(imageView, anchor: .trailing, offset: 4)
            make.centerEqualTo(imageView, anchor: .yAnchor)
        }
        titleLabel.font = .systemFont(ofSize: 16, weight: .thin)
        titleLabel.textColor = .base3
    }
}
