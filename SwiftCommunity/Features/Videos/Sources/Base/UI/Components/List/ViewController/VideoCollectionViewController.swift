//
//  Copyright © 2019 An Tran. All rights reserved.
//

import CoreUX
import Core
import SuperArcLocalization
import SuperArcCoreUI
import SuperArcCore
import RxSwift
import UIKit

class VideosCollectionViewController: ViewController<VideosCollectionViewModel>, StoryboardInitiable {

    // MARK: Properties

    // Static

    static var storyboardName = "Videos"

    // IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!

    // Private

    private let disposeBag = DisposeBag()

    // MARK: Lifecycles

    override func setupViews() {
        super.setupViews()
        collectionView.delegate = self
        collectionView.registerNib(VideosCollectionViewCell.self)
        titleKey = viewModel.outputs.title
    }

    override func setupBindings() {
        super.setupBindings()

        viewModel.notification
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.notification)
            .disposed(by: disposeBag)

        viewModel.toogleStateView
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.toogleStateView)
            .disposed(by: disposeBag)

        viewModel.outputs.videos
            .bind(to: collectionView.rx.items(cellIdentifier: VideosCollectionViewCell.className)) { _, videoViewModel, cell in
                guard let videoCell = cell as? VideosCollectionViewCell else {
                    fatalError("invalid cell type")
                }
                videoCell.videoView.viewModel = videoViewModel
            }.disposed(by: disposeBag)

        collectionView.rx.modelSelected(VideoViewModel.self)
            .bind(to: viewModel.inputs.didSelectVideoTrigger)
            .disposed(by: disposeBag)
    }

    override func loadData() {
        viewModel.apis.loadData()
    }

    // MARK: Actions

    @objc override func close() {
        viewModel.close()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension VideosCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = screenSize.width - 16*2
        return CGSize(width: cellWidth, height: 310)
    }
}
