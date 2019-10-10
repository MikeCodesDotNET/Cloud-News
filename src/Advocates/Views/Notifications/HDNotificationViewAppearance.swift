//
//  HDNotificationViewAppearance.swift
//  HDNotificationView
//
//  Created by nhdang103 on 10/5/18.
//  Copyright © 2018 AnG Studio. All rights reserved.
//
//  From: https://github.com/nhdang103/HDNotificationView

import UIKit

public class HDNotificationAppearance: NSObject {
    
    /// Default appearance
    public static let defaultAppearance = HDNotificationAppearance()
    
    // MARK: - NOTIFICATION VIEW
    /// ----------------------------------------------------------------------------------
    /// Margin
    let viewMargin: UIEdgeInsets = {
        if UIDevice.isiPhoneNotch {
            return UIEdgeInsets(top: 34.0, left: 8.0, bottom: 0.0, right: 8.0)
        } else {
            return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 0.0, right: 8.0)
        }
    }()
    func viewMarginTopPreDisplay(notiData: HDNotificationData?) -> CGFloat {
        guard let newNotiData = notiData else {
            return 0.0
        }
        
        let offset = self.viewMargin.top + self.viewSizeHeigth(notiData: newNotiData)
        return -offset
    }
    
    /// Corner
    let viewRoundCornerRadius: CGFloat = 13.0
    
    /// Size
    func viewInitRect(notiData: HDNotificationData?) -> CGRect {
        
        guard let tempNotiData = notiData else {
            return CGRect.zero
        }
        
        return CGRect(
            x: self.viewMargin.left,
            y: self.viewMarginTopPreDisplay(notiData: tempNotiData),
            width: self.viewSizeWidth(),
            height: self.viewSizeHeigth(notiData: tempNotiData))
    }
    
    func viewSizeHeigth(notiData: HDNotificationData?) -> CGFloat {
        
        guard let tempNotiData = notiData else {
            return 0.0
        }
        
        var viewHeight: CGFloat = 0.0
        
        /// Top padding
        viewHeight += self.iconMargin.top
        
        /// Icon height
        viewHeight += self.iconSize.height
        
        /// Icon bot margin
        viewHeight += self.messageMargin.top
        
        /// Message height
        let messageWidth = self.viewSizeWidth() - (self.messageMargin.left + self.messageMargin.right)
        let tempLabel = UILabel()
        tempLabel.attributedText = self.messageAttributedStringFrom(title: tempNotiData.title, message: tempNotiData.message)
        tempLabel.numberOfLines = self.messageTextLineNum
        let messageSize = tempLabel.sizeThatFits(CGSize(width: messageWidth, height: 0.0))
        viewHeight += messageSize.height
        
        /// Message bot margin
        viewHeight += self.messageMargin.bottom
        
        return viewHeight
    }
    func viewSizeWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width - (self.viewMargin.left + self.viewMargin.right)
    }
    
    /// Timing
    public var animationDuration: TimeInterval = 0.4
    var returnPositionAnimationDuration: TimeInterval = 0.2
    public var appearingDuration: TimeInterval = 6.0
    
    // MARK: - VIEW COMPONENTS
    /// ----------------------------------------------------------------------------------
    /// Background
    public enum HDBackgroundType {
        case blurDark
        case blurLight
        case blurExtraLight
        //        case solidColor
        func blurEffectType() -> UIBlurEffect.Style {
            switch self {
            case .blurDark:         return .dark
            case .blurLight:        return .light
            case .blurExtraLight:   return .extraLight
            }
        }
    }
    public var backgroundType: HDBackgroundType = .blurLight
    var backgroundSolidColor: UIColor = UIColor.white
    
    /// Icon
    let iconSize: CGSize = CGSize(width: 20.0, height: 20.0)
    let iconMargin: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 0.0)
    let iconRoundCornerRadius: CGFloat = 4.0
    
    /// Title
    public var titleTextColor: UIColor = UIColor.black
    var titleTextFont: UIFont = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.regular)
    let titleMargin: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 7.0, bottom: 0.0, right: 0.0)
    
    /// Message
    public var messageTextColor: UIColor = UIColor.black
    var messageTextFontSize: CGFloat = 13.0
    public var messageTextLineNum: Int = 3
    let messageMargin: UIEdgeInsets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 11.0, right: 16.0)
    
    /// Time
    var timeTextColor: UIColor = UIColor.black
    var timeTextFont: UIFont = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.regular)
    let timeMargin: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 16.0)
    
    // MARK: - HELPER
    /// ----------------------------------------------------------------------------------
    func messageAttributedStringFrom(title: String?, message: String?) -> NSAttributedString {
        
        var nTitle: String = ""
        if let tempTitle = title {
            nTitle += tempTitle
        }
        
        var nMessage: String = ""
        if let tempMessage = message {
            nMessage += tempMessage
        }
        
        let nNewline: String = "\n"
        
        let paragraphStyle              = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing      = 0.133 * self.messageTextFontSize
        paragraphStyle.lineBreakMode    = .byTruncatingTail
        
        let tempTitleAttributedString = NSAttributedString(
            string: nTitle, attributes: [
                .font: UIFont.systemFont(ofSize: self.messageTextFontSize, weight: .semibold),
                .paragraphStyle: paragraphStyle
            ])
        let tempNewLineAttributedString = NSAttributedString(
            string: nNewline, attributes: [
                .font: UIFont.systemFont(ofSize: self.messageTextFontSize, weight: .semibold),
                .paragraphStyle: paragraphStyle])
        let tempMessageAttributedString = NSAttributedString(
            string: nMessage, attributes: [
                .font: UIFont.systemFont(ofSize: self.messageTextFontSize, weight: .regular),
                .paragraphStyle: paragraphStyle])
        
        /// Final attributed string
        let tempAttributedString = NSMutableAttributedString()
        tempAttributedString.append(tempTitleAttributedString)
        if nTitle.isEmpty == false && nMessage.isEmpty == false {
            tempAttributedString.append(tempNewLineAttributedString)
        }
        tempAttributedString.append(tempMessageAttributedString)
        
        return tempAttributedString
    }
}

/// ----------------------------------------------------------------------------------
// MARK: - UIDEVICE EXTENSION
/// ----------------------------------------------------------------------------------
extension UIDevice {
    
    // MARK: - SCREEN TYPE
    /// ----------------------------------------------------------------------------------
    @nonobjc static let screenSize: CGSize      = UIScreen.main.bounds.size
    @nonobjc static let screenScale: CGFloat    = UIScreen.main.scale
    
    /// 3G, 3GS, 4, 4S
    @nonobjc static let isiPhone35: Bool = screenSize.height == 480.0
    /// 5, 5S, 5C, SE
    @nonobjc static let isiPhone40: Bool = screenSize.height == 568.0
    /// 6, 6S, 7, 8
    @nonobjc static let isiPhone47: Bool = screenSize.height == 667.0
    /// 6+, 6S+, 7+, 8+
    @nonobjc static let isiPhone55: Bool = screenSize.height == 736.0
    /// X, XS
    @nonobjc static let isiPhone58: Bool = screenSize.height == 812.0
    /// XR
    @nonobjc static let isiPhone61: Bool = (screenSize.height == 896.0 && screenScale == 2.0)
    /// XS Max
    @nonobjc static let isiPhone65: Bool = (screenSize.height == 896.0 && screenScale == 3.0)
    
    /// Notch: X, XMax, XR
    @nonobjc static let isiPhoneNotch: Bool = (isiPhone58 || isiPhone61 || isiPhone65)
}
