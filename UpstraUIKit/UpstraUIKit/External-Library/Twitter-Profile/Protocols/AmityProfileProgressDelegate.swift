import UIKit

protocol AmityProfileProgressDelegate: AnyObject{
    func scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat)
    func scrollViewDidLoad(_ scrollView: UIScrollView)
}
