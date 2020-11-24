import UIKit

protocol EkoProfileDataSource: class {
    func headerViewController() -> UIViewController
    func bottomViewController() -> UIViewController & EkoProfilePagerAwareProtocol
    func minHeaderHeight() -> CGFloat //stop scrolling headerView at this point
}
