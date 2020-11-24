//
//  EkoIconSet.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

// Note
/// The `EkoIconSet` contains the icons that are used to compose the screen. The following table shows all the elements of the `EkoIconSet`
/// # Note:
/// You should modify the iconSet values in advance if you want to use different icons.
/// # Customize the IconSet
/// ```
/// EkoIconSet.iconChat = {CUSTOM_IMAGE}
/// ```
public struct EkoIconSet {
    
    private init() { }
    
    public static var iconBack = getImage(name: "icon_back")
    public static var iconClose = getImage(name: "icon_close", withRenderingMode: .alwaysTemplate)
    public static var iconMessage = getImage(name: "icon_message")
    public static var iconCreate = getImage(name: "icon_create", withRenderingMode: .alwaysTemplate)
    public static var iconSearch = getImage("icon_search")
    public static var iconCamera = getImage(name: "icon_camera")
    public static let iconCameraSmall = getImage(name: "icon_camera_small")
    public static var iconCommunity = getImage(name: "icon_community")
    public static var iconPrivateSmall = getImage(name: "icon_private_small")
    public static var iconLike = UIImage(named: "icon_like", in: UpstraUIKit.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconComment = UIImage(named: "icon_comment", in: UpstraUIKit.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconShare = UIImage(named: "icon_share", in: UpstraUIKit.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconPhoto = UIImage(named: "icon_photo", in: UpstraUIKit.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconAttach = UIImage(named: "icon_attach", in: UpstraUIKit.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static let iconOption = UIImage(named: "icon_option", in: UpstraUIKit.bundle, compatibleWith: nil)
    public static var iconCreatePost = UIImage(named: "icon_create_post", in: UpstraUIKit.bundle, compatibleWith: nil)
    public static let iconBadgeCheckmark = UIImage(named: "icon_badge_checkmark", in: UpstraUIKit.bundle, compatibleWith: nil)
    public static let iconBadgeModerator = UIImage(named: "icon_badge_moderator", in: UpstraUIKit.bundle, compatibleWith: nil)
    public static let iconReply = UIImage(named: "icon_reply", in: UpstraUIKit.bundle, compatibleWith: nil)
    public static let iconExpand = UIImage(named: "icon_expand", in: UpstraUIKit.bundle, compatibleWith: nil)
    public static let iconCheckMark =  UIImage(named: "icon_checkmark", in: UpstraUIKit.bundle, compatibleWith: nil)
    public static let iconExclamation =  UIImage(named: "icon_exclamation", in: UpstraUIKit.bundle, compatibleWith: nil)
    
    public struct File {
        public static var iconFileAudio = UIImage(named: "icon_file_audio", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileAVI = UIImage(named: "icon_file_avi", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileCSV = UIImage(named: "icon_file_csv", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileDefault = UIImage(named: "icon_file_default", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileDoc = UIImage(named: "icon_file_doc", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileEXE = UIImage(named: "icon_file_exe", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileHTML = UIImage(named: "icon_file_html", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileMOV = UIImage(named: "icon_file_mov", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileMP3 = UIImage(named: "icon_file_mp3", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileMP4 = UIImage(named: "icon_file_mp4", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileMPEG = UIImage(named: "icon_file_mpeg", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFilePDF = UIImage(named: "icon_file_pdf", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFilePPT = UIImage(named: "icon_file_ppt", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFilePPX = UIImage(named: "icon_file_ppx", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileRAR = UIImage(named: "icon_file_rar", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileTXT = UIImage(named: "icon_file_txt", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileXLS = UIImage(named: "icon_file_xls", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileIMG = UIImage(named: "icon_file_img", in: UpstraUIKit.bundle, compatibleWith: nil)
        public static var iconFileZIP = UIImage(named: "icon_file_zip", in: UpstraUIKit.bundle, compatibleWith: nil)
    }
    
    static var sampleChatDirect = getImage(name: "sample_chat_direct")
    static var sampleChatCommunity = getImage(name: "sample_chat_community")
    
    public static var emptyChat = getImage(name: "empty_chat")
    public static var iconSendMessage = getImage(name: "icon_send_message")
    public static var defaultPrivateCommunityChat = getImage(name: "default_private_community_chat")
    public static var defaultPublicCommunityChat = getImage(name: "default_public_community_chat")
    public static var defaultAvatar = getImage(name: "default_direct_chat")
    public static var defaultGroupChat = getImage(name: "default_group_chat")
    public static var defaultCategory = UIImage(named: "default_category", in: UpstraUIKit.bundle, compatibleWith: nil)
    
    public static var iconSetting = getImage(name: "icon_setting")
    public static var iconDeleteMessage = getImage(name: "icon_delete_message")
    
    // MARK: - Empty Newsfeed
    public static var emptyNewsfeed = getImage("empty_newsfeed")
    static var emptyNoPosts = getImage("empty_no_posts")
    
    static var defaultCommunity = getImage("default_community")
    static var iconCloseWithBackground = getImage("icon_close_with_background")
    static var iconArrowRight = getImage("icon_arrow_right")
    static var iconArrowRight1 = getImage("icon_arrow_right_1")
    
    static var iconPublic = getImage("icon_public")
    static var iconPrivate = getImage("icon_private")
    static var iconRadioOn = getImage("icon_radio_on")
    static var iconRadioOff = getImage("icon_radio_off")
    static var iconRadioCheck = getImage("icon_radio_check")
    
    static var defaultMessageImage = getImage("default_message_image")
    static var iconMessageFailed = getImage("icon_message_failed")
    
    static var iconAdd = getImage("icon_add")
    static var iconChat2 = getImage("icon_chat_2")
    static var iconEdit = getImage("icon_edit")
    static var iconMember = getImage("icon_members")
    
    static let iconCameraFill = getImage("icon_camera_fill")
    static let iconAlbumFill = getImage("icon_album_fill")
    static let iconFileFill = getImage("icon_file_fill")
    static let iconLocationFill = getImage("icon_location_fill")
}

private extension EkoIconSet {
    
    static func getImage(_ name: String, bundle: Bundle? = UpstraUIKit.bundle) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    static func getImage(name: String, bundle: Bundle? = UpstraUIKit.bundle, withRenderingMode renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(renderingMode)
    }
}
