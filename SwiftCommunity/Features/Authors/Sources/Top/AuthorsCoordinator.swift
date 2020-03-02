//
//  Copyright © 2019 An Tran. All rights reserved.
//

import Core
import DataModels
import SuperArcCoreComponent
import SuperArcCoreUI
import SuperArcCore
import XCoordinator
import RxSwift

public class AuthorsCoordinator: NavigationCoordinator<AuthorsRoute> {

    // MARK: Properties

    // Private

    private let navigator: Navigator
    private let component: AuthorsComponent

    // MARK: Initialization

    public init(initialRoute: AuthorsRoute, navigator: Navigator, dependency: AuthorsDependency, router: AnyComponentRouter<AuthorsComponentRoute>, viewControllerContext: ViewControllerContext, dependencyProvider: DependencyProvider) {
        self.navigator = navigator
        component = AuthorsComponent(dependency: dependency,
                                     router: router,
                                     viewControllerContext: viewControllerContext,
                                     dependencyProvider: dependencyProvider)
        super.init(initialRoute: initialRoute)
    }

    // MARK: APIs

    public static func register(to context: ApplicationContextProtocol, navigator: NavigatorProtocol, dependencyProvider: DependencyProvider) {
        AuthorsComponent.register(to: context, navigator: navigator, dependencyProvider: dependencyProvider)
    }

    override public func prepareTransition(for route: AuthorsRoute) -> NavigationTransition {
        switch route {
        case .authors:
            let viewController = component.viewBuilder.makeAuthorsCollectionViewController(router: unownedRouter)
            return .push(viewController)

        case .authorDetail(let authorMetaData, let hasLeftCloseButton):
            let viewController = component.viewBuilder.makeAuthorDetailViewController(authorMetaData: authorMetaData, hasLeftCloseButton: hasLeftCloseButton, router: unownedRouter)
            return .push(viewController)

        case .videoDetail(let videoMetaData):
            let videosComponentPresentable = component.trigger(.video(videoMetaData)) as! ComponentPresentableWrapper
            return .present(videosComponentPresentable.presentable)

        case .close:
            return .dismissToRoot()
        }
    }
}

public enum AuthorsRoute: Route {
    case authors
    case authorDetail(AuthorMetaData, Bool)
    case videoDetail(VideoMetaData)
    case close
}
