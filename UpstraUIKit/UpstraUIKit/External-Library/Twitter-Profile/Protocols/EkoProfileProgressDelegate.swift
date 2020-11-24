import UIKit

protocol EkoProfileProgressDelegate: class{
    func eko_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat)
    func eko_scrollViewDidLoad(_ scrollView: UIScrollView)
}
