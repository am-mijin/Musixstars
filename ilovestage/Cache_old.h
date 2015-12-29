//
//  PAPCache.h
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject

+ (id)sharedCache;

- (void)clear;
//- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;

- (void)setAttributesForVideo:(PFObject *)video likeCount:(int)likeCount;
- (NSDictionary *)attributesForVideo:(PFObject *)video;
- (NSNumber *)likeCountForVideo:(PFObject *)video;
- (NSArray *)likersForVideo:(PFObject *)video;
- (void)setVideoIsLikedByCurrentUser:(PFObject *)video liked:(BOOL)liked;
- (BOOL)isVideoLikedByCurrentUser:(PFObject *)video;
- (void)incrementLikerCountForPhoto:(PFObject *)video;
- (void)decrementLikerCountForPhoto:(PFObject *)video;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSNumber *)videoCountForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setVideoCount:(NSNumber *)count user:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;
- (void)removeVideo:(PFObject *)video;
- (int)activityCount;
- (NSArray *)allKeys;
- (NSMutableDictionary *)cachedData ;

- (void )setData:(NSMutableDictionary *)data;
@end
