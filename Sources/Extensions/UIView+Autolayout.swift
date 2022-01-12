//
//  UIView+Autolayout.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

enum LayoutXAxisAnchor {
    case leading
    case trailing
}

enum LayoutYAxisAnchor {
    case top
    case bottom
}

enum LayoutCenterAnchor {
    case xAnchor
    case yAnchor
    case both
}


extension UIView {
    var constraintsSupport: LayoutConstraintsSupport {
        return LayoutConstraintsSupport(view: self)
    }
}

struct LayoutConstraintsSupport {
    private weak var view: UIView?
    
    init(view: UIView?) {
        self.view = view
        self.view?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeConstraints(_ closure: (_ make: LayoutConstraintMaker) -> Void) {
        let maker = LayoutConstraintMaker(view: view)
        closure(maker)
    }
}

struct LayoutConstraintMaker {
    private weak var view: UIView?
    
    init(view: UIView?) {
        self.view = view
    }
    
    func edgesEqualTo(_ view: UIView, insets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) {
        leadingEqualTo(view, offset: insets.left, priority: priority)
        trailingEqualTo(view, offset: -insets.right, priority: priority)
        topEqualTo(view, offset: insets.top, priority: priority)
        bottomEqualTo(view, offset: -insets.bottom, priority: priority)
    }
    
    func leadingEqualTo(_ view: UIView, anchor: LayoutXAxisAnchor = .leading, offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = self.view?.leadingAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset)
        updateConstraintPriorityAndSetActive(constraint, priority: priority)
    }
    
    func trailingEqualTo(_ view: UIView, anchor: LayoutXAxisAnchor = .trailing, offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = self.view?.trailingAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset)
        updateConstraintPriorityAndSetActive(constraint, priority: priority)
    }
    
    func topEqualTo(_ view: UIView, anchor: LayoutYAxisAnchor = .top, offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = self.view?.topAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset)
        updateConstraintPriorityAndSetActive(constraint, priority: priority)
    }
    
    func bottomEqualTo(_ view: UIView, anchor: LayoutYAxisAnchor = .bottom, offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = self.view?.bottomAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset)
        updateConstraintPriorityAndSetActive(constraint, priority: priority)
    }
    
    func centerEqualTo(_ view: UIView, anchor: LayoutCenterAnchor = .both, offset: CGFloat = 0, priority: UILayoutPriority = .required) {
        switch anchor {
        case .xAnchor:
            let constraint = self.view?.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset)
            updateConstraintPriorityAndSetActive(constraint, priority: priority)
        case .yAnchor:
            let constraint = self.view?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset)
            updateConstraintPriorityAndSetActive(constraint, priority: priority)
        case .both:
            let xAnchorConstraint = self.view?.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset)
            let yAnchorConstraint = self.view?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset)
            updateConstraintPriorityAndSetActive(xAnchorConstraint, priority: priority)
            updateConstraintPriorityAndSetActive(yAnchorConstraint, priority: priority)
        }
    }
    
    func widthEqualTo(_ constant: CGFloat, priority: UILayoutPriority = .required) {
        let constraint = self.view?.widthAnchor.constraint(equalToConstant: constant)
        updateConstraintPriorityAndSetActive(constraint, priority: priority)
    }
    
    func heightEqualTo(_ constant: CGFloat, priority: UILayoutPriority = .required) {
        let constraint = self.view?.heightAnchor.constraint(equalToConstant: constant)
        updateConstraintPriorityAndSetActive(constraint, priority: priority)
    }
    
    func sizeEqualTo(_ constant: CGFloat, priority: UILayoutPriority = .required) {
        widthEqualTo(constant, priority: priority)
        heightEqualTo(constant, priority: priority)
    }
    
    func widthEqualToHeight(priority: UILayoutPriority = .required) {
        guard let view = view else { return }
        let constraint = view.widthAnchor.constraint(equalTo: view.heightAnchor)
        updateConstraintPriorityAndSetActive(constraint, priority: priority)
    }
    
    private func updateConstraintPriorityAndSetActive(_ constraint: NSLayoutConstraint?, priority: UILayoutPriority, isActive: Bool = true) {
        constraint?.priority = priority
        constraint?.isActive = isActive
    }
}

extension UIView {
    fileprivate func makeLayoutAnchor(from anchor: LayoutXAxisAnchor) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        switch anchor {
        case .leading:
            return leadingAnchor
        case .trailing:
            return trailingAnchor
        }
    }
    
    fileprivate func makeLayoutAnchor(from anchor: LayoutYAxisAnchor) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        switch anchor {
        case .top:
            return topAnchor
        case .bottom:
            return bottomAnchor
        }
    }
}
