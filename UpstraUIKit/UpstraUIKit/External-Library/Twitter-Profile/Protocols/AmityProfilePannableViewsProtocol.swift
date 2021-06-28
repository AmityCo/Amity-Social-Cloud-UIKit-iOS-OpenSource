import UIKit

protocol AmityProfilePannableViewsProtocol {
    func panView() -> UIView
}

extension AmityProfilePannableViewsProtocol where Self: UIViewController{
    func panView() -> UIView{
        if let scroll = self.view.subviews.first(where: {$0 is UIScrollView}){
            return scroll
        }else{
            return self.view
        }
    }
}

extension UIViewController: AmityProfilePannableViewsProtocol{}
