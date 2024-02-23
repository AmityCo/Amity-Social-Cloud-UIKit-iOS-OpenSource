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
/// AmityLocalizedStringSet.General.ok = {CUSTOM_STRING}
/// ```
public struct AmityLocalizedStringSet {
    private init() { }
    
    public enum General {
        static let report = "general_report"
        static let undoReport = "general_undo_report"
        static let reportUser = "general_report_user"
        static let unreportUser = "general_unreport_user"
        static let settings = "general_settings"
        static let accept = "general_accept"
        static let decline = "general_decline"
        static let close = "general_close"
        static let save = "general_save"
        static let saved = "general_saved"
        static let cancel = "general_cancel"
        static let delete = "general_delete"
        static let edit = "general_edit"
        public static let done = "general_done"
        static let post = "general_post"
        static let discard = "general_discard"
        static let leave = "general_leave"
        static let like = "general_like"
        static let liked = "general_liked"
        static let reply = "general_reply"
        static let viewReply = "general_view_reply"
        static let remove = "general_remove"
        static let turnOn = "general_turn_on"
        static let turnOff = "general_turn_off"
        static let follow = "general_follow"
        static let camera = "general_camera"
        static let on = "general_on"
        static let off = "general_off"
        static let file = "general_file"
        static let location = "general_location"
        static let album = "general_album"
        static let anonymous = "general_anonymous"
        static let general = "general_general"
        static let ok = "general_ok"
        static let search = "general_search"
        static let imageGallery = "general_image_gallery"
        static let uploadImage = "general_upload_image"
        static let moderator = "general_moderator"
        static let poll = "general_poll"
        static let day = "general_day"
        static let days = "general_days"
        static let textInputLimitCharactor = "genera_text_input_limit_charactor"
        static let generalVideo = "general_video";
        static let generalPhoto = "general_photo";
        static let generalAttachment = "general_attachment";
        static let generalAll = "general_all";
    }
    
    static let communitySettings = "community_settings"
    static let skipForNow = "skip_for_now"
    
    enum Unit {
        static let memberSingular = "unit_member_singular"
        static let memberPlural = "unit_member_plural"
        static let likeSingular = "unit_like_singular"
        static let likePlural = "unit_like_plural"
        static let commentSingular = "unit_comment_singular"
        static let commentPlural = "unit_comment_plural"
        static let postSingular = "unit_post_singular"
        static let postPlural = "unit_post_plural"
        static let sharesSingular = "unit_share_singular"
        static let sharesPlural = "unit_share_plural"
        static let daySingular = "unit_day_singular"
        static let dayPlural = "unit_day_plural"
        static let hourSingular = "unit_hour_singular"
        static let hourPlural = "unit_hour_plural"
        static let minuteSingular = "unit_minute_singular"
        static let minutePlural = "unit_minute_plural"
    }
    
    static let titlePlaceholder = "title_placeholder"
    static let descriptionPlaceholder = "description_placeholder"
    static let chatTitle = "chat_title"
    static let recentTitle = "recent_title"
    static let directoryTitle = "directory_title"
    static let emptyChatList = "empty_chat_list"
    static let editMessageTitle = "edit_message_title"
    static let viewAllCommentsTitle = "view_all_comments_title"
    static let viewAllFilesTitle = "view_all_files_title"
    
    static let textMessagePlaceholder = "text_message_placeholder"
    static let messageReadmore = "message_readmore"
    static let noUserFound = "no_user_found"
    static let searchResults = "search_results"
    static let searchResultNotFound = "search_result_not_found"
    static let communities = "communities"
    static let accounts = "accounts"
    
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
    
    // MARK: - User Feed
    static let privateUserFeedTitle = "private_user_feed_title"
    static let privateUserFeedSubtitle = "private_user_feed_subtitle"
    
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
    static let communityDetailJoinButton = "community_detail_join_button"
    static let communityDetailMessageButton = "community_detail_message_button"
    static let communityDetailEditProfileButton = "community_detail_edit_profile_button"
    
    // MARK: - User detail page
    static let userDetailFollowingCount = "user_detail_following_count"
    static let userDetailFollowersCount = "user_detail_followers_count"
    static let userDetailFollowButtonFollow = "user_detail_follow_button_follow"
    static let userDetailFollowButtonCancel = "user_detail_follow_button_cancel"
    static let userDetailsPendingRequests = "user_details_pending_requests"
    static let userDetailsPendingRequestsDescription = "user_details_pending_requests_description"
    static let userDetailsUnableToFollow = "user_details_unable_to_follow"
    static let userDetailsButtonUnblock = "user_details_button_unblock"
    
    // MARK: - Timeline
    public static let timelineTitle = "timeline_title"
    
    // MARK: - Post creation
    static let postCreationEditPostTitle = "post_creation_edit_post"
    static let postCreationMyTimelineTitle = "post_creation_my_timeline"
    static let postCreationTextPlaceholder = "post_creation_text_placeholder"
    static let postCreationDiscardPostTitle = "post_creation_discard_post_title"
    static let postCreationDiscardPostMessage = "post_creation_discard_post_message"
    static let postCreationSelectImageTitle = "post_creation_select_image"
    static let postCreationSelectVideoTitle = "post_creation_select_video"
    static let postCreationUploadIncompletTitle = "post_creation_file_upload_icomplete_title"
    static let postCreationUploadIncompletDescription = "post_creation_file_upload_icomplete_description"
    static let postCreationSubmitTitle = "post_craetion_submit_title"
    static let postCreationSubmitDesc = "post_creation_submit_desc"
    static let postUnableToPostTitle = "post_unable_to_post_title"
    static let postUnableToCommentTitle = "post_unable_to_comment_title"
    static let postUnableToReplyTitle = "post_unable_to_reply_title"
    static let postUnableToPostDescription = "post_unable_to_post_description"
    static let postUnableToCommentDescription = "post_unable_to_comment_description"
    static let postUnableToReplyDescription = "post_unable_to_reply_description"
    
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
    
    // MARK: - Member title
    static let memberTitle = "member_list_title"
    
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
        static let alertDescModeratorLeave = "community_settings_alert_desc_moderator_leave"
        static let alertDescLastModeratorLeave = "community_settings_alert_desc_last_moderator_leave"
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
    
    // MARK: - User Settings
    enum UserSettings {
        static let itemHeaderManageInfo = "user_settings_item_header_manage"
        static let itemHeaderBasicInfo = "user_settings_item_header_basic_info"
        static let itemUnfollow = "user_settings_item_unfollow"
        static let itemReportUser = "user_settings_item_report_user"
        static let itemUnreportUser = "user_settings_item_unreport_user"
        static let itemEditProfile = "user_settings_item_edit_profile"
        static let itemBlockUser = "user_settings_item_block_user"
        static let itemUnblockUser = "user_settings_item_unblock_user"
        
        enum UserSettingsMessages {
            static let unfollowMessage = "user_settings_unfollow_message"
            static let unfollowFailTitle = "user_settings_unfollow_fail_title"
            
            static let blockUserSuccess = "user_settings_block_user_succes"
            static let unblockUserSuccess = "user_settings_unblock_user_success"
            static let blockUserFailedTitle = "user_settings_block_user_failed"
            static let unblockUserFailedTitle = "user_settings_unblock_user_failed"
        }
        
        enum UserSettingsRemove {
            static let removeUser = "user_settings_remove_user"
            static let removeUserTitle = "user_settings_remove_user_title"
            static let removeUserDescription = "user_settings_remove_user_description"
        }
        
        
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
        static let alertUnableToLeaveCommunityTitle = "community_alert_unable_to_leave_community_title"
        static let alertUnableToLeaveCommunityDesc = "community_alert_unable_to_leave_community_desc"
    }
    
    // MARK: - Edit User Profile
    static let editUserProfileTitle = "edit_user_profile_title"
    static let editUserProfileDisplayNameTitle = "edit_user_profile_display_name_title"
    static let editUserProfileEmailTitle = "edit_user_profile_email_title"
    static let editUserProfilePhoneNumberTitle = "edit_user_profile_phone_number_title"
    static let editUserProfileDescriptionTitle = "edit_user_profile_description_title"
    
    // MARK: - Profile Option
    static let profileOptionTitle = "profile_option_title"
    static let profileOptionEdit = "profile_option_edit"
    static let profileOptionLogout = "profile_option_logout"
    
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
    
    // MARK: - Chat setting
    enum ChatSettings {
        static let leaveChannel = "chat_setting_leave_channel"
        static let member = "chat_setting_member"
        static let groupProfile = "chat_setting_group_profile"
        static let reportUser = "chat_setting_report_user"
        static let unReportUser = "chat_setting_unreport_user"
        static let title = "chat_setting_title"
        static let reportSent = "chat_setting_report_sent"
        static let leaveChatTitle = "chat_setting_leave_chat_title"
        static let leaveChatMessage = "chat_setting_leave_chat_message"
        static let promoteToModerator = "chat_setting_promote_to_moderator"
        static let dismissFromModerator = "chat_setting_dimiss_to_moderator"
        static let removeFromGroupChat = "chat_setting_remove_from_group_chat"
        static let report = "chat_setting_report"
        static let memberTitle = "chat_setting_member_title"
        static let moderatorTitle = "chat_setting_moderator_title"
        static let navigationTitle = "chat_setting_member_detail_title"
        static let removeMemberAlertTitle = "chat_setting_remove_member_alert_title"
        static let removeMemberAlertBody = "chat_setting_remove_member_alert_body"
    }
    
    enum CommunityChannelCreation {
        static let failedToCreate = "chat_create_failed"
    }
    // MARK: - Follow
    enum Follow {
        static let followRequestsTitle = "follow_requests_title"
        static let accept = "follow_accept"
        static let decline = "follow_decline"
        static let unavailableFollowRequest = "follow_unavailable_follow_request"
        static let followers = "follow_followers"
        static let following = "follow_following"
        static let canNotRefreshFeed = "follow_can_not_refresh_feed"
    }
    
    // MARK: - Pending posts
    enum PendingPosts {
        static let title = "pending_posts_title"
        static let statusTitle = "pending_posts_status_title"
        static let statusAdminDesc = "pending_posts_status_admin_desc"
        static let statusMemberDesc = "pending_posts_status_member_desc"
        static let headerTitle = "pending_posts_header_title"
        static let emptyTitle = "pending_posts_empty_title"
        static let alertDeleteTitle = "pending_posts_alert_delete_title"
        static let alertDeleteDesc = "pending_posts_alert_delete_desc"
        static let alertDeleteFailTitle = "pending_posts_alert_delete_fail_title"
        static let postNotAvailable = "pending_posts_post_not_available"
        static let alertDeleteFailApproveOrDecline = "pending_posts_alert_delete_fail_approve_or_decline"
    }
    
    // MARK: - Polls
    enum Poll {
        
        enum Create {
            static let questionTitle = "poll_create_question_title"
            static let questionPlaceholder = "poll_create_question_placeholder"
            static let answerTitle = "poll_create_answer_title"
            static let answerDesc = "poll_create_answer_desc"
            static let answerPlaceholder = "poll_create_answer_placeholder"
            static let answerButton = "poll_create_answer_button"
            static let multipleSelectionTitle = "poll_create_multiple_selection_title"
            static let multipleSelectionDesc = "poll_create_multiple_selection_desc"
            static let scheduleTitle = "poll_create_schedule_title"
            static let scheduleDesc = "poll_create_schedule_desc"
            static let chooseTimeFrameTitle = "poll_create_choose_time_frame_title"
            static let alertTitle = "poll_create_alert_title"
            static let alertDesc = "poll_create_alert_desc"
        }
        
        enum Option {
            static let closeTitle = "poll_close_title"
            static let deleteTitle = "poll_delete_title"
            static let moreOption = "more options";
            static let viewFullResult = "poll_view_full_result"
            static let alertCloseTitle = "poll_alert_close_title"
            static let alertCloseDesc = "poll_alert_close_desc"
            static let alertDeleteTitle = "poll_alert_delete_title"
            static let alertDeleteDesc = "poll_alert_delete_desc"
            static let submitVoteTitle = "poll_submit_vote_title"
            static let voteCountTitle = "poll_vote_count_title"
            static let finalResult = "poll_final_result"
            static let openForVoting = "poll_open_for_voting"
            
            static let pollEndDurationDays = "poll_ends_in_days"
            static let pollEndDurationMinutes = "poll_ends_in_minutes"
            static let pollEndDurationHours = "poll_ends_in_hours"
        }
    }
    
    // MARK: - Mention
    public enum Mention {
        public static let unableToMentionTitle = "mention_unable_to_mention_title"
        public static let unableToMentionPostDescription = "mention_unable_to_mention_post_description"
        public static let unableToMentionCommentDescription = "mention_unable_to_mention_comment_description"
        public static let unableToMentionReplyDescription = "mention_unable_to_mention_reply_description"
    }
    
    // MARK: - Reaction
    public enum Reaction {
        public static let reactionTitle = "reaction_screen_title";
        public static let emptyStateTitle = "reaction_empty_state_title";
        public static let emptyStateSubtitle = "reaction_empty_state_subtitle";
    }
}
