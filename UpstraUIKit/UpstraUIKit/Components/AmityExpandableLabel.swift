//
//  AmityExpandableLabel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 20/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

typealias LineIndexTuple = (line: CTLine, index: Int)

/**
 * The delegate of AmityExpandableLabel.
 */
public protocol AmityExpandableLabelDelegate: AnyObject {
    func willExpandLabel(_ label: AmityExpandableLabel)
    func didExpandLabel(_ label: AmityExpandableLabel)
    func willCollapseLabel(_ label: AmityExpandableLabel)
    func didCollapseLabel(_ label: AmityExpandableLabel)
    func expandableLabeldidTap(_ label: AmityExpandableLabel)
    func didTapOnMention(_ label: AmityExpandableLabel, withUserId userId: String)
}

struct Hyperlink {
    let range: NSRange
    let type: HyperlinkType
}

enum HyperlinkType {
    case url(url: URL)
    case mention(userId: String)
}

/**
 * AmityExpandableLabel
 */
open class AmityExpandableLabel: UILabel {
    
    private let truncateText = "..."
    private var readMoreText = "Read more"
    
    public enum TextReplacementType {
        case character
        case word
    }

    /// The delegate of AmityExpandableLabel
    weak open var delegate: AmityExpandableLabelDelegate?
    
    private var isExpandable: Bool {
        return expandedText != collapsedText
    }

    /// Set 'true' if the label should be expanded or 'false' for collapsed.
    public var isExpanded: Bool = true {
        didSet {
            super.attributedText = (isExpanded) ? self.expandedText : self.collapsedText
            super.numberOfLines = (isExpanded) ? 0 : self.collapsedNumberOfLines
            if let animationView = animationView {
                UIView.animate(withDuration: 0.5) {
                    animationView.layoutIfNeeded()
                }
            }
        }
    }

    /// Set 'true' if the label can be expanded or 'false' if not.
    /// The default value is 'true'.
    @IBInspectable open var shouldExpand: Bool = true

    /// Set 'true' if the label can be collapsed or 'false' if not.
    /// The default value is 'false'.
    @IBInspectable open var shouldCollapse: Bool = false

    /// Set the link name (and attributes) that is shown when collapsed.
    /// The default value is "More". Cannot be nil.
    open var collapsedAttributedLink: NSAttributedString! {
        didSet {
            self.collapsedAttributedLink = collapsedAttributedLink.copyWithAddedFontAttribute(font)
        }
    }
    
    /// Set a color for readmore label
    /// The default value is 'AmityColorSet.highlight'.
    open var readMoreColor: UIColor = AmityColorSet.highlight {
        didSet {
            updateReadMoreAttributes()
        }
    }
    
    // Set a color for hyperLink text in label
    open var hyperLinkColor: UIColor = AmityColorSet.highlight
    
    /// Set a font for readmore label
    /// The default value is 'AmityFontSet.bodyBold'.
    open var readMoreFont: UIFont = AmityFontSet.bodyBold {
        didSet {
            updateReadMoreAttributes()
        }
    }

    /// Set the link name (and attributes) that is shown when expanded.
    /// The default value is "Less". Can be nil.
    open var expandedAttributedLink: NSAttributedString?

    /// Set the ellipsis that appears just after the text and before the link.
    /// The default value is "...". Can be nil.
    open var ellipsis: NSAttributedString?

    /// Set a view to animate changes of the label collapsed state with. If this value is nil, no animation occurs.
    /// Usually you assign the superview of this label or a UIScrollView in which this label sits.
    /// Also don't forget to set the contentMode of this label to top to smoothly reveal the hidden lines.
    /// The default value is 'nil'.
    open var animationView: UIView?

    open var textReplacementType: TextReplacementType = .character

    private var collapsedText: NSAttributedString?
    private var linkHighlighted: Bool = false
    private let touchSize = CGSize(width: 44, height: 44)
    private var linkRect: CGRect?
    private var collapsedNumberOfLines: NSInteger = 0
    private var expandedLinkPosition: NSTextAlignment?
    private var hyperLinks: [Hyperlink] = []
    private var collapsedLinkTextRange: NSRange?
    private var expandedLinkTextRange: NSRange?

    open override var numberOfLines: NSInteger {
        didSet {
            collapsedNumberOfLines = numberOfLines
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public init() {
        super.init(frame: .zero)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        recomputeAttributedText()
    }

    open override var text: String? {
        set(text) {
            if let text = text {
                let attributedString = NSMutableAttributedString(string: text)
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
                var _hyperLinkTextRange: [Hyperlink] = []
                for match in matches {
                    guard let textRange = Range(match.range, in: text) else { continue }
                    let urlString = String(text[textRange])
                    let validUrlString = urlString.hasPrefixIgnoringCase("http") ? urlString : "http://\(urlString)"
                    guard let formattedString = validUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                        let url = URL(string: formattedString) else { continue }
                    attributedString.addAttributes([
                        .foregroundColor: hyperLinkColor,
                        .attachment: url], range: match.range)
                    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
                    _hyperLinkTextRange.append(Hyperlink(range: match.range, type: .url(url: url)))
                }
                hyperLinks = _hyperLinkTextRange
                self.attributedText = attributedString
            } else {
                self.attributedText = nil
            }
        }
        get {
            return self.attributedText?.string
        }
    }

    open private(set) var expandedText: NSAttributedString?
    
    private var originAttributedText: NSAttributedString?
    
    open override var attributedText: NSAttributedString? {
        set {
            originAttributedText = newValue
            recomputeAttributedText()
        }
        get {
            return super.attributedText
        }
    }
    
    private func recomputeAttributedText() {
        if let attributedText = originAttributedText?.copyWithAddedFontAttribute(font).copyWithParagraphAttribute(font),
            attributedText.length > 0 {
            collapsedText = getCollapsedText(for: attributedText, link: (linkHighlighted) ? collapsedAttributedLink.copyWithHighlightedColor() : self.collapsedAttributedLink)
            expandedText = getExpandedText(for: attributedText, link: (linkHighlighted) ? expandedAttributedLink?.copyWithHighlightedColor() : self.expandedAttributedLink)
            super.attributedText = (self.isExpanded) ? self.expandedText : self.collapsedText
        } else {
            expandedText = nil
            collapsedText = nil
            super.attributedText = nil
        }
    }

    open func setLessLinkWith(lessLink: String, attributes: [NSAttributedString.Key: AnyObject], position: NSTextAlignment?) {
        var alignedattributes = attributes
        if let pos = position {
            expandedLinkPosition = pos
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = pos
            alignedattributes[.paragraphStyle] = titleParagraphStyle
        }
        expandedAttributedLink = NSMutableAttributedString(string: lessLink,
                                                           attributes: alignedattributes)
    }
    
    open class func height(for text: String, font: UIFont, boundingWidth: CGFloat, maximumLines: Int) -> CGFloat {
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        let linesCount = attributedString.lines(for: boundingWidth).count
        let actualHeight = attributedString.boundingRect(for: boundingWidth).height
        
        if maximumLines == 0 || linesCount <= maximumLines {
            return ceil(actualHeight)
        } else {
            let oneLineHeight = actualHeight / CGFloat(linesCount)
            return ceil(oneLineHeight * CGFloat(maximumLines))
        }
    }
    
}

// MARK: - Touch Handling

extension AmityExpandableLabel {

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setLinkHighlighted(touches, event: event, highlighted: false)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let isReadMoreTapped: Bool = {
            guard let collapsedLinkTextRange else { return false }
            return check(touch: touch, isInRange: collapsedLinkTextRange) && isExpandable && !isExpanded
        }()
        
        if let hyperLink = hyperLinks.first(where: { check(touch: touch, isInRange: $0.range) }), !isReadMoreTapped {
            switch hyperLink.type {
            case .url(let url):
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case .mention(let userId):
                delegate?.didTapOnMention(self, withUserId: userId)
            }
            
        } else {
            guard isExpandable else {
                delegate?.expandableLabeldidTap(self)
                return
            }
            if isExpanded {
                if shouldCollapse && setLinkHighlighted(touches, event: event, highlighted: false) {
                    delegate?.willCollapseLabel(self)
                    isExpanded = false
                    delegate?.didCollapseLabel(self)
                } else {
                    delegate?.expandableLabeldidTap(self)
                }
            } else {
                if shouldExpand /*&& check(touch: touch, isInRange: range) */ {
                    delegate?.willExpandLabel(self)
                    isExpanded = true
                    delegate?.didExpandLabel(self)
                    linkHighlighted = isHighlighted
                    setNeedsDisplay()
                }
            }
        }
        
    }

}

// MARK: Privates

extension AmityExpandableLabel {
    private func commonInit() {
        isUserInteractionEnabled = true
        lineBreakMode = .byClipping
        collapsedNumberOfLines = numberOfLines
        updateReadMoreAttributes()
    }
    
    private func updateReadMoreAttributes() {
        collapsedAttributedLink = NSAttributedString(string: readMoreText, attributes: [.font: AmityFontSet.bodyBold, .foregroundColor: readMoreColor])
        ellipsis = NSAttributedString(string: truncateText, attributes: [.font: AmityFontSet.bodyBold, .foregroundColor: readMoreColor])
    }

    private func textReplaceWordWithLink(_ lineIndex: LineIndexTuple, text: NSAttributedString, linkName: NSAttributedString) -> NSAttributedString {
        let lineText = text.text(for: lineIndex.line)
        var lineTextWithLink = lineText
        (lineText.string as NSString).enumerateSubstrings(in: NSRange(location: 0, length: lineText.length), options: [.byWords, .reverse]) { (word, subRange, enclosingRange, stop) -> Void in
            let lineTextWithLastWordRemoved = lineText.attributedSubstring(from: NSRange(location: 0, length: subRange.location))
            let lineTextWithAddedLink = NSMutableAttributedString(attributedString: lineTextWithLastWordRemoved)
            if let ellipsis = self.ellipsis {
                lineTextWithAddedLink.append(NSAttributedString(string: " ", attributes: [.font: self.font]))
                lineTextWithAddedLink.append(ellipsis)
            }
            lineTextWithAddedLink.append(linkName)
            let fits = self.textFitsWidth(lineTextWithAddedLink)
            if fits {
                lineTextWithLink = lineTextWithAddedLink
                let lineTextWithLastWordRemovedRect = lineTextWithLastWordRemoved.boundingRect(for: self.frame.size.width)
                let wordRect = linkName.boundingRect(for: self.frame.size.width)
                let width = lineTextWithLastWordRemoved.string == "" ? self.frame.width : wordRect.size.width
                self.linkRect = CGRect(x: lineTextWithLastWordRemovedRect.size.width, y: self.font.lineHeight * CGFloat(lineIndex.index), width: width, height: wordRect.size.height)
                stop.pointee = true
            }
        }
        return lineTextWithLink
    }

    private func textReplaceWithLink(_ lineIndex: LineIndexTuple, text: NSAttributedString, linkName: NSAttributedString) -> NSAttributedString {
        let lineText = text.text(for: lineIndex.line)
        let lineTextTrimmedNewLines = NSMutableAttributedString()
        lineTextTrimmedNewLines.append(lineText)
        let nsString = lineTextTrimmedNewLines.string as NSString
        let range = nsString.rangeOfCharacter(from: CharacterSet.newlines)
        if range.length > 0 {
            lineTextTrimmedNewLines.replaceCharacters(in: range, with: "")
        }
        let linkText = NSMutableAttributedString()
        if let ellipsis = self.ellipsis {
            linkText.append(NSAttributedString(string: " ", attributes: [.font: self.font]))
            linkText.append(ellipsis)
        }
        linkText.append(linkName)

        let lengthDifference = lineTextTrimmedNewLines.string.composedCount - linkText.string.composedCount
        let truncatedString = lineTextTrimmedNewLines.attributedSubstring(
            from: NSMakeRange(0, lengthDifference >= 0 ? lengthDifference : lineTextTrimmedNewLines.string.composedCount))
        let lineTextWithLink = NSMutableAttributedString(attributedString: truncatedString)
        lineTextWithLink.append(linkText)
        return lineTextWithLink
    }

    private func getExpandedText(for text: NSAttributedString?, link: NSAttributedString?) -> NSAttributedString? {
        guard let text = text else { return nil }
        let expandedText = NSMutableAttributedString()
        expandedText.append(text)
        if let link = link, textWillBeTruncated(expandedText) {
            let spaceOrNewLine = expandedLinkPosition == nil ? "  " : "\n"
            expandedText.append(NSAttributedString(string: "\(spaceOrNewLine)"))
            expandedText.append(NSMutableAttributedString(string: "\(link.string)", attributes: link.attributes(at: 0, effectiveRange: nil)).copyWithAddedFontAttribute(font))
            expandedLinkTextRange = NSMakeRange(expandedText.length - link.length, link.length)
        }

        return expandedText
    }

    private func getCollapsedText(for text: NSAttributedString?, link: NSAttributedString) -> NSAttributedString? {
        guard let text = text else { return nil }
        let lines = text.lines(for: preferredMaxLayoutWidth > 0 ? preferredMaxLayoutWidth : frame.size.width)
        if collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count {
            let lastLineRef = lines[collapsedNumberOfLines-1] as CTLine
            var lineIndex: LineIndexTuple?
            var modifiedLastLineText: NSAttributedString?

            if self.textReplacementType == .word {
                lineIndex = findLineWithWords(lastLine: lastLineRef, text: text, lines: lines)
                if let lineIndex = lineIndex {
                    modifiedLastLineText = textReplaceWordWithLink(lineIndex, text: text, linkName: link)
                }
            } else {
                lineIndex = (lastLineRef, collapsedNumberOfLines - 1)
                if let lineIndex = lineIndex {
                    modifiedLastLineText = textReplaceWithLink(lineIndex, text: text, linkName: link)
                }
            }

            if let lineIndex = lineIndex, let modifiedLastLineText = modifiedLastLineText {
                let collapsedLines = NSMutableAttributedString()
                for index in 0..<lineIndex.index {
                    collapsedLines.append(text.text(for:lines[index]))
                }
                collapsedLines.append(modifiedLastLineText)

                collapsedLinkTextRange = NSRange(location: collapsedLines.length - link.length, length: link.length)
                return collapsedLines
            } else {
                return nil
            }
        }
        return text
    }

    private func findLineWithWords(lastLine: CTLine, text: NSAttributedString, lines: [CTLine]) -> LineIndexTuple {
        var lastLineRef = lastLine
        var lastLineIndex = collapsedNumberOfLines - 1
        var lineWords = spiltIntoWords(str: text.text(for: lastLineRef).string as NSString)
        while lineWords.count < 2 && lastLineIndex > 0 {
            lastLineIndex -=  1
            lastLineRef = lines[lastLineIndex] as CTLine
            lineWords = spiltIntoWords(str: text.text(for: lastLineRef).string as NSString)
        }
        return (lastLineRef, lastLineIndex)
    }

    private func spiltIntoWords(str: NSString) -> [String] {
        var strings: [String] = []
        str.enumerateSubstrings(in: NSRange(location: 0, length: str.length), options: [.byWords, .reverse]) { (word, subRange, enclosingRange, stop) -> Void in
            if let unwrappedWord = word {
                strings.append(unwrappedWord)
            }
            if strings.count > 1 { stop.pointee = true }
        }
        return strings
    }

    private func textFitsWidth(_ text: NSAttributedString) -> Bool {
        return (text.boundingRect(for: frame.size.width).size.height <= font.lineHeight) as Bool
    }

    private func textWillBeTruncated(_ text: NSAttributedString) -> Bool {
        let lines = text.lines(for: frame.size.width)
        return collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count
    }
    
    private func check(touch: UITouch, isInRange targetRange: NSRange) -> Bool {
        let touchPoint = touch.location(in: self)
        let index = characterIndex(at: touchPoint)
        
        return NSLocationInRange(index, targetRange)
    }

    @discardableResult private func setLinkHighlighted(_ touches: Set<UITouch>?, event: UIEvent?, highlighted: Bool) -> Bool {
        guard (touches?.first) != nil && collapsedLinkTextRange != nil else {
            return false
        }

        if isExpanded /* &&  check(touch: touch, isInRange: range)*/ {
            linkHighlighted = highlighted
            setNeedsDisplay()
            return true
        }
        return false
    }
}

// MARK: Convenience Methods

extension NSAttributedString {
    func hasFontAttribute() -> Bool {
        guard !self.string.isEmpty else { return false }
        let font = self.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
        return font != nil
    }

    func copyWithParagraphAttribute(_ font: UIFont) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 0.0
        paragraphStyle.minimumLineHeight = font.lineHeight
        paragraphStyle.maximumLineHeight = font.lineHeight

        let copy = NSMutableAttributedString(attributedString: self)
        let range = NSRange(location: 0, length: copy.length)
        copy.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        copy.addAttribute(.baselineOffset, value: font.pointSize * 0.08, range: range)
        return copy
    }

    func copyWithAddedFontAttribute(_ font: UIFont) -> NSAttributedString {
        if !hasFontAttribute() {
            let copy = NSMutableAttributedString(attributedString: self)
            copy.addAttribute(.font, value: font, range: NSRange(location: 0, length: copy.length))
            return copy
        }
        return self.copy() as! NSAttributedString
    }

    func copyWithHighlightedColor() -> NSAttributedString {
        let alphaComponent = CGFloat(0.5)
        let baseColor: UIColor = (self.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor)?.withAlphaComponent(alphaComponent) ??
            UIColor.black.withAlphaComponent(alphaComponent)
        let highlightedCopy = NSMutableAttributedString(attributedString: self)
        let range = NSRange(location: 0, length: highlightedCopy.length)
        highlightedCopy.removeAttribute(.foregroundColor, range: range)
        highlightedCopy.addAttribute(.foregroundColor, value: baseColor, range: range)
        return highlightedCopy
    }

    func lines(for width: CGFloat) -> [CTLine] {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        let frameSetterRef: CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRange(location: 0, length: 0), path.cgPath, nil)

        let linesNS: NSArray  = CTFrameGetLines(frameRef)
        let linesAO: [AnyObject] = linesNS as [AnyObject]
        let lines: [CTLine] = linesAO as! [CTLine]

        return lines
    }

    func text(for lineRef: CTLine) -> NSAttributedString {
        let lineRangeRef: CFRange = CTLineGetStringRange(lineRef)
        let range: NSRange = NSRange(location: lineRangeRef.location, length: lineRangeRef.length)
        return self.attributedSubstring(from: range)
    }

    func boundingRect(for width: CGFloat) -> CGRect {
        return self.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                 options: .usesLineFragmentOrigin, context: nil)
    }
    
}

extension String {
    var composedCount : Int {
        var count = 0
        enumerateSubstrings(in: startIndex..<endIndex, options: .byComposedCharacterSequences) { _,_,_,_  in count += 1 }
        return count
    }
    
    public func hasPrefixIgnoringCase(_ prefix: String) -> Bool {
        let prefixRange = range(of: prefix, options: [.anchored, .caseInsensitive])
        return prefixRange != nil
    }
}

extension UILabel {

    func characterIndex(at touchPoint: CGPoint) -> Int {
        guard let attributedString = attributedText, !attributedString.string.isEmpty else { return NSNotFound }
        
        // Create a text container and layout manager
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        // Set text container attributes
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        
        // Create a text storage and set the label's attributed text
        let textStorage = NSTextStorage(attributedString: attributedString)
        textStorage.addLayoutManager(layoutManager)
        
        // Find the character index at the tap location
        var characterIndex = NSNotFound
        let adjustedTouchPoint: CGPoint
        
        switch textAlignment {
        case .left:
            adjustedTouchPoint = touchPoint
        case .center:
            adjustedTouchPoint = CGPoint(x: touchPoint.x - (bounds.width - textContainer.size.width) / 2.0, y: touchPoint.y)
        case .right:
            adjustedTouchPoint = CGPoint(x: touchPoint.x - (bounds.width - textContainer.size.width), y: touchPoint.y)
        default:
            adjustedTouchPoint = touchPoint
        }
        
        // Iterate through the glyphs to find the correct index
        let glyphIndex = layoutManager.glyphIndex(for: adjustedTouchPoint, in: textContainer)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: textContainer)
        
        if glyphRect.contains(adjustedTouchPoint) {
            characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        }
        
        return characterIndex
    }

    private func flushFactorForTextAlignment(textAlignment: NSTextAlignment) -> CGFloat {
        switch textAlignment {
        case .center:
            return 0.5
        case .right:
            return 1.0
        case .left, .natural, .justified:
            return 0.0
        }
    }
}

extension AmityExpandableLabel {
    func setText(_ text: String, withAttributes attributes: [MentionAttribute]) {
        let attributedString = NSMutableAttributedString(string: text)
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        var _hyperLinkTextRange: [Hyperlink] = []
        for match in matches {
            guard let textRange = Range(match.range, in: text) else { continue }
            let urlString = String(text[textRange])
            let validUrlString = urlString.hasPrefixIgnoringCase("http") ? urlString : "http://\(urlString)"
            guard let formattedString = validUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: formattedString) else { continue }
            attributedString.addAttributes([
                .foregroundColor: hyperLinkColor,
                .attachment: url], range: match.range)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
            _hyperLinkTextRange.append(Hyperlink(range: match.range, type: .url(url: url)))
        }
        
        for attribute in attributes {
            attributedString.addAttributes(attribute.attributes, range: attribute.range)
            _hyperLinkTextRange.append(Hyperlink(range: attribute.range, type: .mention(userId: attribute.userId)))
        }
        
        hyperLinks = _hyperLinkTextRange
        self.attributedText = attributedString
    }
}

struct MentionAttribute {
    let attributes: [NSAttributedString.Key: Any]
    let range: NSRange
    let userId: String
}
