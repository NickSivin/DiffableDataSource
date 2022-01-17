//
//  ProfileSwitchCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation
import UIKit

typealias ProfileSwitchCell = AnyTableCell<ProfileSwitchCellContentView>

class ProfileSwitchCellContentView: UIView, ConfigurableView {
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let switchView = UISwitch()
    
    private var onDidLayoutSubviews: (() -> Void)?
    private var onDidChangeSwitchValue: ((Bool) -> Void)?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        onDidLayoutSubviews?()
        switchView.layer.cornerRadius = switchView.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        contentView.layer.mask = nil
    }
    
    func configure(with viewModel: ProfileSwitchCellViewModel) {
        update(viewModel: viewModel)
        
        viewModel.onDidUpdate = { [weak self, weak viewModel] in
            guard let viewModel = viewModel else { return }
            self?.update(viewModel: viewModel)
        }
        
        onDidLayoutSubviews = { [weak self, weak viewModel] in
            guard let viewModel = viewModel else { return }
            self?.updateCorners(viewModel: viewModel)
        }
        
        onDidChangeSwitchValue = { [weak viewModel] isOn in
            viewModel?.changeValue(isOn)
        }
    }
    
    @objc private func didChangeSwitchValue() {
        onDidChangeSwitchValue?(switchView.isOn)
    }
    
    private func update(viewModel: ProfileSwitchCellViewModel) {
        titleLabel.text = viewModel.title
        switchView.setOn(viewModel.isOn, animated: true)
        updateCorners(viewModel: viewModel)
    }
    
    private func updateCorners(viewModel: ProfileSwitchCellViewModel) {
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
        setupSwitchView()
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
    }
    
    private func setupSwitchView() {
        contentView.addSubview(switchView)
        switchView.constraintsSupport.makeConstraints { make in
            make.leadingEqualTo(titleLabel, anchor: .trailing, offset: 8)
            make.trailingEqualTo(contentView, offset: -16)
            make.centerEqualTo(contentView, anchor: .yAnchor)
        }
        switchView.backgroundColor = .base2
        switchView.tintColor = .base2
        switchView.onTintColor = .base3
        switchView.addTarget(self, action: #selector(didChangeSwitchValue), for: .valueChanged)
    }
}
