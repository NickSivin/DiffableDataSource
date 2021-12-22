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
    
    func edgesEqualTo(_ view: UIView, insets: UIEdgeInsets = .zero) {
        leadingEqualTo(view, offset: insets.left)
        trailingEqualTo(view, offset: -insets.right)
        topEqualTo(view, offset: insets.top)
        bottomEqualTo(view, offset: -insets.bottom)
    }
    
    func leadingEqualTo(_ view: UIView, anchor: LayoutXAxisAnchor = .leading, offset: CGFloat = 0) {
        self.view?.leadingAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset).isActive = true
    }
    
    func trailingEqualTo(_ view: UIView, anchor: LayoutXAxisAnchor = .trailing, offset: CGFloat = 0) {
        self.view?.trailingAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset).isActive = true
    }
    
    func topEqualTo(_ view: UIView, anchor: LayoutYAxisAnchor = .top, offset: CGFloat = 0) {
        self.view?.topAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset).isActive = true
    }
    
    func bottomEqualTo(_ view: UIView, anchor: LayoutYAxisAnchor = .bottom, offset: CGFloat = 0) {
        self.view?.bottomAnchor.constraint(equalTo: view.makeLayoutAnchor(from: anchor), constant: offset).isActive = true
    }
    
    func centerEqualTo(_ view: UIView, anchor: LayoutCenterAnchor = .both, offset: CGFloat = 0) {
        switch anchor {
        case .xAnchor:
            self.view?.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset).isActive = true
        case .yAnchor:
            self.view?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
        case .both:
            self.view?.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset).isActive = true
            self.view?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
        }
    }
    
    func widthEqualTo(_ constant: CGFloat) {
        self.view?.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func heightEqualTo(_ constant: CGFloat) {
        self.view?.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func sizeEqualTo(_ constant: CGFloat) {
        widthEqualTo(constant)
        heightEqualTo(constant)
    }
    
    func widthEqualToHeight() {
        guard let view = view else { return }
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
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
