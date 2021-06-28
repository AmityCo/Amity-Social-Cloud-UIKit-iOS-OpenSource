import UIKit

protocol AmityProfileProgressDelegate: class{
    func scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat)
    func scrollViewDidLoad(_ scrollView: UIScrollView)
}
