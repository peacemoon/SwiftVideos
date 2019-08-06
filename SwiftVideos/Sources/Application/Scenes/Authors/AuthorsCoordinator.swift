//
//  Copyright © 2019 An Tran. All rights reserved.
//

import XCoordinator
import SuperArcCoreUI
import SuperArcCore
import RxSwift

class AuthorsCoordinator: NavigationCoordinator<AuthorsRoute> {

    // MARK: Properties

    // Private

    private var viewControllerContext: ViewControllerContext

    // MARK: Initialization

    init(viewControllerContext: ViewControllerContext) {
        self.viewControllerContext = viewControllerContext
        super.init(initialRoute: .authors)
    }

    // MARK: Overrides

    override func prepareTransition(for route: AuthorsRoute) -> NavigationTransition {
        switch route {
        case .authors:
            let viewController = AuthorsCollectionViewController.instantiate(with: viewControllerContext)
            let viewModel = AuthorsCollectionViewModel(router: anyRouter, engine: viewControllerContext.engine)
            viewController.storedViewModel = viewModel
            return .push(viewController)

        case .authorDetail(let authorMetaData):
            let viewController = AuthorDetailViewController.instantiate(with: viewControllerContext)
            let viewModel = AuthorDetailViewModel(authorMetaData: authorMetaData, router: anyRouter, engine: viewControllerContext.engine)
            viewController.storedViewModel = viewModel
            return .push(viewController)

        case .videoDetail(let videoMetaData):
            let videoCoordinator = VideosCoordinator(initialRoute: .videoDetail(videoMetaData, true), viewControllerContext: viewControllerContext)
            return .present(videoCoordinator)

        case .close:
            return .dismissToRoot()
        }
    }

}

enum AuthorsRoute: Route {
    case authors
    case authorDetail(AuthorMetaData)
    case videoDetail(VideoMetaData)
    case close
}
