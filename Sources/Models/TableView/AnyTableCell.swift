//
//  AnyTableCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class AnyTableCell<ContentView: ConfigurableView>: UITableViewCell, TableCell, ConfigurableView where ContentView: UIView {
    typealias ViewModel = ContentView.ViewModel
    private let configurableView: ContentView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        configurableView = ContentView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configurableView.prepareForReuse()
    }
    
    func configure(with viewModel: ViewModel) {
        if let cellViewModel = viewModel as? TableCellViewModel {
            selectionStyle = cellViewModel.selectionStyle
            accessoryType = cellViewModel.accessoryType
        }
        configurableView.configure(with: viewModel)
    }
    
    func configure(with viewModel: TableCellViewModel) {
        selectionStyle = viewModel.selectionStyle
        accessoryType = viewModel.accessoryType
        
        if let containedViewModel = (viewModel as? TableCellContainerViewModel)?.contentViewModel,
           let contentViewModel = containedViewModel as? ContentView.ViewModel {
            configurableView.configure(with: contentViewModel)
            return
        }
        
        guard let viewModel = viewModel as? ContentView.ViewModel else {
            return
        }
        
        configurableView.configure(with: viewModel)
    }
    
    private func setup() {
        tintColor = .base1
        backgroundColor = superview?.backgroundColor ?? .clear
        contentView.backgroundColor = superview?.backgroundColor ?? .clear
        contentView.addSubview(configurableView)
        configurableView.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(contentView, priority: UILayoutPriority(999))
        }
    }
}
