//
//  JSONCategories.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "JSONCategories.h"

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: urlAddress] ];
    id result = nil;
    __autoreleasing NSError* error = nil;
    if(data == nil)
    {
        result = nil;
    }
    else 
    {
        
        result = [NSJSONSerialization JSONObjectWithData:data 
                                                 options:kNilOptions error:&error];
    }
 
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self 
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;    
}
@end
