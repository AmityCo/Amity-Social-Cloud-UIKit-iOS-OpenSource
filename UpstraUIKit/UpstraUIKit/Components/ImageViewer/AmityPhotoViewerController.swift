//
//  AmityPhotoViewerController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AVKit
import Photos

extension AmityPhotoViewerController {

    @IBAction private func moreButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        let saveButton = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { _ in
            // Save photo to Camera roll
            if let delegate = self.delegate {
                
//                delegate.photoViewerController(self, savePhotoAt: self.currentPhotoIndex)
            }
        }
        alertController.addAction(saveButton)
        present(alertController, animated: true, completion: nil)
    }

    @objc func cancelButtonTapped(_ sender: UIButton) {
        hideInfoOverlayView(false)
        dismiss(animated: true, completion: nil)
    }

    func hideInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: true, animated: animated)
    }

    func showInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: false, animated: animated)
    }

    func configureOverlayViews(hidden: Bool, animated: Bool) {
        if hidden != cancelButton.isHidden {
            let duration: TimeInterval = animated ? 0.2 : 0.0
            let alpha: CGFloat = hidden ? 0.0 : 1.0

            // Always unhide view before animation
            setOverlayElementsHidden(isHidden: false)

            UIView.animate(withDuration: duration, animations: {
                self.setOverlayElementsAlpha(alpha: alpha)
            }, completion: { _ in
                self.setOverlayElementsHidden(isHidden: hidden)
                }
            )
        }
    }

    func setOverlayElementsHidden(isHidden: Bool) {
        topBackgroundView.isHidden = isHidden
        titleLabel.isHidden = isHidden
        cancelButton.isHidden = isHidden
        moreButton.isHidden = isHidden
    }

    func setOverlayElementsAlpha(alpha: CGFloat) {
        topBackgroundView.alpha = alpha
        titleLabel.alpha = alpha
        moreButton.alpha = alpha
        cancelButton.alpha = alpha
    }

    private func bottomButtonsVerticalPosition() -> CGFloat {
        return view.bounds.height - Constant.buttonHeight - Constant.kElementBottomMargin
    }

    // Hide & Show info layer view
    func reverseInfoOverlayViewDisplayStatus() {
        if cancelButton.isHidden == true {
            showInfoOverlayView(true)
        } else {
            hideInfoOverlayView(true)
        }
    }

}


public class AmityPhotoViewerController: UIViewController {
    
    private enum Constant {
        static let topBackgroundViewHeight: CGFloat = 44.0
        static let buttonHorizontalMargin: CGFloat = 20.0
        static let buttonHeight: CGFloat = 40
        static let buttonWidth: CGFloat = 40
        static let kElementBottomMargin: CGFloat = 10.0
    }
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(frame: CGRect.zero)
        cancelButton.setImage(AmityIconSet.iconClose, for: .normal)
        cancelButton.tintColor = AmityColorSet.baseInverse
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        cancelButton.contentHorizontalAlignment = .center
        cancelButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return cancelButton
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton(frame: CGRect.zero)
        moreButton.contentHorizontalAlignment = .right
        moreButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Constant.buttonHorizontalMargin)
        moreButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        return moreButton
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = AmityColorSet.baseInverse
        return label
    }()
    
    lazy var topBackgroundView = UIView(frame: .zero)
    
    /// Scroll direction
    /// Default value is UICollectionViewScrollDirectionVertical
    public var scrollDirection: UICollectionView.ScrollDirection = UICollectionView.ScrollDirection.horizontal {
        didSet {
            // Update collection view flow layout
            (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = scrollDirection
        }
    }
    
    /// Datasource
    /// Providing number of image items to controller and how to confiure image for each image view in it.
    public weak var dataSource: AmityPhotoViewerControllerDataSource?
    
    /// Delegate
    public weak var delegate: AmityPhotoViewerControllerDelegate?
    
    /// Indicates if status bar should be hidden after photo viewer controller is presented.
    /// Default value is true
    open var shouldHideStatusBarOnPresent = true
    
    /// Indicates status bar style when photo viewer controller is being presenting
    /// Default value if UIStatusBarStyle.default
    open var statusBarStyleOnPresenting: UIStatusBarStyle = UIStatusBarStyle.default
    
    /// Indicates status bar animation style when changing hidden status
    /// Default value if UIStatusBarStyle.fade
    open var statusBarAnimationStyle: UIStatusBarAnimation = UIStatusBarAnimation.fade
    
    /// Indicates status bar style after photo viewer controller is being dismissing
    /// Include when pan gesture recognizer is active.
    /// Default value if UIStatusBarStyle.LightContent
    open var statusBarStyleOnDismissing: UIStatusBarStyle = UIStatusBarStyle.lightContent
    
    /// Background color of the viewer.
    /// Default value is black.
    open var backgroundColor: UIColor = UIColor.black {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }
    
    /// Indicates if referencedView should be shown or hidden automatically during presentation and dismissal.
    /// Setting automaticallyUpdateReferencedViewVisibility to false means you need to update isHidden property of this view by yourself.
    /// Setting automaticallyUpdateReferencedViewVisibility will also set referencedView isHidden property to false.
    /// Default value is true
    open var automaticallyUpdateReferencedViewVisibility = true {
        didSet {
            if !automaticallyUpdateReferencedViewVisibility {
                referencedView?.isHidden = false
            }
        }
    }
    
    /// Indicates where image should be scaled smaller when being dragged.
    /// Default value is true.
    open var scaleWhileDragging = true
    
    /// This variable sets original frame of image view to animate from
    open private(set) var referenceSize: CGSize = CGSize.zero
    
    
    /// This is the image view that is mainly used for the presentation and dismissal effect.
    /// How it animates from the original view to fullscreen and vice versa.
    public private(set) var imageView: UIImageView
    
    /// The view where photo viewer originally animates from.
    /// Provide this correctly so that you can have a nice effect.
    public weak internal(set) var referencedView: UIView? {
        didSet {
            // Unhide old referenced view and hide the new one
            oldValue?.isHidden = false
            if automaticallyUpdateReferencedViewVisibility {
                referencedView?.isHidden = true
            }
        }
    }
    
    /// Collection view.
    /// This will be used when displaying multiple images.
    private(set) var collectionView: UICollectionView
    public var scrollView: UIScrollView {
        return collectionView
    }
    
    /// View used for fading effect during presentation and dismissal animation or when controller is being dragged.
    public internal(set) var backgroundView: UIView
    
    /// Pan gesture for dragging controller
    public internal(set) var panGestureRecognizer: UIPanGestureRecognizer!
    
    /// Double tap gesture
    public internal(set) var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    /// Single tap gesture
    public internal(set) var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    private var _shouldHideStatusBar = false
    private var _shouldUseStatusBarStyle = false
    
    /// Transition animator
    /// Customizable if you wish to provide your own transitions.
    open lazy var animator: AmityPhotoViewerBaseAnimator = AmityPhotoAnimator()
    
    public init(referencedView: UIView?, image: UIImage?) {
        let flowLayout = AmityPhotoCollectionViewFlowLayout()
        flowLayout.scrollDirection = scrollDirection
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        // Collection view
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.register(AmityPhotoCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AmityPhotoCollectionViewCell.self))
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        
        backgroundView = UIView(frame: CGRect.zero)
        
        // Image view
        let newImageView = AmityPhotoImageView(frame: CGRect.zero)
        imageView = newImageView
        
        super.init(nibName: nil, bundle: nil)
        
        transitioningDelegate = self
        
        imageView.image = image
        self.referencedView = referencedView
        collectionView.dataSource = self
        
        transitioningDelegate = self
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    public convenience init(referencedView: UIView?, media: AmityMedia) {
        self.init(referencedView: referencedView, image: nil)
        // Normal size
        media.loadImage(to: imageView)
        // Full size
        switch media.state {
        case .downloadableImage(let imageData, _):
            imageView.loadImage(
                with: imageData.fileURL,
                size: .full,
                placeholder: nil,
                optimisticLoad: true
            )
        case .downloadableVideo(_, let thumbnailUrl):
            if let thumbnailUrl = thumbnailUrl {
                imageView.loadImage(
                    with: thumbnailUrl,
                    size: .full,
                    placeholder: AmityIconSet.videoThumbnailPlaceholder,
                    optimisticLoad: true
                )
            } else {
                imageView.image = AmityIconSet.videoThumbnailPlaceholder
            }
        default:
            break
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        if let view = referencedView {
            // Content mode should be identical between image view and reference view
            imageView.contentMode = view.contentMode
        }

        configureOverlayViews(hidden: true, animated: false)
        topBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        //Background view
        view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = backgroundColor
        
        //Image view
        // Configure this block for changing image size when image changed
        (imageView as? AmityPhotoImageView)?.imageChangeBlock = {[weak self](image: UIImage?) -> Void in
            // Update image frame whenever image changes and when the imageView is not being visible
            // imageView is only being visible during presentation or dismissal
            // For that reason, we should not update frame of imageView no matter what.
            if let strongSelf = self, let image = image, strongSelf.imageView.isHidden == true {
                strongSelf.imageView.frame.size = strongSelf.imageViewSizeForImage(image)
                strongSelf.imageView.center = strongSelf.view.center
                
                // No datasource, only 1 item in collection view --> reloadData
                guard let _ = strongSelf.dataSource else {
                    strongSelf.collectionView.reloadData()
                    return
                }
            }
        }
        
        imageView.frame = frameForReferencedView()
        imageView.clipsToBounds = true
        
        //Scroll view
        scrollView.delegate = self
        view.addSubview(imageView)
        view.addSubview(scrollView)
        
        //Tap gesture recognizer
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(_handleTapGesture))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        
        //Pan gesture recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(_handlePanGesture))
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.isUserInteractionEnabled = true
        
        //Double tap gesture recognizer
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(_handleDoubleTapGesture))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)
        
        registerClassPhotoViewer(AmityPhotoCollectionViewCell.self)
        view.addSubview(topBackgroundView)
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(moreButton)
        
        super.viewDidLoad()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView.frame = view.bounds
        scrollView.frame = view.bounds
        
        // Update iamge view frame everytime view changes frame
        (imageView as? AmityPhotoImageView)?.imageChangeBlock?(imageView.image)
        
        let y = bottomButtonsVerticalPosition()
        let insets: UIEdgeInsets = view.safeAreaInsets
        // Layout subviews
        topBackgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: Constant.topBackgroundViewHeight + insets.top)
        titleLabel.frame = CGRect(x: view.bounds.midX - 50, y: insets.top, width: 100, height: Constant.buttonHeight)
        cancelButton.frame = CGRect(origin: CGPoint(x: 10 + insets.left, y: insets.top - 5), size: CGSize(width: Constant.buttonHeight, height: Constant.buttonWidth))
        moreButton.frame = CGRect(origin: CGPoint(x: view.bounds.width - Constant.buttonWidth - insets.right, y: y - insets.bottom), size: CGSize(width: Constant.buttonWidth, height: Constant.buttonHeight))
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update layout
        (collectionView.collectionViewLayout as? AmityPhotoCollectionViewFlowLayout)?.currentIndex = currentPhotoIndex
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Only perform presenting animation logic when really appear, because of presenting.
        guard isBeingPresented else {
            return
        }
        if !animated {
            presentingAnimation()
            presentationAnimationDidFinish()
        } else {
            presentationAnimationWillStart()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Only perform dismiss animation logic when really disappear, because of dismiss.
        guard isBeingDismissed else {
            return
        }
        // Update image view before animation
        updateImageView(scrollView: scrollView)
        if !animated {
            dismissingAnimation()
            dismissalAnimationDidFinish()
        }
        else {
            dismissalAnimationWillStart()
        }
    }
    
    open override var prefersStatusBarHidden : Bool {
        if shouldHideStatusBarOnPresent {
            return _shouldHideStatusBar
        }
        return false
    }
    
    open override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return statusBarAnimationStyle
    }
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if _shouldUseStatusBarStyle {
            return statusBarStyleOnPresenting
        }
        return statusBarStyleOnDismissing
    }
    
    //MARK: Private methods
    private func startAnimation() {
        //Hide reference image view
        if automaticallyUpdateReferencedViewVisibility {
            referencedView?.isHidden = true
        }
        
        //Animate to center
        _animateToCenter()
    }
    
    func _animateToCenter() {
        UIView.animate(withDuration: animator.presentingDuration, animations: {
            self.presentingAnimation()
        }) { (finished) in
            // Presenting animation ended
            self.presentationAnimationDidFinish()
        }
    }
    
    func _hideImageView(_ imageViewHidden: Bool) {
        // Hide image view should show collection view and vice versa
        imageView.isHidden = imageViewHidden
        scrollView.isHidden = !imageViewHidden
    }
    
    func _dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func _handleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        let indexPath = IndexPath(item: currentPhotoIndex, section: 0)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? AmityPhotoCollectionViewCell else {
            assertionFailure("Unhandled cell type")
            return
        }
        
        delegate?.photoViewerControllerDidReceiveTapGesture?(self)
        
        if cell.zoomEnabled {
            reverseInfoOverlayViewDisplayStatus()
        }
        
    }
    
    @objc func _handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        let indexPath = IndexPath(item: currentPhotoIndex, section: 0)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? AmityPhotoCollectionViewCell else {
            assertionFailure("Unhandled cell type")
            return
        }
        
        guard cell.zoomEnabled else {
            // Only perform double tap, if cell.zoomEnabled == true.
            return
        }
        
        didReceiveDoubleTapGesture()
        delegate?.photoViewerControllerDidReceiveDoubleTapGesture?(self)
        
        // Toggle Zoom in/out for double tap
        if (cell.scrollView.zoomScale == cell.scrollView.minimumZoomScale) {
            let location = gesture.location(in: view)
            let center = cell.imageView.convert(location, from: view)
            
            // Zoom in
            cell.minimumZoomScale = 1.0
            let rect = zoomRect(for: cell.imageView, withScale: cell.scrollView.maximumZoomScale, withCenter: center)
            cell.scrollView.zoom(to: rect, animated: true)
        } else {
            // Zoom out
            cell.minimumZoomScale = 1.0
            cell.scrollView.setZoomScale(cell.scrollView.minimumZoomScale, animated: true)
        }
        
    }
    
    private func frameForReferencedView() -> CGRect {
        if let referencedView = referencedView {
            if let superview = referencedView.superview {
                var frame = (superview.convert(referencedView.frame, to: view))
                if abs(frame.size.width - referencedView.frame.size.width) > 1 {
                    // This is workaround for bug in ios 8, everything is double.
                    frame = CGRect(x: frame.origin.x/2, y: frame.origin.y/2, width: frame.size.width/2, height: frame.size.height/2)
                }
                return frame
            }
        }
        
        // Work around when there is no reference view, dragging might behave oddly
        // Should be fixed in the future
        let defaultSize: CGFloat = 1
        return CGRect(x: view.frame.midX - defaultSize/2, y: view.frame.midY - defaultSize/2, width: defaultSize, height: defaultSize)
    }

    private func currentPhotoIndex(for scrollView: UIScrollView) -> Int {
        if scrollDirection == .horizontal {
            if scrollView.frame.width == 0 {
                return 0
            }
            if view.isRightToLeft() {
                return Int(round((scrollView.contentSize.width - scrollView.frame.width - scrollView.contentOffset.x) / scrollView.frame.width))
            } else {
                return Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            }
        }
        else {
            if scrollView.frame.height == 0 {
                return 0
            }
            return Int(scrollView.contentOffset.y / scrollView.frame.height)
        }
    }
    
    // Update zoom inside UICollectionViewCell
    
    private func zoomRect(for imageView: UIImageView, withScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        
        // The zoom rect is in the content view's coordinates.
        // At a zoom scale of 1.0, it would be the size of the
        // imageScrollView's bounds.
        // As the zoom scale decreases, so more content is visible,
        // the size of the rect grows.
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    @objc func _handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if let gestureView = gesture.view {
            switch gesture.state {
            case .began:
                
                // Delegate method
                delegate?.photoViewerController?(self, willBeginPanGestureRecognizer: panGestureRecognizer)
                
                // Update image view when starting to drag
                updateImageView(scrollView: scrollView)
                
                // Make status bar visible when beginning to drag image view
                updateStatusBar(isHidden: false, defaultStatusBarStyle: false)
                
                // Hide collection view & display image view
                _hideImageView(false)
                
                // Method to override
                willBegin(panGestureRecognizer: panGestureRecognizer)
                
            case .changed:
                let translation = gesture.translation(in: gestureView)
                imageView.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
                
                //Change opacity of background view based on vertical distance from center
                let yDistance = CGFloat(abs(imageView.center.y - view.center.y))
                var alpha = 1.0 - yDistance/(gestureView.center.y)
                
                if alpha < 0 {
                    alpha = 0
                }
                
                backgroundView.alpha = alpha
                
                // Scale image
                // Should not go smaller than max ratio
                if let image = imageView.image, scaleWhileDragging {
                    let referenceSize = frameForReferencedView().size
                    
                    // If alpha = 0, then scale is max ratio, if alpha = 1, then scale is 1
                    let scale = alpha
                    
                    // imageView.transform = CGAffineTransformMakeScale(scale, scale)
                    // Do not use transform to scale down image view
                    // Instead change width & height
                    if scale < 1 && scale >= 0 {
                        let maxSize = imageViewSizeForImage(image)
                        let scaleSize = CGSize(width: maxSize.width * scale, height: maxSize.height * scale)
                        
                        if scaleSize.width >= referenceSize.width || scaleSize.height >= referenceSize.height {
                            imageView.frame.size = scaleSize
                        }
                    }
                }
                
            default:
                // Animate back to center
                if backgroundView.alpha < 0.8 {
                    _dismiss()
                }
                else {
                    _animateToCenter()
                }
                
                // Method to override
                didEnd(panGestureRecognizer: panGestureRecognizer)
                
                // Delegate method
                delegate?.photoViewerController?(self, didEndPanGestureRecognizer: panGestureRecognizer)
            }
        }
    }
    
    private func imageViewSizeForImage(_ image: UIImage?) -> CGSize {
        if let image = image {
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: view.bounds)
            return rect.size
        }
        
        return CGSize.zero
    }
    
    func presentingAnimation() {
        // Hide reference view
        if automaticallyUpdateReferencedViewVisibility {
            referencedView?.isHidden = true
        }
        
        // Calculate final frame
        var destinationFrame = CGRect.zero
        destinationFrame.size = imageViewSizeForImage(imageView.image)
        
        // Animate image view to the center
        imageView.frame = destinationFrame
        imageView.center = view.center
        
        // Change status bar to black style
        updateStatusBar(isHidden: true, defaultStatusBarStyle: true)
        
        // Animate background alpha
        backgroundView.alpha = 1.0
    }
    
    private func updateStatusBar(isHidden: Bool, defaultStatusBarStyle isDefaultStyle: Bool) {
        _shouldUseStatusBarStyle = isDefaultStyle
        _shouldHideStatusBar = isHidden
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func dismissingAnimation() {
        imageView.frame = frameForReferencedView()
        backgroundView.alpha = 0
    }
    
    func presentationAnimationDidFinish() {
        // Method to override
        didEndPresentingAnimation()
        
        // Delegate method
        delegate?.photoViewerControllerDidEndPresentingAnimation?(self)
        
        // Hide animating image view and show collection view
        _hideImageView(true)
    }
    
    func presentationAnimationWillStart() {
        // Hide collection view and show image view
        _hideImageView(false)
    }
    
    func dismissalAnimationWillStart() {
        // Hide collection view and show image view
        _hideImageView(false)
    }
    
    func dismissalAnimationDidFinish() {
        if automaticallyUpdateReferencedViewVisibility {
            referencedView?.isHidden = false
        }
    }

    //MARK: Public behavior methods
    open func didScrollToPhoto(at index: Int) {
        
    }
    
    open func didZoomOnPhoto(at index: Int, atScale scale: CGFloat) {
        
    }
    
    open func didEndZoomingOnPhoto(at index: Int, atScale scale: CGFloat) {
        if scale == 1 {
            showInfoOverlayView(true)
        }
    }
    
    open func willZoomOnPhoto(at index: Int) {
         hideInfoOverlayView(false)
    }
    
    open func didReceiveDoubleTapGesture() {
        hideInfoOverlayView(false)
    }
    
    open func willBegin(panGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        hideInfoOverlayView(false)
    }
    
    open func didEnd(panGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    open func didEndPresentingAnimation() {
        showInfoOverlayView(true)
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension AmityPhotoViewerController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}

//MARK: UICollectionViewDataSource
extension AmityPhotoViewerController: UICollectionViewDataSource {
    
    //MARK: Public methods
    public var currentPhotoIndex: Int {
        return currentPhotoIndex(for: scrollView)
    }
    
    public var zoomScale: CGFloat {
        let index = currentPhotoIndex
        let indexPath = IndexPath(item: index, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AmityPhotoCollectionViewCell {
            return cell.scrollView.zoomScale
        }
        
        return 1.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.numberOfItems(in: self)
        }
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AmityPhotoCollectionViewCell.self), for: indexPath) as! AmityPhotoCollectionViewCell
        cell.delegate = self
        
        if let dataSource = dataSource {
            if dataSource.numberOfItems(in: self) > 0 {
                dataSource.photoViewerController(self, configurePhotoAt: indexPath.row, withImageView: cell.imageView)
                dataSource.photoViewerController?(self, configureCell: cell, forPhotoAt: indexPath.row)
                
                return cell
            }
        }
        
        cell.imageView.image = imageView.image
        return cell
    }
}

//MARK: Open methods
extension AmityPhotoViewerController {
    
    // For each reuse identifier that the collection view will use, register either a class or a nib from which to instantiate a cell.
    // If a nib is registered, it must contain exactly 1 top level object which is a AmityPhotoCollectionViewCell.
    // If a class is registered, it will be instantiated via alloc/initWithFrame:
    public func registerClassPhotoViewer(_ cellClass: Swift.AnyClass?) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(AmityPhotoCollectionViewCell.self))
    }
    
    public func registerNibForPhotoViewer(_ nib: UINib?) {
        collectionView.register(nib, forCellWithReuseIdentifier: NSStringFromClass(AmityPhotoCollectionViewCell.self))
    }
    
    // Update data before calling theses methods
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public func insertPhotos(at indexes: [Int], completion: ((Bool) -> Void)?) {
        let indexPaths = indexPathsForIndexes(indexes: indexes)
        
        collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: indexPaths)
        }, completion: completion)
    }
    
    public func deletePhotos(at indexes: [Int], completion: ((Bool) -> Void)?) {
        let indexPaths = indexPathsForIndexes(indexes: indexes)
        
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: indexPaths)
        }, completion: completion)
    }
    
    public func reloadPhotos(at indexes: [Int]) {
        let indexPaths = indexPathsForIndexes(indexes: indexes)
        
        collectionView.reloadItems(at: indexPaths)
    }
    
    public func movePhoto(at index: Int, to newIndex: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let newIndexPath = IndexPath(item: newIndex, section: 0)
        
        collectionView.moveItem(at: indexPath, to: newIndexPath)
    }
    
    public func scrollToPhoto(at index: Int, animated: Bool) {
        if collectionView.numberOfItems(inSection: 0) > index {
            let indexPath = IndexPath(item: index, section: 0)
            
            let position: UICollectionView.ScrollPosition
            
            if scrollDirection == .vertical {
                position = .bottom
            }
            else {
                position = .right
            }
            
            collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
            
            if !animated {
                // Need to call these methods since scrollView delegate method won't be called when not animated
                // Method to override
                didScrollToPhoto(at: index)
                
                // Call delegate
                delegate?.photoViewerController?(self, didScrollToPhotoAt: index)
            }
        }
    }
    
    // Helper for indexpaths
    func indexPathsForIndexes(indexes: [Int]) -> [IndexPath] {
        return indexes.map() {
            IndexPath(item: $0, section: 0)
        }
    }
    
}

//MARK: AmityPhotoCollectionViewCellDelegate
extension AmityPhotoViewerController: AmityPhotoCollectionViewCellDelegate {
    
    public func collectionViewCellDidZoomOnPhoto(_ cell: AmityPhotoCollectionViewCell, atScale scale: CGFloat) {
        if let indexPath = collectionView.indexPath(for: cell) {
            // Method to override
            didZoomOnPhoto(at: indexPath.row, atScale: scale)
            
            // Call delegate
            delegate?.photoViewerController?(self, didZoomOnPhotoAtIndex: indexPath.row, atScale: scale)
        }
    }
    
    public func collectionViewCellDidEndZoomingOnPhoto(_ cell: AmityPhotoCollectionViewCell, atScale scale: CGFloat) {
        if let indexPath = collectionView.indexPath(for: cell) {
            // Method to override
            didEndZoomingOnPhoto(at: indexPath.row, atScale: scale)
            
            // Call delegate
            delegate?.photoViewerController?(self, didEndZoomingOnPhotoAtIndex: indexPath.row, atScale: scale)
        }
    }
    
    public func collectionViewCellWillZoomOnPhoto(_ cell: AmityPhotoCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            // Method to override
            willZoomOnPhoto(at: indexPath.row)
            
            // Call delegate
            delegate?.photoViewerController?(self, willZoomOnPhotoAtIndex: indexPath.row)
        }
    }
    
}
