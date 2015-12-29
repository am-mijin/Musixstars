//
//  ParseAPI.h
//  ilovestage
//
//  Created by Mijin Cho on 16/05/2015.
//  Copyright (c) 2015 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"
@interface ParseAPI : NSObject

+ (void)orderPerkInBackground:(id)perk order:(NSMutableDictionary*)orderinfo block:(void (^)(NSString* bookingid, NSError *error))completionBlock;
+ (void)likeVideoInBackground:(id)video block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikePhotoInBackground:(id)video block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)addDefaultPerks:(NSMutableDictionary*)perks block:(void (^)(NSMutableArray* newperks, NSError *error))completionBlock;

+ (void)addNewPerkInBackground:(NSMutableDictionary*)perk block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)editPerkInBackground:(NSMutableDictionary*)perk block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)addNewVideoInBackground:(NSMutableDictionary*)video block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)addBankAccount:(id)info block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
@end
