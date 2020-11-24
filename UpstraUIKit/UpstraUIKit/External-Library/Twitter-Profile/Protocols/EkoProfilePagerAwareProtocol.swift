import UIKit

protocol EkoProfilePagerAwareProtocol: class {
    var pageDelegate: EkoProfileBottomPageDelegate? {get set}
    var currentViewController: UIViewController? {get}
    var pagerTabHeight: CGFloat? {get}
}
