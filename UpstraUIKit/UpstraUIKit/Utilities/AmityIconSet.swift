//
//  AmityIconSet.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

// Note
// See more: https://docs.sendbird.com/ios/ui_kit_common_components#3_iconset
/// The `AmityIconSet` contains the icons that are used to compose the screen. The following table shows all the elements of the `AmityIconSet`
/// # Note:
/// You should modify the iconSet values in advance if you want to use different icons.
/// # Customize the IconSet
/// ```
/// AmityIconSet.iconChat = {CUSTOM_IMAGE}
/// ```
public struct AmityIconSet {
    
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
    public static var iconLike = UIImage(named: "icon_like", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconLikeFill = UIImage(named: "icon_like_fill", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconComment = UIImage(named: "icon_comment", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconShare = UIImage(named: "icon_share", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconPhoto = UIImage(named: "icon_photo", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconAttach = UIImage(named: "icon_attach", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static let iconOption = UIImage(named: "icon_option", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCreatePost = UIImage(named: "icon_create_post", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static let iconBadgeCheckmark = UIImage(named: "icon_badge_checkmark", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static let iconBadgeModerator = UIImage(named: "icon_badge_moderator", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static let iconReply = UIImage(named: "icon_reply", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static let iconReplyInverse = UIImage(named: "icon_reply_inverse", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static let iconExpand = UIImage(named: "icon_expand", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static let iconCheckMark =  UIImage(named: "icon_checkmark", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static let iconExclamation =  UIImage(named: "icon_exclamation", in: AmityUIKitManager.bundle, compatibleWith: nil)
    
    public struct File {
        public static var iconFileAudio = UIImage(named: "icon_file_audio", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileAVI = UIImage(named: "icon_file_avi", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileCSV = UIImage(named: "icon_file_csv", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileDefault = UIImage(named: "icon_file_default", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileDoc = UIImage(named: "icon_file_doc", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileEXE = UIImage(named: "icon_file_exe", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileHTML = UIImage(named: "icon_file_html", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMOV = UIImage(named: "icon_file_mov", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMP3 = UIImage(named: "icon_file_mp3", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMP4 = UIImage(named: "icon_file_mp4", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileMPEG = UIImage(named: "icon_file_mpeg", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFilePDF = UIImage(named: "icon_file_pdf", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFilePPT = UIImage(named: "icon_file_ppt", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFilePPX = UIImage(named: "icon_file_ppx", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileRAR = UIImage(named: "icon_file_rar", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileTXT = UIImage(named: "icon_file_txt", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileXLS = UIImage(named: "icon_file_xls", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileIMG = UIImage(named: "icon_file_img", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconFileZIP = UIImage(named: "icon_file_zip", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
    
    public static var noInternetConnection = UIImage(named: "no_internet_connection", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var emptyChat = getImage(name: "empty_chat")
    public static var iconSendMessage = getImage(name: "icon_send_message")
    public static var defaultPrivateCommunityChat = getImage(name: "default_private_community_chat")
    public static var defaultPublicCommunityChat = getImage(name: "default_public_community_chat")
    public static var defaultAvatar = getImage(name: "default_direct_chat")
    public static var defaultGroupChat = getImage(name: "default_group_chat")
    public static var defaultCategory = UIImage(named: "default_category", in: AmityUIKitManager.bundle, compatibleWith: nil)
    
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
        static let iconKeyboard = AmityIconSet.getImage("icon_keyboard")
        static let iconMic = AmityIconSet.getImage("icon_mic")
        static let iconPause = AmityIconSet.getImage("icon_pause")
        static let iconPlay = AmityIconSet.getImage("icon_play")
        static let iconVoiceMessageGrey = AmityIconSet.getImage("icon_voice_message_grey")
        static let iconVoiceMessageWhite = AmityIconSet.getImage("icon_voice_message_white")
        static let iconDelete1 = AmityIconSet.getImage("icon_delete_1")
        static let iconDelete2 = AmityIconSet.getImage("icon_delete_2")
        static let iconDelete3 = AmityIconSet.getImage("icon_delete_3")
    }
    
    enum Post {
        static let like = AmityIconSet.getImage("icon_post_like")
        static let liked = AmityIconSet.getImage("icon_post_liked")
    }
    
    enum CommunitySettings {
        static let iconItemEditProfile = AmityIconSet.getImage("icon_item_edit_profile")
        static let iconItemMembers = AmityIconSet.getImage("icon_item_members")
        static let iconItemNotification = AmityIconSet.getImage("icon_item_notification")
        static let iconItemPostReview = AmityIconSet.getImage("icon_item_post_review")
        static let iconCommentSetting = AmityIconSet.getImage("icon_community_setting_comment")
        static let iconPostSetting = AmityIconSet.getImage("icon_community_setting_post")
    }
    
    enum CommunityNotificationSettings {
        static let iconComments = AmityIconSet.getImage("icon_comments")
        static let iconNewPosts = AmityIconSet.getImage("icon_new_posts")
        static let iconReacts = AmityIconSet.getImage("icon_reacts")
        static let iconReplies = AmityIconSet.getImage("icon_replies")
        static let iconNotificationSettings = AmityIconSet.getImage("icon_notification_settings")
    }
}

private extension AmityIconSet {
    
    static func getImage(_ name: String, bundle: Bundle? = AmityUIKitManager.bundle) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    static func getImage(name: String, bundle: Bundle? = AmityUIKitManager.bundle, withRenderingMode renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(renderingMode)
    }
}
