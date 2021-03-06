//
//  PaginationCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

typealias PaginationCell = AnyTableCell<PaginationCellContentView>

class PaginationCellContentView: UIView, ConfigurableView {
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: PaginationCellViewModel) {}
    
    func prepareForReuse() {
        activityIndicatorView.startAnimating()
    }
    
    private func setup() {
        addSubview(activityIndicatorView)
        activityIndicatorView.constraintsSupport.makeConstraints { make in
            make.centerEqualTo(self)
        }
        activityIndicatorView.color = .base3
        activityIndicatorView.startAnimating()
    }
}
