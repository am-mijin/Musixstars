//
//  PAPCache.m
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "Cache.h"


// keys

NSString *const kVideoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kVideoAttributesLikeCountKey            = @"likeCount";
NSString *const kVideotoAttributesLikersKey               = @"likers";

@interface Cache()
@property (nonatomic, strong) NSMutableDictionary *cache;
- (void)setAttributes:(NSDictionary *)attributes forVideo:(PFObject *)video;
@end

@implementation Cache
@synthesize cache;

#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - PAPCache

- (void)clear {
    [self.cache removeAllObjects];
}

- (int)activityCount {
    return [self.cache count];
}

- (void)setAttributesForVideo:(PFObject *)video likeCount:(int)likeCount  {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [NSNumber numberWithBool:YES],kVideoAttributesIsLikedByCurrentUserKey,
                                [NSNumber numberWithInt:likeCount],@"likeCount",
                                [NSDate date], @"date",
                                video,@"video",
                                nil];
    
    [self setAttributes:attributes forVideo:video];
}


- (void)setAttributesForVideo:(PFObject *)video likers:(NSArray *)likers likedByCurrentUser:(BOOL)likedByCurrentUser {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:likedByCurrentUser],kVideoAttributesIsLikedByCurrentUserKey,
                                      @([likers count]),@"likeCount",
                                      likers,@"likers",
                                      nil];
    [self setAttributes:attributes forVideo:video];
}

- (NSDictionary *)attributesForVideo:(PFObject *)video {
    NSString *key = [self keyForVideo:video];
    return [self.cache objectForKey:key];
}

- (NSNumber *)likeCountForVideo:(PFObject *)video {
    NSDictionary *attributes = [self attributesForVideo:video];
    if (attributes) {
        return [attributes objectForKey:kVideoAttributesLikeCountKey];
    }

    return [NSNumber numberWithInt:0];
}


- (NSArray *)likersForVideo:(PFObject *)video {
    NSDictionary *attributes = [self attributesForVideo:video];
    if (attributes) {
        return [attributes objectForKey:kVideoAttributesIsLikedByCurrentUserKey];
    }
    
    return [NSArray array];
}

- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForVideo:photo]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:kVideoAttributesIsLikedByCurrentUserKey];
    [self setAttributes:attributes forVideo:photo];
}

- (BOOL)isVideoLikedByCurrentUser:(PFObject *)video {
    NSDictionary *attributes = [self attributesForVideo:video];
    if (attributes) {
        return [[attributes objectForKey:kVideoAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (void)incrementLikerCountForPhoto:(PFObject *)video {
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForVideo:video] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForVideo:video]];
    [attributes setObject:likerCount forKey:kVideoAttributesLikeCountKey];
    [self setAttributes:attributes forVideo:video];
}

- (void)decrementLikerCountForPhoto:(PFObject *)video {
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForVideo:video] intValue] - 1];
    if ([likerCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForVideo:video]];
    [attributes setObject:likerCount forKey:kVideoAttributesLikeCountKey];
    [self setAttributes:attributes forVideo:video];
}



- (void)setAttributesForUser:(PFUser *)user videoCount:(NSNumber *)count followedByCurrentUser:(BOOL)following {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count,@"videoCount",
                                [NSNumber numberWithBool:following],@"isFollowedByCurrentUser",
                                nil];
    [self setAttributes:attributes forUser:user];
}

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSNumber *)videoCountForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *videoCount = [attributes objectForKey:@"videoCount"];
        if (videoCount) {
            return videoCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)followStatusForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:@"isFollowedByCurrentUser"];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }

    return NO;
}

- (void)setVideoCount:(NSNumber *)count user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:@"videoCount"];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:@"isFollowedByCurrentUser"];
    [self setAttributes:attributes forUser:user];
}

#pragma mark - ()
- (void )setData:(NSMutableDictionary *)data {
    self.cache = [data mutableCopy];
}

- (NSMutableDictionary *)cachedData {
    return self.cache;
}

- (NSArray *)allKeys {
    return [self.cache allKeys];
}

- (void)removeVideo:(PFObject *)video {
    NSString *key = [self keyForVideo:video];
    [self.cache removeObjectForKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forVideo:(PFObject *)video {
    NSString *key = [self keyForVideo:video];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];    
}

- (NSString *)keyForVideo:(PFObject *)video {
    return [NSString stringWithFormat:@"video_%@", [video objectId]];
}

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

@end
