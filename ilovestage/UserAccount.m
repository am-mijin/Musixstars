//
//  UserAccount.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount
static UserAccount *instance = nil;

//@synthesize sessionId,subscriptionName,subscriptionExp,password,firstname,lastname,email,teamName,provider,provider_uid,teamId;

#pragma mark -
#pragma mark Singleton

+(UserAccount*)sharedInstance 
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
        
        _perks = [NSMutableArray new];
        _activities = [NSMutableArray new];
        _contents=[NSMutableArray new];
	}
	return self;
}

+(id)userAccount {
	
	return [[self alloc]init];
}
/*
-(void)setValue:(NSDictionary*) user{
    
     _role =[user objectForKey:@"role"];
    if([[user objectForKey:@"lastname"] isEqualToString:@"Administrator"])
    {
        _role = @"admin";
    }
    
    _userid =[user objectForKey:@"_id"];
    _email =[[[user objectForKey:@"strategies"] objectForKey:@"local" ] objectForKey:@"email"];
    _password =[[[user objectForKey:@"strategies"] objectForKey:@"local" ] objectForKey:@"password"];
    if([user objectForKey:@"country"])
        _country =[user objectForKey:@"country"];
    
    if([[user objectForKey:@"phone"] objectForKey:@"countrycallingcode"])
        _countrycallingcode  =[[[user objectForKey:@"phone"] objectForKey:@"countrycallingcode"] stringByReplacingOccurrencesOfString:@"+" withString:@""] ;
    
    _phonenumber =[[user objectForKey:@"phone"] objectForKey:@"number"];
    _lastname = [user objectForKey:@"lastname"];
    _firstname = [user objectForKey:@"firstname"];
    _angency_name = [user objectForKey:@"angency_name"];
    _address =[user objectForKey:@"address"];
    
    NSLog(@"_password %@",_password);
}
*/

-(void)setUser:(PFUser*)user
{

    _role = [user objectForKey:@"role"];
    
    if([[user objectForKey:@"lastname"] isEqualToString:@"Administrator"])
    {
        _role = @"admin";
    }
    
    _email =[user objectForKey:@"email"];
    
    
    if([_role isEqualToString:@"artist"])
    {
        
        _bankname = [user objectForKey:@"bankName"];
        _sortcode = [user objectForKey:@"sortCode"];
        _accountnumber = [user objectForKey:@"accountNumber"];
        _accountname = [user objectForKey:@"accountName"];
        
    }
    _firstname = [user objectForKey:@"firstname"];
    _lastname = [user objectForKey:@"lastname"];
    _userid = user.objectId;
}

-(void)reset{
    
    _userid= @"";
    _role= @"";
    _password = @"";
    _firstname = @"";
	_lastname = @"";
    _userid = @"";
    _provider = @"";
    _provider_uid = @"";
    _phonenumber = @"";
    _address = @"";
    _angency_name = @"";
    _loggedin = NO;
}

@end

