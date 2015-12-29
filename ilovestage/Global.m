//
//  Global.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "Global.h"
#import "AppLinkCenter.h"

@implementation Global


static Global *instance = nil;
+(Global*)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

-(id)init
{
    if(self = [super init])
    {
        _cachedData = [NSMutableDictionary new];
        _events = [NSMutableArray new];
        _allevents = [NSMutableArray new];
        _feeds =[NSMutableArray new];
        
    }
    return self;
}

+(id)Global {
    return [[self alloc]init];
}

-(void)reset{
    _curMenu = 0;
    
    
}
@end
