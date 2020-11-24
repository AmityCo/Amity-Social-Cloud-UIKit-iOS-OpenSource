//
//  EkoEnums.h
//  EkoChat
//
//  Created by David Zhang on 3/2/18.
//  Copyright © 2018 eko. All rights reserved.
//

#ifndef EkoEnums_h
#define EkoEnums_h
#import <Foundation/Foundation.h>

#pragma mark - Backend mapping

// EkoDataType
static NSString * const kEkoDataTypeText = @"text";

// EkoReferenceType
static NSString * const kEkoReferenceTypePost = @"post";
static NSString * const kEkoReferenceTypeComment = @"comment";
static NSString * const kEkoReferenceTypeMessage = @"message";
static NSString * const kEkoReferenceTypeContent = @"content";

typedef NS_ENUM(NSInteger, EkoConnectionStatus) {
    // The client/manager has never been connected. Or the client has been reset.
    EkoConnectionStatusNotConnected = 0,
    // The client/manager was once connected, but not anymore.
    EkoConnectionStatusDisconnected = 1,
    // The client/manager is in the process of connecting.
    EkoConnectionStatusConnecting = 2,
    // The client/manager is currently connected.
    EkoConnectionStatusConnected = 3,
};

typedef NS_ENUM(NSInteger, EkoChannelQueryFilter) {
    // query for all channels, regardless of whether the user has joined or not
    EkoChannelQueryFilterAll = 0,
    // query for all channels where the user is member
    EkoChannelQueryFilterUserIsMember = 1,
    // query for all channels where the user is not a member
    EkoChannelQueryFilterUserIsNotMember = 2,
};

typedef NS_ENUM(NSInteger, EkoLoadingStatus) {
    // the data locally is already fresh, no need to load
    EkoLoadingStatusNotLoading = 0,
    // the client is currently loading this data from the server
    EkoLoadingStatusLoading = 1,
    // the client has loaded fresh data from the server and is up to date
    EkoLoadingStatusLoaded = 2,
    // the client has encoutered an error loading this data, please check if Ids and parameters are correct
    EkoLoadingStatusError = 3,
};

/**
   Reflection of the data state.

   Use this property to verify that the data is actually:
   - fresh (verified from the server)
   - from the local storage only
   - and more.

   - EkoDataStatusNotExist: The data does not exist locally.
   - EkoDataStatusLocal: The data is fetched from local database.
   - EkoDataStatusFresh: The data is fresh.
   - EkoDataStatusError: The data is invalid, this is set in conjunction with LoadingStatusError.
 */
typedef NS_ENUM(NSInteger, EkoDataStatus) {
    EkoDataStatusNotExist = 0,
    EkoDataStatusLocal = 1,
    EkoDataStatusFresh = 2,
    EkoDataStatusError = 3
};

/**
   Errors that can happen within the SDK.

   - EkoErrorCodeUnauthorized: The action is not allowed with the current
     logged-in user.
   - EkoErrorCodeUserIsMuted: The action cannot be completed because the user is
     muted in the channel.
   - EkoErrorCodeChannelIsMuted: The action cannot be completed because the
     entire channel is muted.
   - EkoErrorCodeUserIsBanned: The action cannot be completed because the user
     is banned.
   - MaxRepetitionExceed: The action cannot be completed because it has been
     done too frequently.
   - EkoErrorCodeBanWordFound: The action cannot be completed because a
     blacklist word has been detected.
   - EkoErrorCodeGlobalBanError: The logged-in user is banned globally from
     using the SDK.
   - EkoErrorCodeInvalidParameter: The action cannot be completed because a
     parameter is invalid.
   - EkoErrorCodeQueryInProgress: There's a query already in progress.
 */
typedef NS_ENUM(NSInteger, EkoErrorCode) {
    // Server codes
    EkoErrorCodeBusiness = 500000,
    EkoErrorCodeBadRequest = 400000,
    EkoErrorCodeUnauthorized = 400100,
    EkoErrorCodeItemNotFound = 400400,
    EkoErrorCodeForbiddenError = 400300,
    EkoErrorCodePermissionDenied = 400301,
    EkoErrorCodeUserIsMuted = 400302,
    EkoErrorCodeChannelIsMuted = 400303,
    EkoErrorCodeUserIsBanned = 400304,
    EkoErrorCodeNumberOfMemberExceed = 400305,
    EkoErrorCodeExemptFromBan = 400306,
    EkoErrorCodeMaxRepetitionExceed = 400307,
    EkoErrorCodeBanWordFound = 400308,
    EkoErrorCodeLinkNotAllowed = 400309,
    EkoErrorCodeTooManyMember = 400310,
    EkoErrorCodeRateLimit = 400311,
    EkoErrorCodeGlobalBan = 400312,
    EkoErrorCodeConflict = 400900,
    EkoErrorCodeReactionNotFound = 400400,

    // Client codes
    EkoErrorCodeUnknown = 800000,
    EkoErrorCodeInvalidParameter = 800110,
    EkoErrorCodeMalformedData = 800130,
    EkoErrorCodeQueryInProgress = 800170,
    EkoErrorCodeConnectionError = 800210,
    EkoErrorCodeUploadFailed = 800310
};

/**
   Channel Membership types.

   Each member can be only on one state at any given time.

   - EkoChannelMembershipNone: Not a member of this channel.
   - EkoChannelMembershipMember: Standard member.
   - EkoChannelMembershipBanned: Banned member.
 */
typedef NS_ENUM(NSUInteger, EkoChannelMembershipType) {
    EkoChannelMembershipTypeNone,
    EkoChannelMembershipTypeMember,
    EkoChannelMembershipTypeBanned
};

/**
   Community Membership types.

   Each member can be only on one state at any given time.

   - EkoCommunityMembershipTypeNone: Not a member of this channel.
   - EkoCommunityMembershipTypeMember: Standard member.
   - EkoCommunityMembershipTypeBanned: Banned member.
 */
typedef NS_ENUM(NSUInteger, EkoCommunityMembershipType) {
    EkoCommunityMembershipTypeNone,
    EkoCommunityMembershipTypeMember,
    EkoCommunityMembershipTypeBanned
};

/**
 Reference type of an object we are referencing to.

 - EkoReferenceTypeMessage: A text message.
 - EkoReferenceTypePost: A post of user.
 - EkoReferenceTypeComment: A comment. 
 */
typedef NS_ENUM(NSInteger, EkoReferenceType) {
    EkoReferenceTypeMessage,
    EkoReferenceTypePost,
    EkoReferenceTypeComment
};

/**
 Data type of the data we intend to sent.

 - EkoDataTypeText: A text.
 */
typedef NS_ENUM(NSInteger, EkoDataType) {
    EkoDataTypeText
};

/**
 * Sort type option for sorting the user
 */
typedef NS_ENUM(NSUInteger, EkoUserSortOption) {
    EkoUserSortOptionDisplayName,
    EkoUserSortOptionFirstCreated,
    EkoUserSortOptionLastCreated
};

/**
 * Sort type option for sorting the user feed
 */
typedef NS_ENUM(NSUInteger, EkoUserFeedSortOption) {
    EkoUserFeedSortOptionLastCreated,
    EkoUserFeedSortOptionFirstCreated
};

/**
 Sync State
 */
typedef NS_ENUM(NSInteger, EkoSyncState) {
    EkoSyncStateDefault = 0,
    EkoSyncStateSynced = 1,
    EkoSyncStateSyncing = 2,
    EkoSyncStateError = 3,
};

/**
 * Filter type option for query the community
 */
typedef NS_ENUM(NSInteger, EkoCommunityQueryFilter) {
    // query for all community, regardless of whether the user has joined or not
    EkoCommunityQueryFilterAll = 0,
    // query for all community where the user is member
    EkoCommunityQueryFilterUserIsMember = 1,
    // query for all community where the user is not a member
    EkoCommunityQueryFilterUserIsNotMember = 2,
};

/**
 * Sort type option for sorting the community
 */
typedef NS_ENUM(NSUInteger, EkoCommunitySortOption) {
    EkoCommunitySortOptionLastCreated,
    EkoCommunitySortOptionFirstCreated
};

/**
 * Community membership filter options
 */
typedef NS_ENUM(NSUInteger, EkoCommunityMembershipFilter) {
    EkoCommunityMembershipFilterAll,
    EkoCommunityMembershipFilterBan
};

/*
 * Sort type option for sorting the community categories
 */
typedef NS_ENUM(NSUInteger, EkoCommunityCategoriesSortOption) {
    EkoCommunityCategoriesSortOptionLastCreated,
    EkoCommunityCategoriesSortOptionFirstCreated,
    EkoCommunityCategoriesSortOptionDisplayName
};


/**
 Reference Type for comment
 */
typedef NS_ENUM(NSUInteger, EkoCommentReferenceType) {
    EkoCommentReferenceTypePost,
    EkoCommentReferenceTypeContent
};

/**
 Target Type for post
 */
typedef NS_ENUM(NSUInteger, EkoPostTargetType) {
    EkoPostTargetTypeUser,
    EkoPostTargetTypeCommunity
};

/**
 Request Query options. 
 */
typedef NS_ENUM(NSInteger, EkoQueryOption) {
    /**
     Query only deleted results
     */
    EkoQueryOptionDeleted,
    /**
     Query only non deleted results
     */
    EkoQueryOptionNotDeleted,
    /**
     Query both deleted & non deleted results
     */
    EkoQueryOptionAll
};

/**
 Default Sort Option
 */
typedef NS_ENUM(NSInteger, EkoSortBy) {
    EkoSortByFirstCreated,
    EkoSortByLastCreated,
};

/**
 Default Ordering Option
 */
typedef NS_ENUM(NSInteger, EkoOrderBy) {
    EkoOrderByAscending,
    EkoOrderByDescending
};

typedef NS_ENUM(NSInteger, EkoCommunityType) {
    // Default community
    EkoCommunityTypeNormal = 0,
    // Trending community
    EkoCommunityTypeTrending = 1,
    // Recommended community
    EkoCommunityTypeRecommended = 2,
};

#endif /* EkoEnums_h */
