//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcCoreUI
import SuperArcCore

/// Protocol defining a component.
public protocol ComponentProtocol: Dependency, HasViewControllerContext, ComponentRouter {
    associatedtype DependencyType
    associatedtype ViewBuildableType
    associatedtype InterfaceType

    /// The dependency of this component, which is should be provided by the parent of this component.
    var dependency: DependencyType { get }

    /// Build and initialize view controllers.
    var viewBuilder: ViewBuildableType { get }

    /// Interfaces used by higher layers to access this component.
    var interface: InterfaceType! { get }

    /// Register any objects provided by this component that will be used by classes in the higher layer.
    static func register(to context: ApplicationContextProtocol, navigator: NavigatorProtocol)
}

/// The base class of a dependency injection component containing all dependencies used by this object.
open class Component<DependencyType, ViewBuildableType, InterfaceType, ComponentRouteType: ComponentRoute>: ComponentProtocol {

    // MARK: Properties

    // Public

    public var dependency: DependencyType

    public var viewBuilder: ViewBuildableType {
        return self as! ViewBuildableType
    }

    public var router: AnyComponentRouter<ComponentRouteType>?

    public var interface: InterfaceType!

    public var viewControllerContext: ViewControllerContext!

    public var dependencyProvider: DependencyProvider

    // MARK: Intialization

    public init(dependency: DependencyType,
                router: AnyComponentRouter<ComponentRouteType>? = nil,
                viewControllerContext: ViewControllerContext,
                dependencyProvider: DependencyProvider) {
        self.dependency = dependency
        self.viewControllerContext = viewControllerContext
        self.dependencyProvider = dependencyProvider
        self.router = router
    }

    // MARK: APIs

    open class func register(to context: ApplicationContextProtocol, navigator: NavigatorProtocol) {
        // empty
    }

    open func trigger(_ route: ComponentRouteType) -> ComponentPresentable? {
        return nil
    }
}

extension Component where ComponentRouteType == EmptyComponentRoute {
    public convenience init(dependency: DependencyType, viewControllerContext: ViewControllerContext, dependencyProvider: DependencyProvider) {
        self.init(dependency: dependency,
                  router: AnyEmptyComponentRouter(),
                  viewControllerContext: viewControllerContext,
                  dependencyProvider: dependencyProvider)
    }
}

/// The special empty component.
public final class EmptyComponent: EmptyDependency, EmptyViewBuildable {

    // MARK: Intialization

    public init() {}
}
