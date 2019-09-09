//
//  Copyright © 2019 An Tran. All rights reserved.
//

public protocol ComponentPresentable {
    var viewController: UIViewController! { get }
}

extension UIViewController: ComponentPresentable {

    public var viewController: UIViewController! {
        return self
    }
}

extension UIWindow: ComponentPresentable {

    public var viewController: UIViewController! {
        return rootViewController!
    }
}
