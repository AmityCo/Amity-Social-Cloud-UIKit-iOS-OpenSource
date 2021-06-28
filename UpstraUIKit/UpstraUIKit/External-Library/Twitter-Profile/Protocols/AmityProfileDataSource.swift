import UIKit

protocol AmityProfileDataSource: class {
    func headerViewController() -> UIViewController
    func bottomViewController() -> UIViewController & AmityProfilePagerAwareProtocol
    func minHeaderHeight() -> CGFloat //stop scrolling headerView at this point
}
