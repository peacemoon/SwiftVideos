//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcCore

extension Endpoint {
    static var current: Endpoint {
        #if DEBUG
            return .development
        #else
            return .production
        #endif
    }
}
