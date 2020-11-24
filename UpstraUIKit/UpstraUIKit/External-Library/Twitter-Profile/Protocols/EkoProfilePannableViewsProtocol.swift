import UIKit

protocol EkoProfilePannableViewsProtocol {
    func panView() -> UIView
}

extension EkoProfilePannableViewsProtocol where Self: UIViewController{
    func panView() -> UIView{
        if let scroll = self.view.subviews.first(where: {$0 is UIScrollView}){
            return scroll
        }else{
            return self.view
        }
    }
}

extension UIViewController: EkoProfilePannableViewsProtocol{}
