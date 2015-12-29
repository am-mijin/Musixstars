//
//  Global.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "Cache.h"

NSString *const kVideoAttributesIsSponsoredByCurrentUserKey = @"isSponsoredByCurrentUser";
NSString *const kVideoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kVideoAttributesLikeCountKey            = @"likeCount";
NSString *const kVideotoAttributesLikersKey               = @"likers";
@implementation Cache

+ (id)sharedInstance {
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
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addPerk:(NSDictionary *)perk of:(PFObject*)video  {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                perk,@"perk",
                                [NSNumber numberWithBool:YES],kVideoAttributesIsSponsoredByCurrentUserKey,
                                [NSDate date], @"date",
                                video,@"video",
                                nil];
    NSLog(@"attributes %@",attributes);
    [self setAttributes:attributes forVideo:video];
}

- (void)setAttributesForVideo:(PFObject *)video likeCount:(int)likeCount  {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:likeCount],@"likeCount",
                                [NSNumber numberWithBool:YES],kVideoAttributesIsLikedByCurrentUserKey,
                                [NSDate date], @"date",
                                video,@"video",
                                nil];
    NSLog(@"attributes %@",attributes);
    [self setAttributes:attributes forVideo:video];
}

- (NSDictionary *)attributesForVideo:(PFObject *)video {
    NSString *key = [self keyForVideo:video];
    return [_data objectForKey:key];
}

- (BOOL)isVideoSponsordByCurrentUser:(PFObject *)video {
    NSDictionary *attributes = [self attributesForVideo:video];
    if (attributes) {
        return [[attributes objectForKey:kVideoAttributesIsSponsoredByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (BOOL)isVideoLikedByCurrentUser:(PFObject *)video {
    NSDictionary *attributes = [self attributesForVideo:video];
    if (attributes) {
        return [[attributes objectForKey:kVideoAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (void)setAttributes:(NSDictionary *)attributes forVideo:(PFObject *)video {
    NSString *key = [self keyForVideo:video];
    [_data setObject:attributes forKey:key];
   
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [_data setObject:attributes forKey:key];
 
}

- (NSString *)keyForVideo:(PFObject *)video {
    return [NSString stringWithFormat:@"video_%@", [video objectId]];
}

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

- (void)removeVideo:(PFObject *)video {
    NSString *key = [self keyForVideo:video];
    [_data removeObjectForKey:key];
}

@end
