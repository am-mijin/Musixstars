//
//  AppLinkCenter.h.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Consts.h"

#define UserLogin			@"userLogin"
#define UserRegistration	@"userRegistration"
#define SendMailRequest	@"sendMailRequest"
#define PostAd	@"postAd"


@protocol RequestDelegate ;
@interface AppLinkCenter : NSObject
{
    NSString*             _url;
    NSString*             _httpMethod;
    NSMutableDictionary*  _params;
    NSURLConnection*      _connection;
    NSMutableData*        _responseText;
    
    NSError*              _error;
    
    BOOL parserDidFinish;
}
//@property(nonatomic,assign) id<RequestDelegate> delegate;

/**
 * The URL which will be contacted to execute the request.
 */
@property(nonatomic,copy) NSString* url;

/**
 * The API method which will be called.
 */
@property(nonatomic,copy) NSString* httpMethod;
@property (nonatomic, weak) id<RequestDelegate> delegate;

/**
 * The dictionary of parameters to pass to the method.
 *
 * These values in the dictionary will be converted to strings using the
 * standard Objective-C object-to-string conversion facilities.
 */
@property(nonatomic,retain) NSMutableDictionary* params;
@property(nonatomic,retain) NSURLConnection*  connection;
@property(nonatomic,retain) NSMutableData* responseText;
@property(nonatomic,strong) NSArray* videourls;


/**
 * Error returned by the server in case of request's failure (or nil otherwise).
 */
@property(nonatomic,retain) NSError* error;
+ (AppLinkCenter*)requestWithPath:(NSString *)Path
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id <RequestDelegate>)delegate;
+(void)getHighlights:(NSString*)videoid quater:(NSString*)quater;

@end

////////////////////////////////////////////////////////////////////////////////

/*
 *Your application should implement this delegate
 */
@protocol RequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(AppLinkCenter *)request;

/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(AppLinkCenter *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(AppLinkCenter *)request didFailWithError:(NSError *)error;

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(AppLinkCenter *)request didLoad:(id)result;

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(AppLinkCenter *)request didLoadRawResponse:(NSData *)data;

- (void) paerDidFail:(AppLinkCenter *)theConnection;
- (void) parserDidFinish:(AppLinkCenter *)theConnection;
@end
