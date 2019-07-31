//
//  Copyright © 2019 An Tran. All rights reserved.
//

import XCoordinator
import SuperArcCoreUI
import SuperArcCore
import Action
import RxSwift
import RxCocoa

protocol VideoDetailViewModelInput {
    var videoMetaData: VideoMetaData { get }
    var showVideoPlayerAction: Action<VideoMetaData, Void> { get }
}

protocol VideoDetailViewModelOutput {
    var videoDetail: BehaviorRelay<VideoDetail?> { get set }
    var previewVideoImage: BehaviorRelay<UIImage?> { get set }
}

public class VideoDetailViewModel: ViewModel, VideoDetailViewModelInput, VideoDetailViewModelOutput {

    // MARK: Properties

    // Public

    public var videoDetail = BehaviorRelay<VideoDetail?>(value: nil)
    public var previewVideoImage = BehaviorRelay<UIImage?>(value: nil)

    public lazy var showVideoPlayerAction = Action<VideoMetaData, Void> { [unowned self] videoMetaData in
        self.router.rx.trigger(.videoPlayer(videoMetaData))
    }

    // Internal

    var videoMetaData: VideoMetaData

    // Private

    private let router: AnyRouter<VideosRoute>

    // MARK: Initialization

    public init(videoMetaData: VideoMetaData, router: AnyRouter<VideosRoute>, engine: Engine) {
        self.videoMetaData = videoMetaData
        self.router = router
        super.init(engine: engine)
    }

    // MARK: APIs

    func loadData() {
        fetchVideoDetail()
        fetchPreviewImage()
    }

    // MARK: Private helpers

    func fetchVideoDetail() {
        videosService.fetchVideo(with: videoMetaData)
            .done { [weak self] videoDetail in
                self?.videoDetail.accept(videoDetail)
            }
            .catch { error in
                print(error)
            }
    }

    func fetchPreviewImage() {
        guard let previewImageURL = videosService.previewImageURL(for: videoMetaData) else {
            return
        }

        guard let previewImage = UIImage(contentsOfFile: previewImageURL.path) else {
            return
        }

        previewVideoImage.accept(previewImage)
    }
}

// MARK: - Dependencies

extension VideoDetailViewModel {

    var videosService: VideosService {
        return engine.serviceRegistry.resolve(type: VideosService.self)
    }
}
