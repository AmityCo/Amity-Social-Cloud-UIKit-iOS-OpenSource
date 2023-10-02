import UIKit

protocol AmityProfileBottomPageDelegate: AnyObject {
    func pageViewController(_ currentViewController: UIViewController?, didSelectPageAt index: Int)
}
