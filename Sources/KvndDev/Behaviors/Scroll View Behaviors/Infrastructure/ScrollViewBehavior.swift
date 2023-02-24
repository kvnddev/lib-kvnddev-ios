import UIKit

public protocol ScrollViewBehavior {
    func afterScrolling(_ scrollView: UIScrollView)
    func beforeDraggingBegins(_ scrollView: UIScrollView)
    func beforeDraggingEnds(_ scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    func afterDraggingEnds(_ scrollView: UIScrollView, wilDecelerate: Bool)
    func afterScrollingToTop(_ scrollView: UIScrollView)
    func beforeDeceleratingBegins(_ scrollView: UIScrollView)
    func afterDeceleratingEnds(_ scrollView: UIScrollView)
    func beforeZoomingBegins(_ scrollView: UIScrollView, view: UIView?)
    func afterZoomingEnds(_ scrollView: UIScrollView, view: UIView?, scale: CGFloat)
    func afterZooming(_ scrollView: UIScrollView)
    func afterScrollingAnimation(_ scrollView: UIScrollView)
    func afterChangingAdjustedContentInset(_ scrollView: UIScrollView)
}

public extension ScrollViewBehavior {
    func afterScrolling(_ scrollView: UIScrollView) {}
    func beforeDraggingBegins(_ scrollView: UIScrollView) {}
    func beforeDraggingEnds(_ scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
    func afterDraggingEnds(_ scrollView: UIScrollView, wilDecelerate: Bool) {}
    func afterScrollingToTop(_ scrollView: UIScrollView) {}
    func beforeDeceleratingBegins(_ scrollView: UIScrollView) {}
    func afterDeceleratingEnds(_ scrollView: UIScrollView) {}
    func beforeZoomingBegins(_ scrollView: UIScrollView, view: UIView?) {}
    func afterZoomingEnds(_ scrollView: UIScrollView, view: UIView?, scale: CGFloat) {}
    func afterZooming(_ scrollView: UIScrollView) {}
    func afterScrollingAnimation(_ scrollView: UIScrollView) {}
    func afterChangingAdjustedContentInset(_ scrollView: UIScrollView) {}
}
