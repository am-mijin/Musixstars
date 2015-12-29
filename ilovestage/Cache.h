//
//  Global.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Cache : NSObject
@property (nonatomic, strong) NSMutableDictionary *data;

+(Cache*)sharedInstance;
- (void)removeVideo:(PFObject *)video;
- (void)setAttributesForVideo:(PFObject *)video likeCount:(int)likeCount;


- (void)addPerk:(NSDictionary *)perk of:(PFObject*)video;
- (BOOL)isVideoLikedByCurrentUser:(PFObject *)video;
@end;
