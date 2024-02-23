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
    
    public static var iconBack = UIImage(named: "icon_back", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconClose = UIImage(named: "icon_close", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconMessage = UIImage(named: "icon_message", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCreate = UIImage(named: "icon_create", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconSearch = UIImage(named: "icon_search", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCamera = UIImage(named: "icon_camera", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCameraSmall = UIImage(named: "icon_camera_small", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCommunity = UIImage(named: "icon_community", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconPrivateSmall = UIImage(named: "icon_private_small", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconLike = UIImage(named: "icon_like", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconLikeFill = UIImage(named: "icon_like_fill", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconComment = UIImage(named: "icon_comment", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconShare = UIImage(named: "icon_share", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconPhoto = UIImage(named: "icon_photo", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconAttach = UIImage(named: "icon_attach", in: AmityUIKitManager.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    public static var iconOption = UIImage(named: "icon_option", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCreatePost = UIImage(named: "icon_create_post", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconBadgeCheckmark = UIImage(named: "icon_badge_checkmark", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconBadgeModerator = UIImage(named: "icon_badge_moderator", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconReply = UIImage(named: "icon_reply", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconReplyInverse = UIImage(named: "icon_reply_inverse", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconExpand = UIImage(named: "icon_expand", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCheckMark =  UIImage(named: "icon_checkmark", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconExclamation =  UIImage(named: "icon_exclamation", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconAdd = UIImage(named: "icon_add", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconChat = UIImage(named: "icon_chat", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconEdit = UIImage(named: "icon_edit", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconMember = UIImage(named: "icon_members", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCameraFill = UIImage(named: "icon_camera_fill", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconAlbumFill = UIImage(named: "icon_album_fill", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconFileFill = UIImage(named: "icon_file_fill", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconLocationFill = UIImage(named: "icon_location_fill", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconMagicWand = UIImage(named: "icon_magic_wand", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconCloseWithBackground = UIImage(named: "icon_close_with_background", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconNext = UIImage(named: "icon_next", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconArrowRight = UIImage(named: "icon_arrow_right", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconPublic = UIImage(named: "icon_public", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconPrivate = UIImage(named: "icon_private", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconRadioOn = UIImage(named: "icon_radio_on", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconRadioOff = UIImage(named: "icon_radio_off", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconRadioCheck = UIImage(named: "icon_radio_check", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconPollOptionAdd = UIImage(named: "icon_poll_option_add", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconDropdown = UIImage(named: "icon_dropdown", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconDownChevron = UIImage(named: "Icon_down_chevron", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconPlayVideo = UIImage(named: "icon_play_video", in: AmityUIKitManager.bundle, compatibleWith: nil)
    
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
    
    public static var emptyReaction = UIImage(named: "empty_reactions", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var noInternetConnection = UIImage(named: "no_internet_connection", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var emptyChat = UIImage(named: "empty_chat", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconSendMessage = UIImage(named: "icon_send_message", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var defaultPrivateCommunityChat = UIImage(named: "default_private_community_chat", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var defaultPublicCommunityChat = UIImage(named: "default_public_community_chat", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var defaultAvatar = UIImage(named: "default_direct_chat", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var defaultGroupChat = UIImage(named: "default_group_chat", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var defaultCategory = UIImage(named: "default_category", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var videoThumbnailPlaceholder = UIImage(named: "video_thumbnail_placeholder", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconSetting = UIImage(named: "icon_setting", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconDeleteMessage = UIImage(named: "icon_delete_message", in: AmityUIKitManager.bundle, compatibleWith: nil)
    
    // MARK: - Empty Newsfeed
    public static var emptyNewsfeed = UIImage(named: "empty_newsfeed", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var emptyNoPosts = UIImage(named: "empty_no_posts", in: AmityUIKitManager.bundle, compatibleWith: nil)
    
    // MARK: - User Feed
    public static var privateUserFeed = UIImage(named: "private_user_feed", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var defaultCommunity = UIImage(named: "default_community", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var defaultCommunityAvatar = UIImage(named: "default_community", in: AmityUIKitManager.bundle, compatibleWith: nil)
    
    // MARK: - Message
    public static var defaultMessageImage = UIImage(named: "default_message_image", in: AmityUIKitManager.bundle, compatibleWith: nil)
    public static var iconMessageFailed = UIImage(named: "icon_message_failed", in: AmityUIKitManager.bundle, compatibleWith: nil)
    
    enum Chat {
        public static var iconKeyboard = UIImage(named: "icon_keyboard", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconMic = UIImage(named: "icon_mic", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconPause = UIImage(named: "icon_pause", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconPlay = UIImage(named: "icon_play", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconVoiceMessageGrey = UIImage(named: "icon_voice_message_grey", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconVoiceMessageWhite = UIImage(named: "icon_voice_message_white", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconDelete1 = UIImage(named: "icon_delete_1", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconDelete2 = UIImage(named: "icon_delete_2", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconDelete3 = UIImage(named: "icon_delete_3", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconSetting = UIImage(named: "icon_chat_setting", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
    
    enum Post {
        public static var like = UIImage(named: "icon_post_like", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var liked = UIImage(named: "icon_post_liked", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var emptyPreviewLinkImage = UIImage(named: "empty_preview_link_image", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var brokenPreviewLinkImage = UIImage(named: "empty_preview_link_broken_image", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
    
    enum CommunitySettings {
        public static var iconItemEditProfile = UIImage(named: "icon_item_edit_profile", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconItemMembers = UIImage(named: "icon_item_members", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconItemNotification = UIImage(named: "icon_item_notification", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconItemPostReview = UIImage(named: "icon_item_post_review", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconCommentSetting = UIImage(named: "icon_community_setting_comment", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconPostSetting = UIImage(named: "icon_community_setting_post", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconCommunitySettingBanned = UIImage(named: "icon_community_setting_banned", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
        
    enum CommunityNotificationSettings {
        public static var iconComments = UIImage(named: "icon_comments", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconNewPosts = UIImage(named: "icon_new_posts", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconReacts = UIImage(named: "icon_reacts", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconReplies = UIImage(named: "icon_replies", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconNotificationSettings = UIImage(named: "icon_notification_settings", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
    
    enum UserSettings {
        public static var iconItemUnfollowUser = UIImage(named: "icon_item_unfollow_user", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconItemReportUser = UIImage(named: "icon_item_report_user", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconItemEditProfile = UIImage(named: "icon_item_edit_profile", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconItemBlockUser = UIImage(named: "icon_item_block_unblock", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
    
    enum Follow {
        public static var iconFollowPendingRequest = UIImage(named: "icon_follow_pending_request", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconUnblockUser = UIImage(named: "icon_user_unblock_button", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
    
    enum CreatePost {
        public static var iconPost = UIImage(named: "icon_post", in: AmityUIKitManager.bundle, compatibleWith: nil)
        public static var iconPoll = UIImage(named: "icon_poll", in: AmityUIKitManager.bundle, compatibleWith: nil)
    }
}
