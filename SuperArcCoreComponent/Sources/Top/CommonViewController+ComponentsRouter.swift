//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcCoreUI

extension CommonViewControllerProtocol {

    public var storedComponentsRouter: ComponentsRouterProtocol {
        return viewControllerContext.resolve(type: ComponentsRouterProtocol.self)
    }
}
