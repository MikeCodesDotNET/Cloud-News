//
//  HDNotificationView.swift
//  HDNotificationView
//
//  Created by nhdang103 on 10/5/18.
//  Copyright © 2018 AnG Studio. All rights reserved.
//
//  From: https://github.com/nhdang103/HDNotificationView

import UIKit
import SnapKit

/// ----------------------------------------------------------------------------------
// MARK: - UTILITY
/// ----------------------------------------------------------------------------------
public extension HDNotificationView {
    
    class func show(data: HDNotificationData?, onTap: (() -> Void)? = nil, onDidDismiss: (() -> Void)? = nil) -> HDNotificationView? {
        
        guard let newData = data else {
            return nil
        }
        
        /// New notification view
        let notiView = HDNotificationView(appearance: HDNotificationAppearance.defaultAppearance, notiData: newData)
        
        notiView.onTabHandleBlock = onTap
        notiView.onDidDismissBlock = onDidDismiss
        
        notiView.notiData = data
        notiView.loadingNotificationData()
        
        notiView.show(onComplete: nil)
        
        return notiView
    }
}

/// ----------------------------------------------------------------------------------
// MARK: - NOTIFICATION VIEW
/// ----------------------------------------------------------------------------------
public class HDNotificationView: UIView {
    
    fileprivate static var _curNotiView: HDNotificationView?
    
    var appearance: HDNotificationAppearance
    var notiData: HDNotificationData?
    
    var constraintMarginTop: NSLayoutConstraint?
    var viewBorderedContainer: UIView!
    var imgIcon: UIImageView!
    var lblTitle: UILabel!
    var lblMessage: UILabel!
    var lblTime: UILabel!
    var imgThumb: UIImageView?
    
    var tapGesture: UITapGestureRecognizer?
    var panGesture: UIPanGestureRecognizer?
    
    var onTabHandleBlock: (() -> Void)?
    var onDidDismissBlock: (() -> Void)?
    
    // MARK: - INIT
    /// ----------------------------------------------------------------------------------
    init(appearance: HDNotificationAppearance, notiData: HDNotificationData?) {
        
        self.appearance = appearance
        self.notiData = notiData
        
        super.init(frame: appearance.viewInitRect(notiData: notiData))
        self._layoutSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.appearance = HDNotificationAppearance.defaultAppearance
        
        super.init(coder: aDecoder)
        self._layoutSubViews()
    }
    
    // MARK: - LAYOUT SUBVIEWS
    /// ----------------------------------------------------------------------------------
    private func _layoutSubViews() {
        
        _layoutBackground()
        _layoutImageIcon()
        _layoutLabelTitle()
        _layoutLabelMessage()
        _layoutLabelTime()
        _layoutImageThumb()
        
        _setUpTapGesture()
        _setUpPanGesture()
    }
    private func _layoutBackground() {
        
        let tempAppearance = self.appearance
        
        /// Bordered view container
        self.viewBorderedContainer = UIView()
        self.viewBorderedContainer.layer.cornerRadius = tempAppearance.viewRoundCornerRadius
        self.viewBorderedContainer.clipsToBounds = true
        
        self.addSubview(self.viewBorderedContainer)
        self.viewBorderedContainer.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        /// Blur view
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: tempAppearance.backgroundType.blurEffectType())
        self.viewBorderedContainer.addSubview(blurView)
        blurView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        /// Shadown
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    private func _layoutImageIcon() {
        
        let tempAppearance = self.appearance
        
        let imgIcon = UIImageView(frame: CGRect(origin: CGPoint.zero, size: tempAppearance.iconSize))
        imgIcon.layer.cornerRadius = tempAppearance.iconRoundCornerRadius
        imgIcon.clipsToBounds = true
        self.imgIcon = imgIcon
        
        self.viewBorderedContainer.addSubview(imgIcon)
        imgIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(tempAppearance.iconMargin.top)
            maker.left.equalTo(tempAppearance.iconMargin.left)
            maker.size.equalTo(tempAppearance.iconSize)
        }
    }
    private func _layoutLabelTitle() {
        
        let tempAppearance = self.appearance
        
        let lblTitle = UILabel()
        lblTitle.textColor = tempAppearance.titleTextColor
        lblTitle.font = tempAppearance.titleTextFont
        self.lblTitle = lblTitle
        
        self.viewBorderedContainer.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.imgIcon.snp.centerY)
            maker.leading.equalTo(self.imgIcon.snp.trailing).offset(tempAppearance.titleMargin.left)
        }
    }
    private func _layoutLabelMessage() {
        
        let tempAppearance = self.appearance
        
        let lblMessage = UILabel()
        lblMessage.textColor = tempAppearance.messageTextColor
        lblMessage.numberOfLines = tempAppearance.messageTextLineNum
        self.lblMessage = lblMessage
        
        self.viewBorderedContainer.addSubview(lblMessage)
        lblMessage.snp.makeConstraints { (maker) in
            maker.leading.equalTo(tempAppearance.messageMargin.left)
            maker.trailing.equalTo(-tempAppearance.messageMargin.right)
            maker.top.equalTo(self.imgIcon.snp.bottom).offset(tempAppearance.messageMargin.top)
            maker.bottom.lessThanOrEqualTo(0.0)
        }
    }
    private func _layoutLabelTime() {
        
        let tempAppearance = self.appearance
        
        let lblTime = UILabel()
        lblTime.textColor = tempAppearance.timeTextColor
        lblTime.font = tempAppearance.timeTextFont
        self.lblTime = lblTime
        
        let layoutPriority = lblTime.contentCompressionResistancePriority(for: .horizontal)
        let newLayoutPriority = UILayoutPriority(layoutPriority.rawValue + 1.0)
        lblTime.setContentCompressionResistancePriority(newLayoutPriority, for: .horizontal)
        
        self.viewBorderedContainer.addSubview(lblTime)
        lblTime.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-tempAppearance.timeMargin.right)
            
            maker.centerY.equalTo(self.lblTitle.snp.centerY)
            maker.leading.greaterThanOrEqualTo(self.lblTitle.snp.trailing).offset(tempAppearance.timeMargin.left)
        }
    }
    private func _layoutImageThumb() {
        
    }
    
    // MARK: - LOADING CONTENT
    /// ----------------------------------------------------------------------------------
    func loadingNotificationData() {
        
        guard let tempNotiData = self.notiData else {
            return
        }
        
        let tempAppearance = self.appearance
        
        /// Icon
        self.imgIcon.image = tempNotiData.iconImage
        
        /// App Title
        self.lblTitle.text = tempNotiData.appTitle
        
        /// Title + Message
        self.lblMessage.attributedText = tempAppearance.messageAttributedStringFrom(title: tempNotiData.title, message: tempNotiData.message)
        
        /// Time
        self.lblTime.text = tempNotiData.time
    }
    
    // MARK: - TAP GESTURE
    /// ----------------------------------------------------------------------------------
    private func _setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(_handleTapGesture(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
    }
    @objc private func _handleTapGesture(gesture: UITapGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            break
            
        case .ended:
            /// Dismiss
            self.dismiss(animated: true, onComplete: nil)
            
            /// Callback
            self.onTabHandleBlock?()
            self.onTabHandleBlock = nil
            
        case .possible, .cancelled, .failed, .changed:
            break
            
        }
    }
    
    // MARK: - PAN GESTURE
    /// ----------------------------------------------------------------------------------
    private func _setUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(_handlePanGesture(gesture:)))
        panGesture.delegate = self
        
        self.addGestureRecognizer(panGesture)
        self.panGesture = panGesture
    }
    @objc private func _handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            self._invalidateTimer()
            
        case .changed:
            guard let tempConstraintMarginTop = self.constraintMarginTop else {
                return
            }
            let translation = gesture.translation(in: self)
            var newConstraintConstant = tempConstraintMarginTop.constant + translation.y
            newConstraintConstant = min(newConstraintConstant, self.appearance.viewMargin.top)
            tempConstraintMarginTop.constant = newConstraintConstant
            
            gesture.setTranslation(CGPoint.zero, in: self)
            
        case .ended:
            /// Dismiss
            if self.frame.minY < -35.0 {
                self.dismiss(animated: true, onComplete: nil)
            }
                
                /// No dimiss
            else {
                self._setUpTimerScheduleToDismiss(halfTime: true)
                self._returnToDisplayPosition(animated: true, onComplete: nil)
            }
            
        case .possible, .cancelled, .failed:
            self._setUpTimerScheduleToDismiss(halfTime: true)
        }
    }
    
    // MARK: - SHOW
    /// ----------------------------------------------------------------------------------
    public func show(onComplete: (() -> Void)?) {
        
        /// Hide current notification view if needed
        if let tempCurNotiView = HDNotificationView._curNotiView {
            tempCurNotiView.dismiss(animated: false, onComplete: nil)
        }
        
        /// Pre-condition
        guard let tempNotiData = self.notiData else {
            return
        }
        guard let tempKeyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let tempAppearance = self.appearance
        
        tempKeyWindow.windowLevel = .statusBar
        
        tempKeyWindow.addSubview(self)
        self.snp.makeConstraints { (maker) in
            maker.leading.equalTo(tempAppearance.viewMargin.left)
            maker.trailing.equalTo(-tempAppearance.viewMargin.right)
            maker.height.equalTo(tempAppearance.viewSizeHeigth(notiData: tempNotiData))
            
            self.constraintMarginTop = maker.top.equalToSuperview().offset(tempAppearance.viewMarginTopPreDisplay(notiData: tempNotiData)).constraint.layoutConstraints.first
        }
        self.layoutIfNeeded()
        
        /// Saving
        HDNotificationView._curNotiView = self
        
        /// Animation
        self.constraintMarginTop?.constant = tempAppearance.viewMargin.top
        UIView.animate(
            withDuration: tempAppearance.animationDuration,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                tempKeyWindow.layoutIfNeeded()
        },
            completion: { (_) in
                
        })
        
        /// Shedule to dismiss
        self._setUpTimerScheduleToDismiss(halfTime: false)
    }
    
    // MARK: - DISMISS
    /// ----------------------------------------------------------------------------------
    public func dismiss(animated: Bool, onComplete: (() -> Void)?) {
        
        self._invalidateTimer()
        
        guard let tempNotiData = self.notiData else {
            return
        }
        guard let tempKeyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let tempAppearance = self.appearance
        
        /// Reset and callback
        func _resetAndCallback() {
            self.removeFromSuperview()
            UIApplication.shared.keyWindow?.windowLevel = .normal
            
            self.onDidDismissBlock?()
            onComplete?()
        }
        
        /// Animate dismiss
        if animated {
            HDNotificationView._curNotiView = nil
            
            self.constraintMarginTop?.constant = tempAppearance.viewMarginTopPreDisplay(notiData: tempNotiData)
            UIView.animate(
                withDuration: tempAppearance.animationDuration,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    tempKeyWindow.layoutIfNeeded()
            },
                completion: { (_) in
                    _resetAndCallback()
            })
        } else {
            HDNotificationView._curNotiView = nil
            _resetAndCallback()
        }
    }
    
    private func _returnToDisplayPosition(animated: Bool, onComplete: (() -> Void)?) {
        
        guard let tempKeyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let tempAppearance = self.appearance
        
        /// Animation
        self.constraintMarginTop?.constant = tempAppearance.viewMargin.top
        if animated {
            UIView.animate(
                withDuration: tempAppearance.returnPositionAnimationDuration,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    tempKeyWindow.layoutIfNeeded()
            },
                completion: { (_) in
                    onComplete?()
            })
        } else {
            onComplete?()
        }
    }
    
    // MARK: - TIMER
    /// ----------------------------------------------------------------------------------
    private var _timer: Timer?
    private func _invalidateTimer() {
        self._timer?.invalidate()
        self._timer = nil
    }
    private func _setUpTimerScheduleToDismiss(halfTime: Bool) {
        self._invalidateTimer()
        
        let tempAppearance = self.appearance
        self._timer = Timer.scheduledTimer(
            timeInterval: !halfTime ? tempAppearance.appearingDuration : tempAppearance.appearingDuration/2.0,
            target: self,
            selector: #selector(_handleTimerSheduleToDismiss),
            userInfo: nil,
            repeats: false)
        
    }
    @objc private func _handleTimerSheduleToDismiss() {
        self.dismiss(animated: true, onComplete: nil)
    }
}

/// ----------------------------------------------------------------------------------
// MARK: - GESTURE DELEGATE
/// ----------------------------------------------------------------------------------
extension HDNotificationView: UIGestureRecognizerDelegate {
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let tempPanGesture = self.panGesture, gestureRecognizer == tempPanGesture else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        
        return tempPanGesture.velocity(in: self).y < 0.0
    }
}
