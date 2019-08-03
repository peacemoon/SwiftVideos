//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcCore
import UIKit

open class TabBarController: UITabBarController, CommonViewControllerProtocol {


    // MARK: Properties

    // Public

    public var context: ViewControllerContext!
    public var storedViewModel: ViewModel!

    @IBInspectable public var hasRightCloseButton = false
    @IBInspectable public var hasLeftCloseButton = false
    @IBInspectable public var prefersLargeTitles = false

    // Private

    // MARK: Initialization

    init(context: ViewControllerContext) {
        super.init(nibName: nil, bundle: nil)
        self.context = context
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Lifecycles

    override open func viewDidLoad() {
        super.viewDidLoad()
        commonViewDidLoad()

        for child in children {
            child.setViewControllerContext(context)
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        commonViewWillAppear()
    }

    @objc open func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: Setup

    open func setupViewModel() -> ViewModel! {
        return nil
    }

    open func setupViews() {}

    open func setupBindings() {}

    open func loadData() {}
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.setViewControllerContext(context)
    }
}
