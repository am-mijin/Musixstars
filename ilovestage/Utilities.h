//
//  Utilities.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "consts.h"
@interface Utilities : NSObject


+ (NSString *)getDateString:(int)seconds format:(int)format;

+ (int) addTimezone;
+(NSString*)lookupDialCodes:(NSString*)countrycode;

+(NSString*)getShowReference:(NSString*)showid;
@end
