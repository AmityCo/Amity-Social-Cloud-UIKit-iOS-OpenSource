import UIKit

protocol AmityProfileBottomPageDelegate: class {
    func pageViewController(_ currentViewController: UIViewController?, didSelectPageAt index: Int)
}
