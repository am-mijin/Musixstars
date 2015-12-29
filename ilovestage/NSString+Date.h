//
//  NSString+Date.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)
+ (NSDate*)stringDateFromString:(NSString*)string;
+ (NSString*)stringDateFromDate:(NSDate*)date;
@end