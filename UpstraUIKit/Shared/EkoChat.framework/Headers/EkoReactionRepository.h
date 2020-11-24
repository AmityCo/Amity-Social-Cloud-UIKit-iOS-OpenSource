//
//  EkoReactionRepository.h
//  EkoChat
//
//  Created by Nishan Niraula on 7/30/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "EkoReaction.h"
#import "EkoCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoReactionRepository : NSObject

/**
 The client context used to create the instance
 */
@property (strong, readonly, nonatomic) EkoClient *client;

/**
 Designated Initializer
 @param client A valid EkoClient instance
 */
- (instancetype) initWithClient: (EkoClient *)client;

/**
 Add reaction to the content.
 
 @param reaction: Name of the reaction
 @param referenceId: Id for the content. Example: postId for post, commentId for comment & so on.
 @param referenceType: Type of content. If you are adding reaction to post, reference type would be of type .post (swift) or EkoReactionReferenceTypePost (Objc)
 @param completion: Closure to be executed after this operation is complete.
 */
- (void)addReaction: (NSString *)reaction referenceId:(NSString *)contentId referenceType:(EkoReactionReferenceType)type completion: (EkoRequestCompletion _Nullable)completion;

/**
Remove reaction from the content.

@param reaction: Name of the reaction
@param referenceId: Id for the content. Example: postId for post, commentId for comment & so on.
@param referenceType: Type of content. If you are adding reaction to post, reference type would be of type .post (swift) or EkoReactionReferenceTypePost (Objc)
@param completion: Closure to be executed after this operation is complete.
*/
- (void)removeReaction: (NSString *)reaction referenceId:(NSString *)contentId referenceType:(EkoReactionReferenceType)type completion: (EkoRequestCompletion _Nullable)completion;

/**
 Get the collection of reactions for particular content for provided reaction name.
 
 @param id: Id of the post, comment or message
 @param referenceType: Type of content. If you are adding reaction to post, reference type would be of type .post (swift) or EkoReactionReferenceTypePost (Objc)
 @param reactionName: Name of the reaction
 @return EkoCollection of EkoReaction object. Observe the changes to get results.
 */
- (EkoCollection<EkoReaction *> *)getReactions:(NSString *)referenceId referenceType:(EkoReactionReferenceType)type reactionName:(NSString *)reactionName;

/**
Get all  reactions for particular post

@param id: Id of the post, comment or message
@param referenceType: Type of content. If you are adding reaction to post, reference type would be of type .post (swift) or EkoReactionReferenceTypePost (Objc)
@return EkoCollection of EkoReaction object. Observe the changes to get results.
*/
- (EkoCollection<EkoReaction *> *)getAllReactions:(NSString *)referenceId referenceType:(EkoReactionReferenceType)type;


// Disable object creation
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
