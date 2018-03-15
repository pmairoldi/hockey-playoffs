import UIKit

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, _ to: Anchor, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: to, constant: constant)
    }
}

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], constant: constant)
    }
}

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant)
}

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, _ to: Anchor, multiplier: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: to, multiplier: multiplier)
    }
}

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, multiplier: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], multiplier: multiplier)
    }
}

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, multiplier: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return equal(keyPath, keyPath, multiplier: multiplier)
}

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, to constant: CGFloat) -> Constraint  where Anchor: NSLayoutDimension {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

extension UIView {
    func addSubview(_ child: UIView, constraints: [Constraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }
}
