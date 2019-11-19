//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcCoreComponent
import SuperArcCoreUI
import SuperArcCore
import XCoordinator
import RxSwift

class MoreCoordinator: NavigationCoordinator<MoreRoute> {

    // MARK: Properties

    // Private

    private var component: MoreComponent

    // MARK: Initialization

    init(dependency: MoreDependency, context: ApplicationContextProtocol) {
        component = MoreComponent(dependency: dependency, viewControllerContext: context.viewControllerContext, context: context)
        super.init(initialRoute: .list)
    }

    // MARK: Overrides

    override func prepareTransition(for route: MoreRoute) -> NavigationTransition {
        switch route {
            case .list:
                let viewController = component.viewBuilder.makeMoreTableViewController(router: unownedRouter)
                return .push(viewController)

            case .about:
                let viewController = component.viewBuilder.makeAboutViewController(router: unownedRouter)
                return .push(viewController)

            case .conferences:
                let viewController = component.viewBuilder.makeOpenConferencesViewController(router: unownedRouter)
                return .push(viewController)

            case .acknowledgements:
                fatalError("should not used")

            case .contentLicense:
                let viewController = component.viewBuilder.makeContentLicensesViewController(router: unownedRouter)
                return .push(viewController)

            case .reset:
                return .dismiss()
        }
    }

}

enum MoreRoute: Route {
    case list
    case conferences
    case about
    case acknowledgements
    case contentLicense
    case reset
}
