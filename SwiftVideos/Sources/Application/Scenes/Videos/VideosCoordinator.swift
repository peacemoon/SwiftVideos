//
//  Copyright © 2019 An Tran. All rights reserved.
//

import XCoordinator
import SuperArcCoreUI
import SuperArcCore
import RxSwift

class VideosCoordinator: NavigationCoordinator<VideosRoute> {

    // MARK: Properties

    // Private

    private var viewControllerContext: ViewControllerContext

    // MARK: Initialization

    init(initialRoute: VideosRoute, viewControllerContext: ViewControllerContext) {
        self.viewControllerContext = viewControllerContext
        super.init(initialRoute: initialRoute)
    }

    // MARK: Overrides

    override func prepareTransition(for route: VideosRoute) -> NavigationTransition {
        switch route {
        case .videos(let conferenceMetaData, let conferenceEdition):
            let viewController = VideosCollectionViewController.instantiate(with: viewControllerContext)
            viewController.setViewControllerContext(viewControllerContext)
            if conferenceMetaData != nil {
                viewController.hasLeftCloseButton = true
            }
            let viewModel = VideosCollectionViewModel(router: anyRouter, engine: viewControllerContext.engine, conferenceMetaData: conferenceMetaData, conferenceEdition: conferenceEdition)
            viewController.storedViewModel = viewModel
            return .push(viewController)

        case .videoDetail(let videoMetaData, let hasLeftCloseButton):
            let viewController = VideoDetailViewController.instantiate(with: viewControllerContext)
            viewController.setViewControllerContext(viewControllerContext)
            let viewModel = VideoDetailViewModel(videoMetaData: videoMetaData, router: anyRouter, engine: viewControllerContext.engine)
            viewController.storedViewModel = viewModel
            viewController.hasLeftCloseButton = hasLeftCloseButton
            return .push(viewController)

        case .videoPlayer(let videoMetaData):
            let viewController = VideoPlayerViewController.instantiate(with: viewControllerContext)
            viewController.setViewControllerContext(viewControllerContext)
            let viewModel = VideoPlayerViewModel(videoMetaData: videoMetaData, engine: viewControllerContext.engine)
            viewController.storedViewModel = viewModel
            return .push(viewController)

        case .close:
            return .dismissToRoot()
        }
    }

}

public enum VideosRoute: Route {
    case videos(ConferenceMetaData?, ConferenceEdition?)
    case videoDetail(VideoMetaData, Bool)
    case videoPlayer(VideoMetaData)
    case close
}
