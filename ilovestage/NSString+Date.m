//
//  NSString+Date.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "NSString+Date.h"


@implementation NSString(Date)
+ (NSDateFormatter*)stringDateFormatter
{
   static NSDateFormatter* formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"EEE MMM dd"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
       
    }
    return formatter;
}

+ (NSDate*)stringDateFromString:(NSString*)string
{
    return [[NSString stringDateFormatter] dateFromString:string];
}

+ (NSString*)stringDateFromDate:(NSDate*)date
{
    return [[NSString stringDateFormatter] stringFromDate:date];
}
@end
