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
    public static var iconLike = UIImage(named: "icon_like", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static var iconLikeFill = UIImage(named: "icon_like_fill", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static var iconComment = UIImage(named: "icon_comment", in: UpstraUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconShare = UIImage(named: "icon_share", in: UpstraUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconPhoto = UIImage(named: "icon_photo", in: UpstraUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconAttach = UIImage(named: "icon_attach", in: UpstraUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static let iconOption = UIImage(named: "icon_option", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static var iconCreatePost = UIImage(named: "icon_create_post", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static let iconBadgeCheckmark = UIImage(named: "icon_badge_checkmark", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static let iconBadgeModerator = UIImage(named: "icon_badge_moderator", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static let iconReply = UIImage(named: "icon_reply", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static let iconReplyInverse = UIImage(named: "icon_reply_inverse", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static let iconExpand = UIImage(named: "icon_expand", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static let iconCheckMark =  UIImage(named: "icon_checkmark", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static let iconExclamation =  UIImage(named: "icon_exclamation", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    
    public struct File {
        public static var iconFileAudio = UIImage(named: "icon_file_audio", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileAVI = UIImage(named: "icon_file_avi", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileCSV = UIImage(named: "icon_file_csv", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileDefault = UIImage(named: "icon_file_default", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileDoc = UIImage(named: "icon_file_doc", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileEXE = UIImage(named: "icon_file_exe", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileHTML = UIImage(named: "icon_file_html", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMOV = UIImage(named: "icon_file_mov", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMP3 = UIImage(named: "icon_file_mp3", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMP4 = UIImage(named: "icon_file_mp4", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMPEG = UIImage(named: "icon_file_mpeg", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFilePDF = UIImage(named: "icon_file_pdf", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFilePPT = UIImage(named: "icon_file_ppt", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFilePPX = UIImage(named: "icon_file_ppx", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileRAR = UIImage(named: "icon_file_rar", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileTXT = UIImage(named: "icon_file_txt", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileXLS = UIImage(named: "icon_file_xls", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileIMG = UIImage(named: "icon_file_img", in: UpstraUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileZIP = UIImage(named: "icon_file_zip", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    }
    
    public static var noInternetConnection = UIImage(named: "no_internet_connection", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    public static var emptyChat = getImage(name: "empty_chat")
    public static var iconSendMessage = getImage(name: "icon_send_message")
    public static var defaultPrivateCommunityChat = getImage(name: "default_private_community_chat")
    public static var defaultPublicCommunityChat = getImage(name: "default_public_community_chat")
    public static var defaultAvatar = getImage(name: "default_direct_chat")
    public static var defaultGroupChat = getImage(name: "default_group_chat")
    public static var defaultCategory = UIImage(named: "default_category", in: UpstraUIKitManager.bundle, compatibleWith: nil)
    
    public static var iconSetting = getImage(name: "icon_setting")
    public static var iconDeleteMessage = getImage(name: "icon_delete_message")
    
    // MARK: - Empty Newsfeed
    public static var emptyNewsfeed = getImage("empty_newsfeed")
    static var emptyNoPosts = getImage("empty_no_posts")
    
    static var defaultCommunity = getImage("default_community")
    static var iconCloseWithBackground = getImage("icon_close_with_background")
    static var iconNext = getImage("icon_next")
    static var iconArrowRight = getImage("icon_arrow_right")
    
    static var iconPublic = getImage("icon_public")
    static var iconPrivate = getImage("icon_private")
    static var iconRadioOn = getImage("icon_radio_on")
    static var iconRadioOff = getImage("icon_radio_off")
    static var iconRadioCheck = getImage("icon_radio_check")
    
    static var defaultMessageImage = getImage("default_message_image")
    static var iconMessageFailed = getImage("icon_message_failed")
    
    static var iconAdd = getImage("icon_add")
    static var iconChat = getImage("icon_chat")
    static var iconEdit = getImage("icon_edit")
    static var iconMember = getImage("icon_members")
    
    static let iconCameraFill = getImage("icon_camera_fill")
    static let iconAlbumFill = getImage("icon_album_fill")
    static let iconFileFill = getImage("icon_file_fill")
    static let iconLocationFill = getImage("icon_location_fill")
    
    static let iconMagicWand = getImage("icon_magic_wand")
    
    enum Chat {
        static let iconKeyboard = EkoIconSet.getImage("icon_keyboard")
        static let iconMic = EkoIconSet.getImage("icon_mic")
        static let iconPause = EkoIconSet.getImage("icon_pause")
        static let iconPlay = EkoIconSet.getImage("icon_play")
        static let iconVoiceMessageGrey = EkoIconSet.getImage("icon_voice_message_grey")
        static let iconVoiceMessageWhite = EkoIconSet.getImage("icon_voice_message_white")
        static let iconDelete1 = EkoIconSet.getImage("icon_delete_1")
        static let iconDelete2 = EkoIconSet.getImage("icon_delete_2")
        static let iconDelete3 = EkoIconSet.getImage("icon_delete_3")
    }
    
    enum Post {
        static let like = EkoIconSet.getImage("icon_post_like")
        static let liked = EkoIconSet.getImage("icon_post_liked")
    }
    
    enum CommunitySettings {
        static let iconItemEditProfile = EkoIconSet.getImage("icon_item_edit_profile")
        static let iconItemMembers = EkoIconSet.getImage("icon_item_members")
        static let iconItemNotification = EkoIconSet.getImage("icon_item_notification")
        static let iconItemPostReview = EkoIconSet.getImage("icon_item_post_review")
        static let iconCommentSetting = EkoIconSet.getImage("icon_community_setting_comment")
        static let iconPostSetting = EkoIconSet.getImage("icon_community_setting_post")
    }
    
    enum CommunityNotificationSettings {
        static let iconComments = EkoIconSet.getImage("icon_comments")
        static let iconNewPosts = EkoIconSet.getImage("icon_new_posts")
        static let iconReacts = EkoIconSet.getImage("icon_reacts")
        static let iconReplies = EkoIconSet.getImage("icon_replies")
        static let iconNotificationSettings = EkoIconSet.getImage("icon_notification_settings")
    }
}

private extension EkoIconSet {
    
    static func getImage(_ name: String, bundle: Bundle? = UpstraUIKitManager.bundle) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    static func getImage(name: String, bundle: Bundle? = UpstraUIKitManager.bundle, withRenderingMode renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(renderingMode)
    }
}
