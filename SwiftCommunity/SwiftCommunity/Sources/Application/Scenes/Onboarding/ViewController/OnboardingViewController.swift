//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcActivityIndicator
import SuperArcCoreUI
import SuperArcCore
import RxSwift

class OnboardingViewController: ViewController<OnboardingViewModel>, StoryboardInitiable {

    // MARK: Properties

    // Static

    static var storyboardName = "Onboarding"

    // Private

    private let disposeBag = DisposeBag()

    // MARK: Setup

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func setupBindings() {
        super.setupBindings()

        viewModel.activity.active
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.activity)
            .disposed(by: disposeBag)

        viewModel.notification
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.notification)
            .disposed(by: disposeBag)

        viewModel.toggleEmptyState
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.toogleStateView)
            .disposed(by: disposeBag)
    }

    override func loadData() {
        viewModel.apis.prepareLocalRepository(shouldResetBeforeCloning: false)
    }

    // MARK: IBActions

    @IBAction func didTapCloneButton(_ sender: Any) {
        viewModel.apis.prepareLocalRepository(shouldResetBeforeCloning: true)
    }
}
