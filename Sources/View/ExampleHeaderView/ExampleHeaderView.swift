//
//  ExampleHeaderView.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleHeaderView: UITableViewHeaderFooterView, TableHeaderFooterView {
    private let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: TableHeaderFooterViewModel) {
        guard let viewModel = viewModel as? ExampleHeaderViewModel else { return }
        titleLabel.text = viewModel.title
    }
    
    private func setup() {
        addSubview(titleLabel)
        titleLabel.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(self, insets: .init(top: 16, left: 16, bottom: 16, right: 16))
        }
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .base3
    }
}
