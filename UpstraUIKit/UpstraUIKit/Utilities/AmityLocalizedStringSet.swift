//
//  AmityLocalizedStringSet.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

// Note
// See more: https://docs.sendbird.com/ios/ui_kit_common_components#3_stringset
/// The `AmityLocalizedStringSet` contains the common strings that are used to compose the screen. The following table shows all the elements of the `AmityLocalizedStringSet`
/// # Note:
/// You should modify the stringSet values in advance if you want to make changes to the screen
/// # Customize the StringSet
/// ```
/// AmityLocalizedStringSet.OK = {CUSTOM_STRING}
/// ```
public struct AmityLocalizedStringSet {
    private init() { }
    
    enum General {
        static let report = "general_report"
        static let undoReport = "genera_undo_report"
    }
    
    static let titlePlaceholder = "title_placeholder"
    static let descriptionPlaceholder = "description_placeholder"
    static let members = "members"
    static let follow = "follow"
    static let chatTitle = "chat_title"
    static let recentTitle = "recent_title"
    static let directoryTitle = "directory_title"
    static let emptyChatList = "empty_chat_list"
    static let camera = "camera"
    static let imageGallery = "image_gallery"
    static let moderator = "moderator"
    static let file = "file"
    static let location = "location"
    static let album = "album"
    
    static let editMessageTitle = "edit_message_title"
    static let viewAllCommentsTitle = "view_all_comments_title"
    static let viewAllFilesTitle = "view_all_files_title"
    
    static let close = "close"
    static let save = "save"
    static let saved = "saved"
    static let cancel = "cancel"
    static let delete = "delete"
    static let edit = "edit"
    static let done = "done"
    static let post = "post"
    static let discard = "discard"
    static let report = "report"
    static let leave = "leave"
    static let like = "like"
    static let liked = "liked"
    static let reply = "reply"
    static let viewReply = "view_reply"
    static let likesPlural = "likes_plural"
    static let likesSingular = "likes_singular"
    static let commentsPlural = "comments_plural"
    static let commentsSingular = "comments_singular"
    static let sharesPlural = "shares_plural"
    static let sharesSingular = "shares_singular"
    static let remove = "remove"
    static let communitySettings = "community_settings"
    static let skipForNow = "skip_for_now"
    static let turnOn = "turn_on"
    static let turnOff = "turn_off"
    
    static let on = "on"
    static let off = "off"
    
    static let textMessagePlaceholder = "text_message_placeholder"
    static let messageReadmore = "message_readmore"
    static let anonymous = "anonymous"
    static let general = "general"
    static let ok = "ok"
    static let noUserFound = "no_user_found"
    static let searchResults = "search_results"
    static let searchCommunityNotFound = "search_community_not_found"
    static let search = "search"
    
    static let somethingWentWrongWithTryAgain = "something_went_wrong_with_try_again"
    static let noInternetConnection = "no_internet_connection"
    
    // MARK: - Message List
    enum MessageList {
        static let holdToRecord = "message_list_hold_to_record"
        static let releaseToSend = "message_list_release_to_send"
        static let alertErrorMessageTitle = "message_list_alert_error_message_title"
        static let alertErrorMessageDesc = "message_list_alert_error_message_desc"
        static let alertDeleteErrorMessageTitle = "message_list_alert_delete_error_title"
        static let alertDeleteTitle = "message_list_alert_delete_title"
        static let alertDeleteDesc = "message_list_alert_delete_desc"
        static let sending = "message_list_sending"
        static let deleteMessage = "message_delete"
        static let editMessage = "message_edit"
    }

    // MARK: - Empty Newsfeed
    static let emptyNewsfeedTitle = "empty_newsfeed_title"
    static let emptyNewsfeedSubtitle = "empty_newsfeed_subtitle"
    static let emptyNewsfeedExploreButton = "empty_newsfeed_explore_button"
    static let emptyNewsfeedCreateButton = "empty_newsfeed_create_button"
    static let emptyNewsfeedStartYourFirstPost = "empty_newsfeed_start_your_first_post"
    static let emptyTitleNoPosts = "empty_title_no_posts"
    
    // MARK: - Create community
    static let editCommunityTitle = "edit_community_title"
    static let createCommunityTitle = "create_community_title"
    static let createCommunityNameTitle = "create_community_name_title"
    static let createCommunityNamePlaceholder = "create_community_name_placeholder"
    static let createCommunityAboutTitle = "create_community_about_title"
    static let createCommunityAboutPlaceholder = "create_community_about_placeholder"
    static let createCommunityCategoryTitle = "create_community_category_title"
    static let createCommunityCategoryPlaceholder = "create_community_category_placeholder"
    static let createCommunityAdminRuleTitle = "create_community_admin_rule_title"
    static let createCommunityAdminRuleDesc = "create_community_admin_rule_desc"
    static let createCommunityPublicTitle = "create_community_public_title"
    static let createCommunityPublicDesc = "create_community_public_desc"
    static let createCommunityPrivateTitle = "create_community_private_title"
    static let createCommunityPrivateDesc = "create_community_private_desc"
    static let createCommunityAddMemberTitle = "create_community_add_member_title"
    static let createCommunityNameAlreadyTaken = "create_community_name_already_taken"
    static let createCommunityButtonCreate = "create_community_button_create"
    static let createCommunityAlertTitle = "create_community_alert_title"
    static let createCommunityAlertDesc = "create_community_alert_desc"
    
    // MARK: - Select member list
    static let selectMemberListTitle = "select_member_list_title"
    static let selectMemberListSelectedTitle = "select_member_list_selected_title"
    // MARK: - Category selection
    static let categorySelectionTitle = "category_selection_title"
    static let categorySelectionTitle2 = "category_selection_title_2"
    
    // MARK: - My Community
    static let myCommunityTitle = "my_community_title"
    static let myCommunitySeeAll = "my_community_see_all"
    // MARK: - Newsfeed
    public static let newsfeedTitle = "newsfeed_title"
    
    // MARK: - Explore
    public static let exploreTitle = "explore_title"
    
    // MARK: - Community home page
    public static let communityHomeTitle = "community_home_title"
    
    // MARK: - Community detail page
    static let communityDetailPostCount = "community_detail_post_count"
    static let communityDetailMemberCount = "community_detail_member_count"
    static let communityDetailJoinButton = "community_detail_join_button"
    static let communityDetailMessageButton = "community_detail_message_button"
    static let communityDetailEditProfileButton = "community_detail_edit_profile_button"
    // MARK: - Timeline
    public static let timelineTitle = "timeline_title"
    
    // MARK: - Post creation
    static let postCreationEditPostTitle = "post_creation_edit_post"
    static let postCreationMyTimelineTitle = "post_creation_my_timeline"
    static let postCreationTextPlaceholder = "post_creation_text_placeholder"
    static let postCreationDiscardPostTitle = "post_creation_discard_post_title"
    static let postCreationDiscardPostMessage = "post_creation_discard_post_message"
    static let postCreationSelectImageTitle = "post_creation_select_image"
    static let postCreationUploadIncompletTitle = "post_creation_file_upload_icomplete_title"
    static let postCreationUploadIncompletDescription = "post_creation_file_upload_icomplete_description"

    // MARK: - Post detail
    struct PostDetail {
        static let replyingTo = "post_detail_replying_to"
        static let createReply = "post_detail_create_reply"
        static let editReply = "post_detail_edit_reply"
        static let deleteReply = "post_detail_delete_reply"
        static let deleteReplyTitle = "post_detail_delete_reply_title"
        static let deleteReplyMessage = "post_detail_delete_reply_message"
        static let discardReplyTitle = "post_detail_discard_reply_title"
        static let discardReplyMessage = "post_detail_discard_reply_message"
        static let discardEditedReplyMessage = "post_detail_discard_edited_reply_message"
        static let viewMoreReply = "post_detail_view_more_reply"
        static let deletedReplyMessage = "post_detail_deleted_reply_message"
        static let textPlaceholder = "post_detail_text_placeholder"
        static let deletedCommentMessage = "post_detail_deleted_comment_message"
        static let viewAllReplies = "post_detail_view_all_replies"
        static let joinCommunityMessage = "post_detail_join_community_message"
        static let editPost = "post_detail_edit_post"
        static let deletePost = "post_detail_delete_post"
        static let createComment = "post_detail_create_comment"
        static let editComment = "post_detail_edit_comment"
        static let deleteComment = "post_detail_delete_comment"
        static let deleteCommentTitle = "post_detail_delete_comment_title"
        static let deleteCommentMessage = "post_detail_delete_comment_message"
        static let discardCommentTitle = "post_detail_discard_comment_title"
        static let discardCommentMessage = "post_detail_discard_comment_message"
        static let discardEditedCommentMessage = "post_detail_discard_edited_comment_message"
        static let deletePostTitle = "post_detail_delete_post_title"
        static let deletePostMessage = "post_detail_delete_post_message"
        static let postDetailCommentEdit = "post_detail_comment_edited"
        static let banndedCommentErrorMessage = "post_detail_banned_comment_error_message"
    }
    
    // MARK: - Post to
    static let postToTitle = "post_to_title"
    static let postToPostAsCommunityTitle = "post_to_post_as_community_title"
    static let postToPostAsCommunityMessage = "post_to_post_as_community_message"
    
    // MARK: - Recommended Community
    static let recommendedCommunityTitle = "recommended_community_title"
    
    // MARK: - Trending Community
    static let trendingCommunityTitle = "trending_community_title"
    static let trendingCommunityMembers = "trending_community_members"
    
    // MARK: - Category
    static let categoryTitle = "category_title"
    
    // MARK: - Community Settings
    enum CommunitySettings {
        static let itemHeaderBasicInfo = "community_settings_item_header_basic_info"
        static let itemHeaderCommunityPermissions = "community_settings_item_header_community_permissions"
        static let itemTitleEditProfile = "community_settings_item_title_edit_profile"
        static let itemTitleMembers = "community_settings_item_title_members"
        static let itemTitleNotifications = "community_settings_item_title_notifications"
        static let itemTitlePostReview = "community_settings_item_title_post_review"
        static let itemTitleLeaveCommunity = "community_settings_item_title_leave_community"
        static let itemTitleCloseCommunity = "community_settings_item_title_close_community"
        static let itemDescCloseCommunity = "community_settings_item_desc_close_community"
        static let alertTitleLeave = "community_settings_alert_title_leave"
        static let alertDescLeave = "community_settings_alert_desc_leave"
        static let alertTitleClose = "community_settings_alert_title_close"
        static let alertDescClose = "community_settings_alert_desc_close"
        static let alertFailTitleLeave = "community_settings_alert_fail_title_leave"
        static let alertFailTitleClose = "community_settings_alert_fail_title_leave"
        static let alertFailTitleTurnNotificationOn = "community_settings_alert_fail_title_notification_on"
        static let alertFailTitleTurnNotificationOff = "community_settings_alert_fail_title_notification_off"
    }

    // MARK: - Notification Settings
    enum CommunityNotificationSettings {
        static let titleNotifications = "community_notification_settings_title_notifications"
        static let descriptionNotifications = "community_notification_settings_description_notifications"
        static let titleReactsPosts = "community_notification_settings_title_reacts_posts"
        static let descriptionReactsPosts = "community_notification_settings_description_reacts_posts"
        static let titleNewPosts = "community_notification_settings_title_new_posts"
        static let descriptionNewPosts = "community_notification_settings_description_new_posts"
        static let titleReactsComments = "community_notification_settings_title_reacts_comments"
        static let descriptionReactsComments = "community_notification_settings_description_reacts_comments"
        static let titleNewComments = "community_notification_settings_title_new_comments"
        static let descriptionNewComments = "community_notification_settings_description_new_comments"
        static let titleReplies = "community_notification_settings_title_replies"
        static let descriptionReplies = "community_notification_settings_description_replies"
        static let post = "community_notification_settings_post"
        static let comment = "community_notification_settings_comment"
        static let everyone = "community_notification_settings_everyone"
        static let onlyModerator = "community_notification_settings_only_moderator"
    }
    
    // MARK: - Not support role
    static let roleSupportAlertDesc = "role_permission_alert_desc"
    
    // MARK: - Community member settings
    enum CommunityMembreSetting {
        static let alertTitle = "community_member_settings_alert_title"
        static let alertDesc = "community_member_settings_alert_desc"
        static let title = "community_member_settings_title"
        static let moderatorTitle = "community_member_settings_moderator_title"
        static let optionPromoteToModerator = "community_member_settings_options_promote_to_moderator"
        static let optionDismissModerator = "community_member_settings_options_dismiss_moderator"
        static let optionRemove = "community_member_settings_options_remove"
    }
    
    // MARK: - Community
    enum Community {
        static let alertUnableToPerformActionTitle = "community_alert_unable_to_perform_action_title"
        static let alertUnableToPerformActionDesc = "community_alert_unable_to_perform_action_desc"
    }
    
    // MARK: - Edit User Profile
    static let editUserProfileTitle = "edit_user_profile_title"
    static let editUserProfileDisplayNameTitle = "edit_user_profile_display_name_title"
    static let editUserProfileDescriptionTitle = "edit_user_profile_description_title"
    
    // MARK: - HUD Message
    struct HUD {
        static let somethingWentWrong = "hud_somthing_went_wrong"
        static let successfullyCreated = "hud_successfully_created"
        static let successfullyUpdated = "hud_successfully_updated"
        static let reportSent = "hud_report_sent"
        static let unreportSent = "hud_unreport_sent"
        static let delete = "hud_delete"
    }
    
    enum PopoverText {
        static let popoverMessageIsTooShort = "Message is too short."
    }
    
    // MARK: - Post Sharing type
    struct SharingType {
        static let shareToMyTimeline = "share_to_my_timeline"
        static let shareToGroup = "share_to_group"
        static let moreOptions = "more_options"
    }
    
    // MARK: - Post
    enum Post {
        static let placeholderTitle = "post_place_holder_title"
        static let placeholderDesc = "post_place_holder_desc"
    }
    
    enum PostReviewSettings {
        static let title = "post_review_settings_title"
        static let itemTitleApproveMemberPosts = "post_review_settings_item_title_approve_member_posts";
        static let itemDescApproveMemberPosts = "post_review_settings_item_desc_approve_member_posts";
        static let alertTitleTurnOffPostReview = "post_review_settings_alert_title_turn_off_post_review"
        static let alertDescTurnOffPostReview = "post_review_settings_alert_desc_turn_off_post_reivew"
        static let hudTitleTurnOffPostReview = "post_review_settings_hud_title_turn_off_post_review"
        static let alertFailTitleTurnOn = "post_review_settings_alert_fail_title_turn_on"
        static let alertFailTitleTurnOff = "post_review_settings_alert_fail_title_turn_off"
    }
    
    // MARK: - Modal
    enum Modal {
        static let communitySettingsTitle = "modal_community_settings_title"
        static let communitySettingsDesc = "modal_community_settings_desc"
    }
}
