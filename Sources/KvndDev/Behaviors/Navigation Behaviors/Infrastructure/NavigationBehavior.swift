import UIKit

public protocol NavigationBehavior {
    func beforePresentation(on viewController: UIViewController)
    func afterPresentation(on viewController: UIViewController)
    func beforeDismissal(on viewController: UIViewController)
    func afterDismissal(on viewController: UIViewController)

    func beforePushing(on navigationController: UINavigationController)
    func afterPushing(on navigationController: UINavigationController)
    func beforePopping(from navigationController: UINavigationController)
    func afterPopping(from navigationController: UINavigationController)
}

public extension NavigationBehavior {
    func beforePresentation(on viewController: UIViewController) { }
    func afterPresentation(on viewController: UIViewController) { }
    func beforeDismissal(on viewController: UIViewController) { }
    func afterDismissal(on viewController: UIViewController) { }

    func beforePushing(on navigationController: UINavigationController) { }
    func afterPushing(on navigationController: UINavigationController) { }
    func beforePopping(from navigationController: UINavigationController) { }
    func afterPopping(from navigationController: UINavigationController) { }
}
