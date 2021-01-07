//
//  EkoLocalizedStringSet.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

// Note
/// The `EkoLocalizedStringSet` contains the common strings that are used to compose the screen. The following table shows all the elements of the `EkoLocalizedStringSet`
/// # Note:
/// You should modify the stringSet values in advance if you want to make changes to the screen
/// # Customize the StringSet
/// ```
/// EkoLocalizedStringSet.OK = {CUSTOM_STRING}
/// ```
public struct EkoLocalizedStringSet {
    private init() { }
    
    static var members = EkoLocalizable.localizedString(forKey: "members")
    static var follow = EkoLocalizable.localizedString(forKey: "follow")
    static var chatTitle = EkoLocalizable.localizedString(forKey: "chat_title")
    static var recentTitle = EkoLocalizable.localizedString(forKey: "recent_title")
    static var directoryTitle = EkoLocalizable.localizedString(forKey: "directory_title")
    static var emptyChatList = EkoLocalizable.localizedString(forKey: "empty_chat_list")
    static let camera = EkoLocalizable.localizedString(forKey: "camera")
    static let imageGallery = EkoLocalizable.localizedString(forKey: "image_gallery")
    static let moderator = EkoLocalizable.localizedString(forKey: "moderator")
    static let file = EkoLocalizable.localizedString(forKey: "file")
    static let location = EkoLocalizable.localizedString(forKey: "location")
    static let album = EkoLocalizable.localizedString(forKey: "album")
    
    public static var editMessageTitle = EkoLocalizable.localizedString(forKey: "edit_message_title")
    
    static var close = EkoLocalizable.localizedString(forKey: "close")
    static var save = EkoLocalizable.localizedString(forKey: "save")
    static var cancel = EkoLocalizable.localizedString(forKey: "cancel")
    static var delete = EkoLocalizable.localizedString(forKey: "delete")
    static var edit = EkoLocalizable.localizedString(forKey: "edit")
    static var done = EkoLocalizable.localizedString(forKey: "done")
    static var post = EkoLocalizable.localizedString(forKey: "post")
    static var discard = EkoLocalizable.localizedString(forKey: "discard")
    static var report = EkoLocalizable.localizedString(forKey: "report")
    static var leave = EkoLocalizable.localizedString(forKey: "leave")
    static let like = EkoLocalizable.localizedString(forKey: "like")
    static let liked = EkoLocalizable.localizedString(forKey: "liked")
    static let reply = EkoLocalizable.localizedString(forKey: "reply")
    static let likes = EkoLocalizable.localizedString(forKey: "likes")
    static let comments = EkoLocalizable.localizedString(forKey: "comments")
    static let remove = EkoLocalizable.localizedString(forKey: "remove")
    
    static var textMessagePlaceholder = EkoLocalizable.localizedString(forKey: "text_message_placeholder")
    static var messageReadmore = EkoLocalizable.localizedString(forKey: "message_readmore")
    static var anonymous = EkoLocalizable.localizedString(forKey: "anonymous")
    static var general = EkoLocalizable.localizedString(forKey: "general")
    static var ok = EkoLocalizable.localizedString(forKey: "ok")
    static var noUserFound = EkoLocalizable.localizedString(forKey: "no_user_found")
    static var searchResults = EkoLocalizable.localizedString(forKey: "search_results")
    static var searchCommunityNotFound = EkoLocalizable.localizedString(forKey: "search_community_not_found")
    static var search = EkoLocalizable.localizedString(forKey: "search")
    
    // MARK: - Message List
    
    enum MessageList {
        static let holdToRecord = EkoLocalizable.localizedString(forKey: "message_list_hold_to_record")
        static let releaseToSend = EkoLocalizable.localizedString(forKey: "message_list_release_to_send")
        static let alertErrorMessageTitle = EkoLocalizable.localizedString(forKey: "message_list_alert_error_message_title")
        static let alertErrorMessageDesc = EkoLocalizable.localizedString(forKey: "message_list_alert_error_message_desc")
        static let alertDeleteErrorMessageTitle = EkoLocalizable.localizedString(forKey: "message_list_alert_delete_error_title")
        static let alertDeleteTitle = EkoLocalizable.localizedString(forKey: "message_list_alert_delete_title")
        static let alertDeleteDesc = EkoLocalizable.localizedString(forKey: "message_list_alert_delete_desc")
        static let sending = EkoLocalizable.localizedString(forKey: "message_list_sending")
    }
    // MARK: - Empty Newsfeed
    static var emptyNewsfeedTitle = EkoLocalizable.localizedString(forKey: "empty_newsfeed_title")
    static var emptyNewsfeedSubtitle = EkoLocalizable.localizedString(forKey: "empty_newsfeed_subtitle")
    static var emptyNewsfeedExploreButton = EkoLocalizable.localizedString(forKey: "empty_newsfeed_explore_button")
    static var emptyNewsfeedCreateButton = EkoLocalizable.localizedString(forKey: "empty_newsfeed_create_button")
    static var emptyNewsfeedStartYourFirstPost = EkoLocalizable.localizedString(forKey: "empty_newsfeed_start_your_first_post")
    static var emptyTitleNoPosts = EkoLocalizable.localizedString(forKey: "empty_title_no_posts")
    
    // MARK: - Create community
    static var createCommunityTitle = EkoLocalizable.localizedString(forKey: "create_community_title")
    static var createCommunityNameTitle = EkoLocalizable.localizedString(forKey: "create_community_name_title")
    static var createCommunityNamePlaceholder = EkoLocalizable.localizedString(forKey: "create_community_name_placeholder")
    static var createCommunityAboutTitle = EkoLocalizable.localizedString(forKey: "create_community_about_title")
    static var createCommunityAboutPlaceholder = EkoLocalizable.localizedString(forKey: "create_community_about_placeholder")
    static var createCommunityCategoryTitle = EkoLocalizable.localizedString(forKey: "create_community_category_title")
    static var createCommunityCategoryPlaceholder = EkoLocalizable.localizedString(forKey: "create_community_category_placeholder")
    static var createCommunityAdminRuleTitle = EkoLocalizable.localizedString(forKey: "create_community_admin_rule_title")
    static var createCommunityAdminRuleDesc = EkoLocalizable.localizedString(forKey: "create_community_admin_rule_desc")
    static var createCommunityPublicTitle = EkoLocalizable.localizedString(forKey: "create_community_public_title")
    static var createCommunityPublicDesc = EkoLocalizable.localizedString(forKey: "create_community_public_desc")
    static var createCommunityPrivateTitle = EkoLocalizable.localizedString(forKey: "create_community_private_title")
    static var createCommunityPrivateDesc = EkoLocalizable.localizedString(forKey: "create_community_private_desc")
    static var createCommunityAddMemberTitle = EkoLocalizable.localizedString(forKey: "create_community_add_member_title")
    static var createCommunityNameAlreadyTaken = EkoLocalizable.localizedString(forKey: "create_community_name_already_taken")
    static var createCommunityButtonCreate = EkoLocalizable.localizedString(forKey: "create_community_button_create")
    static var createCommunityAlertTitle = EkoLocalizable.localizedString(forKey: "create_community_alert_title")
    static var createCommunityAlertDesc = EkoLocalizable.localizedString(forKey: "create_community_alert_desc")
    // MARK: - Select member list
    static var selectMemberListTitle = EkoLocalizable.localizedString(forKey: "select_member_list_title")
    static var selectMemberListSelectedTitle = EkoLocalizable.localizedString(forKey: "select_member_list_selected_title")
    // MARK: - Category selection
    static var categorySelectionTitle = EkoLocalizable.localizedString(forKey: "category_selection_title")
    static var categorySelectionTitle2 = EkoLocalizable.localizedString(forKey: "category_selection_title_2")
    
    // MARK: - My Community
    static var myCommunityTitle = EkoLocalizable.localizedString(forKey: "my_community_title")
    static var myCommunitySeeAll = EkoLocalizable.localizedString(forKey: "my_community_see_all")
    // MARK: - Newsfeed
    public static var newsfeedTitle = EkoLocalizable.localizedString(forKey: "newsfeed_title")
    
    // MARK: - Explore
    public static var exploreTitle = EkoLocalizable.localizedString(forKey: "explore_title")
    
    // MARK: - Community home page
    public static var communityHomeTitle = EkoLocalizable.localizedString(forKey: "community_home_title")
    
    // MARK: - Community detail page
    static var communityDetailPostCount = EkoLocalizable.localizedString(forKey: "community_detail_post_count")
    static var communityDetailMemberCount = EkoLocalizable.localizedString(forKey: "community_detail_member_count")
    static var communityDetailJoinButton = EkoLocalizable.localizedString(forKey: "community_detail_join_button")
    static var communityDetailMessageButton = EkoLocalizable.localizedString(forKey: "community_detail_message_button")
    static var communityDetailEditProfileButton = EkoLocalizable.localizedString(forKey: "community_detail_edit_profile_button")
    // MARK: - Timeline
    public static var timelineTitle = EkoLocalizable.localizedString(forKey: "timeline_title")
    
    // MARK: - Post creation
    static var postCreationEditPostTitle = EkoLocalizable.localizedString(forKey: "post_creation_edit_post")
    static var postCreationMyTimelineTitle = EkoLocalizable.localizedString(forKey: "post_creation_my_timeline")
    static var postCreationTextPlaceholder = EkoLocalizable.localizedString(forKey: "post_creation_text_placeholder")
    static var postCreationDiscardPostTitle = EkoLocalizable.localizedString(forKey: "post_creation_discard_post_title")
    static var postCreationDiscardPostMessage = EkoLocalizable.localizedString(forKey: "post_creation_discard_post_message")

    // MARK: - Post detail
    struct PostDetail {
        static var textPlaceholder = EkoLocalizable.localizedString(forKey: "post_detail_text_placeholder")
        static var deletedItem = EkoLocalizable.localizedString(forKey: "post_detail_deleted_item")
        static var viewAllReplies = EkoLocalizable.localizedString(forKey: "post_detail_view_all_replies")
        static var joinCommunityMessage = EkoLocalizable.localizedString(forKey: "post_detail_join_community_message")
        static var editPost = EkoLocalizable.localizedString(forKey: "post_detail_edit_post")
        static var deletePost = EkoLocalizable.localizedString(forKey: "post_detail_delete_post")
        static var reportPost = EkoLocalizable.localizedString(forKey: "post_detail_report_post")
        static var unreportPost = EkoLocalizable.localizedString(forKey: "post_detail_unreport_post")
        static var editComment = EkoLocalizable.localizedString(forKey: "post_detail_edit_comment")
        static var deleteComment = EkoLocalizable.localizedString(forKey: "post_detail_delete_comment")
        static var reportComment = EkoLocalizable.localizedString(forKey: "post_detail_report_comment")
        static var unreportComment = EkoLocalizable.localizedString(forKey: "post_detail_unreport_comment")
        static var deleteCommentTitle = EkoLocalizable.localizedString(forKey: "post_detail_delete_comment_title")
        static var deleteCommentMessage = EkoLocalizable.localizedString(forKey: "post_detail_delete_comment_message")
        static var discardCommentTitle = EkoLocalizable.localizedString(forKey: "post_detail_discard_comment_title")
        static var discardCommentMessage = EkoLocalizable.localizedString(forKey: "post_detail_discard_comment_message")
        static var deletePostTitle = EkoLocalizable.localizedString(forKey: "post_detail_delete_post_title")
        static var deletePostMessage = EkoLocalizable.localizedString(forKey: "post_detail_delete_post_message")
    }
    
    // MARK: - Post to
    static var postToTitle = EkoLocalizable.localizedString(forKey: "post_to_title")
    static var postToPostAsCommunityTitle = EkoLocalizable.localizedString(forKey: "post_to_post_as_community_title")
    static var postToPostAsCommunityMessage = EkoLocalizable.localizedString(forKey: "post_to_post_as_community_message")
    
    // MARK: - Recommended Community
    static var recommendedCommunityTitle = EkoLocalizable.localizedString(forKey: "recommended_community_title")
    
    // MARK: - Trending Community
    static var trendingCommunityTitle = EkoLocalizable.localizedString(forKey: "trending_community_title")
    static var trendingCommunityCategoryAndMember = EkoLocalizable.localizedString(forKey: "trending_community_category_and_member")
    
    // MARK: - Category
    static var categoryTitle = EkoLocalizable.localizedString(forKey: "category_title")
    
    // MARK: - Community Settings
    static var communitySettingsEditProfile = EkoLocalizable.localizedString(forKey: "community_settings_edit_profile")
    static var communitySettingsMembers = EkoLocalizable.localizedString(forKey: "community_settings_members")
    static var communitySettingsCloseCommunity = EkoLocalizable.localizedString(forKey: "community_settings_close_community")
    static var communitySettingsLeaveCommunity = EkoLocalizable.localizedString(forKey: "community_settings_leave_community")
    static var communitySettingsAlertCloseTitle = EkoLocalizable.localizedString(forKey: "community_settings_alert_close_title")
    static var communitySettingsAlertCloseDesc = EkoLocalizable.localizedString(forKey: "community_settings_alert_close_desc")
    static var communitySettingsAlertLeaveTitle = EkoLocalizable.localizedString(forKey: "community_settings_alert_leave_title")
    static var communitySettingsAlertLeaveDesc = EkoLocalizable.localizedString(forKey: "community_settings_alert_leave_desc")

    // MARK: - Not support role
    static var roleSupportAlertDesc = EkoLocalizable.localizedString(forKey: "role_permission_alert_desc")
    
    // MARK: - Community member settings
    enum CommunityMembreSetting {
        static var alertTitle = EkoLocalizable.localizedString(forKey: "community_member_settings_alert_title")
        static var alertDesc = EkoLocalizable.localizedString(forKey: "community_member_settings_alert_desc")
        static var title = EkoLocalizable.localizedString(forKey: "community_member_settings_title")
        static var moderatorTitle = EkoLocalizable.localizedString(forKey: "community_member_settings_moderator_title")
        static let optionPromoteToModerator = EkoLocalizable.localizedString(forKey: "community_member_settings_options_promote_to_moderator")
        static let optionDismissModerator = EkoLocalizable.localizedString(forKey: "community_member_settings_options_dismiss_moderator")
        static var optionReport = EkoLocalizable.localizedString(forKey: "community_member_settings_options_report")
        static var optionUnreport = EkoLocalizable.localizedString(forKey: "community_member_settings_options_unreport")
        static var optionRemove = EkoLocalizable.localizedString(forKey: "community_member_settings_options_remove")
    }
    
    // MARK: - Edit User Profile
    static let editUserProfileTitle = EkoLocalizable.localizedString(forKey: "edit_user_profile_title")
    static let editUserProfileDisplayNameTitle = EkoLocalizable.localizedString(forKey: "edit_user_profile_display_name_title")
    static let editUserProfileDescriptionTitle = EkoLocalizable.localizedString(forKey: "edit_user_profile_description_title")
    
    // MARK: - HUD Message
    struct HUD {
        static let somethingWentWrong = EkoLocalizable.localizedString(forKey: "hud_somthing_went_wrong")
        static let successfullyCreated = EkoLocalizable.localizedString(forKey: "hud_successfully_created")
        static let successfullyUpdated = EkoLocalizable.localizedString(forKey: "hud_successfully_updated")
        static let reportSent = EkoLocalizable.localizedString(forKey: "hud_report_sent")
        static let unreportSent = EkoLocalizable.localizedString(forKey: "hud_unreport_sent")
        static let delete = EkoLocalizable.localizedString(forKey: "hud_delete")
    }
    
    enum PopoverText {
        static let popoverMessageIsTooShort = EkoLocalizable.localizedString(forKey: "Message is too short.")
    }
    
}

