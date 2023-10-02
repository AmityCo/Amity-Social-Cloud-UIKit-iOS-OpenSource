import UIKit

protocol AmityProfileDataSource: AnyObject {
    func headerViewController() -> UIViewController
    func bottomViewController() -> UIViewController & AmityProfilePagerAwareProtocol
    func minHeaderHeight() -> CGFloat //stop scrolling headerView at this point
}
