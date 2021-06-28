import UIKit

protocol AmityProfilePagerAwareProtocol: class {
    var pageDelegate: AmityProfileBottomPageDelegate? {get set}
    var currentViewController: UIViewController? {get}
    var pagerTabHeight: CGFloat? {get}
}
