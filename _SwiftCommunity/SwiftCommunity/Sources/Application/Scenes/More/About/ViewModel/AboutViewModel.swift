//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcCoreComponent
import SuperArcCoreUI
import SuperArcCore

class AboutViewModel: ViewModel {

    // MARK: Properties

    // Static

    static let readmeFilename = "README.md"

    // MARK: APIs

    func readProjectDescription() -> String? {
        guard let path = Bundle.main.path(forResource: "README", ofType: "md") else {
            return nil
        }

        let url = URL(fileURLWithPath: path)

        return try? String(contentsOf: url, encoding: .utf8)
    }
}
