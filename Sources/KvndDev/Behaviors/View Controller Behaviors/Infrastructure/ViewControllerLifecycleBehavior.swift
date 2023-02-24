import UIKit

public protocol ViewControllerLifecycleBehavior {
    func afterLoading(viewController: UIViewController)
    func beforeAppearing(viewController: UIViewController)
    func afterAppearing(viewController: UIViewController)
    func beforeDisappearing(viewController: UIViewController)
    func afterDisappearing(viewController: UIViewController)
    func beforeLayingOutSubviews(viewController: UIViewController)
    func afterLayingOutSubviews(viewController: UIViewController)
}

public extension ViewControllerLifecycleBehavior {
    func afterLoading(viewController: UIViewController) { }
    func beforeAppearing(viewController: UIViewController) { }
    func afterAppearing(viewController: UIViewController) { }
    func beforeDisappearing(viewController: UIViewController) { }
    func afterDisappearing(viewController: UIViewController) { }
    func beforeLayingOutSubviews(viewController: UIViewController) { }
    func afterLayingOutSubviews(viewController: UIViewController) { }
}
