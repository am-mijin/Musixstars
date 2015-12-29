//
//  JSONCategories.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress;
-(NSData*)toJSON;
@end