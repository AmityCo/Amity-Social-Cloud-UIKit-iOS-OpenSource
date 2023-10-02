import UIKit

protocol AmityProfilePagerAwareProtocol: AnyObject {
    var pageDelegate: AmityProfileBottomPageDelegate? {get set}
    var currentViewController: UIViewController? {get}
    var pagerTabHeight: CGFloat? {get}
}
