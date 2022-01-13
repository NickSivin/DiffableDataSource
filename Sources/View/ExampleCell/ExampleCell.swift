//
//  ExampleCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

typealias ExampleCell = AnyTableCell<ExampleCellContent>

class ExampleCellContent: UIView, ConfigurableView, ReuseIdentifiable {
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ExampleCellViewModel) {
        imageView.image = ImageAsset.image(named: viewModel.image)
        titleLabel.text = viewModel.title
    }
    
    private func setup() {
        setupContentView()
        setupTitleLabel()
        setupImageView()
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(self, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        }
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.constraintsSupport.makeConstraints { make in
            make.leadingEqualTo(contentView, offset: 16)
            make.centerEqualTo(contentView, anchor: .yAnchor)
        }
        titleLabel.font = .systemFont(ofSize: 16, weight: .light)
        titleLabel.textColor = .base3
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.constraintsSupport.makeConstraints { make in
            make.leadingEqualTo(titleLabel, anchor: .trailing, offset: 4)
            make.topEqualTo(contentView, offset: 16)
            make.trailingEqualTo(contentView, offset: -16)
            make.bottomEqualTo(contentView, offset: -16)
            make.sizeEqualTo(32)
        }
        imageView.tintColor = .base3
        imageView.contentMode = .scaleAspectFit
    }
}
