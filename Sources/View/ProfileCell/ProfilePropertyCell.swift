//
//  ProfilePropertyCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

typealias ProfilePropertyCell = AnyTableCell<ProfilePropertyCellContentView>

class ProfilePropertyCellContentView: UIView, ConfigurableView {
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    private var onDidLayoutSubviews: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        onDidLayoutSubviews?()
    }
    
    func prepareForReuse() {
        contentView.layer.mask = nil
    }
    
    func configure(with viewModel: ProfilePropertyCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
        updateCorners(viewModel: viewModel)
        
        viewModel.onDidUpdate = { [weak self, weak viewModel] in
            self?.valueLabel.text = viewModel?.value
        }
        
        onDidLayoutSubviews = { [weak self, weak viewModel] in
            guard let viewModel = viewModel else { return }
            self?.updateCorners(viewModel: viewModel)
        }
    }
    
    private func updateCorners(viewModel: ProfilePropertyCellViewModel) {
        guard let rectCorner = viewModel.rectCorner else { return }
        let bezierPath = UIBezierPath(roundedRect: contentView.bounds,
                                      byRoundingCorners: rectCorner,
                                      cornerRadii: CGSize(width: 8, height: 8))
        
        let mask = CAShapeLayer()
        mask.frame = contentView.bounds
        mask.path = bezierPath.cgPath
        contentView.layer.mask = mask
    }
    
    private func setup() {
        setupContentView()
        setupTitleLabel()
        setupValueLabel()
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(self, insets: .init(top: 0, left: 24, bottom: 0, right: 24))
            make.heightEqualTo(44)
        }
        contentView.backgroundColor = .white
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.constraintsSupport.makeConstraints { make in
            make.leadingEqualTo(contentView, offset: 16)
            make.centerEqualTo(contentView, anchor: .yAnchor)
        }
        titleLabel.textColor = .base1
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupValueLabel() {
        contentView.addSubview(valueLabel)
        valueLabel.constraintsSupport.makeConstraints { make in
            make.leadingEqualTo(titleLabel, anchor: .trailing, offset: 8)
            make.trailingEqualTo(contentView, offset: -16)
            make.topEqualTo(contentView)
            make.bottomEqualTo(contentView)
        }
        valueLabel.textColor = .base3
    }
}
