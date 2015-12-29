//
//  AppLinkCenter.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "AppLinkCenter.h"
#import "config.h"
#import "Utilities.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
///////////////////////////////////////////////////////////////////////////////////////////////////
// global


static NSString* kUserAgent = @"ilovestage";
static NSString* kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";


static NSString *requestFinishedKeyPath = @"state";
//static void *finishedContext = @"finishedContext";
//static const int kGeneralErrorCode = 10000;
//static const int kRESTAPIAccessTokenErrorCode = 190;

static const NSTimeInterval kTimeoutInterval = 30.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation AppLinkCenter

@synthesize url = _url,
            httpMethod = _httpMethod,
            params = _params,
            connection = _connection,
            responseText = _responseText,
            error = _error;
//////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (AppLinkCenter*)openUrl:(NSString *)url
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)httpMethod
             delegate:(id<RequestDelegate>)delegate {
    
    [params setValue:@"json" forKey:@"format"];
    
    
    AppLinkCenter* request = [self getRequestWithParams:params
                                               httpMethod:httpMethod
                                                 delegate:delegate
                                               requestURL:url];
  
    [request connect];
    return request;
}


+ (AppLinkCenter*)requestWithPath:(NSString *)Path
                      andParams:(NSMutableDictionary *)params
                  andHttpMethod:(NSString *)httpMethod
                    andDelegate:(id <RequestDelegate>)delegate {
    
    NSString * fullURL = [kBaseURL stringByAppendingString:Path];
    return [self openUrl:fullURL
                  params:params
              httpMethod:httpMethod
                delegate:delegate];
}

+ (AppLinkCenter *)getRequestWithParams:(NSMutableDictionary *) params
                         httpMethod:(NSString *) httpMethod
                           delegate:(id<RequestDelegate>) delegate
                         requestURL:(NSString *) url {
    
    AppLinkCenter* request = [[AppLinkCenter alloc] init];
    request.delegate = delegate;
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.connection = nil;
    request.responseText = nil;
    
    return request;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

+ (NSString *)serializeURL:(NSString *)baseUrl
                    params:(NSDictionary *)params {
    return [self serializeURL:baseUrl params:params httpMethod:@"GET"];
}

/**
 * Generate get URL
 */
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]])) {
            if ([httpMethod isEqualToString:@"GET"]) {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
       
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

/**
 * Body append for POST method
 */
- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
    [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 * Generate body for POST method
 */
- (NSMutableData *)generatePostBody {
    NSMutableData *body = [NSMutableData data];
    NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]];
    
    for (id key in [_params keyEnumerator]) {
        
        if (([[_params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[_params objectForKey:key] isKindOfClass:[NSData class]])) {
            
            [dataDictionary setObject:[_params objectForKey:key] forKey:key];
            continue;
            
        }
        
        [self utfAppendBody:body
                       data:[NSString
                             stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                             key]];
        [self utfAppendBody:body data:[_params objectForKey:key]];
        
        [self utfAppendBody:body data:endLine];
    }
    
    if ([dataDictionary count] > 0) {
        for (id key in dataDictionary) {
            NSObject *dataParam = [dataDictionary objectForKey:key];
            if ([dataParam isKindOfClass:[UIImage class]]) {
                NSData* imageData = UIImagePNGRepresentation((UIImage*)dataParam);
                [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:@"Content-Type: image/png\r\n\r\n"];
                [body appendData:imageData];
            } else {
                NSAssert([dataParam isKindOfClass:[NSData class]],
                         @"dataParam must be a UIImage or NSData");
                [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:@"Content-Type: content/unknown\r\n\r\n"];
                [body appendData:(NSData*)dataParam];
            }
            [self utfAppendBody:body data:endLine];
            
        }
    }
    
    return body;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
// public



/**
 * @return boolean - whether this request is processing
 */
- (BOOL)loading {
    return !!_connection;
}
/*

-(NSString *) hashString :(NSString *) data {
    NSString * salt = @"Curtainca11";
    
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;
    
}
*/

- (void)connect {
    
    if ([_delegate respondsToSelector:@selector(requestLoading:)]) {
        [_delegate requestLoading:self];
    }
    
    
   
    /*
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString* contentType = [NSString
                                 stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:[self generatePostBody]];
    }*/
    
    /*POST in raw format */
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"Administrator", @"1c2c4ed06609421ae8a928c80069b87ba85fc14f"];
        NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
        //NSLog(@"authValue %@",authValue);

        //username is Administrator and the password is 1c2c4ed06609421ae8a928c80069b87ba85fc14f
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:_url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
//        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        [request addValue:@"0217b29aab83b80f8295fa6c72472664365ad0e0ebbba151f6c9175adc3909978729b05decf25b4d9097cd877147d501391fff59dffc427019272a26c03f1ed0" forHTTPHeaderField:@"uid"];
        
        [request setHTTPMethod:@"POST"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:_params options:0 error:&error];
        [request setHTTPBody:postData];
        /*
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:postData
                              
                              options:kNilOptions
                              error:&error];
        NSLog(@"%@",json);*/
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(error)
            {
                if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
                    [_delegate request:self didFailWithError:error];
                }
                else
                {
                    NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [error localizedDescription], @"localizedDescription",
                                               nil];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_VIDEOINFO object:@"error" userInfo:errorDict];
                }
            }
            else
            {
           
               [self handleResponseData:data];
            }
            
        }];
        
        [postDataTask resume];
        
        
    }
    else
    {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"Administrator", @"1c2c4ed06609421ae8a928c80069b87ba85fc14f"];
        NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
        //NSLog(@"authValue %@",authValue);

        
        NSString* url = [[self class] serializeURL:_url params:_params httpMethod:_httpMethod];
    
        NSMutableURLRequest* request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                            timeoutInterval:kTimeoutInterval];
        [request addValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        [request addValue:@"0217b29aab83b80f8295fa6c72472664365ad0e0ebbba151f6c9175adc3909978729b05decf25b4d9097cd877147d501391fff59dffc427019272a26c03f1ed0" forHTTPHeaderField:@"uid"];
        
        [request setHTTPMethod:self.httpMethod];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self ] ;
        
        
    }
   
}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
{
    return YES;
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    //return YES to say that we have the necessary credentials to access the requested resource
    return YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@"Administrator"
                                                                    password:@"1c2c4ed06609421ae8a928c80069b87ba85fc14f"
                                                                 persistence:NSURLCredentialPersistenceForSession];
     
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
       
    }
    else {
        NSLog(@"previous authentication failure");
    }
}

/*
 * private helper function: call the delegate function when the request
 *                          fails with error
 */
- (void)failWithError:(NSError *)error {
    NSLog(@"failWithError");
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [_delegate request:self didFailWithError:error];
    }
    else
    {
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   [error localizedDescription], @"localizedDescription",
								   nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_VIDEOINFO object:@"error" userInfo:errorDict];
    }
}

- (void)handleResponseData:(NSData *)data {

    
    NSError* error = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
    id result = json;
    
    
   
    if ([_delegate respondsToSelector:
         @selector(request:didLoadRawResponse:)]) {
        [_delegate request:self didLoadRawResponse:data];
    }
    
    if ([_delegate respondsToSelector:@selector(request:didLoad:)] ||
        [_delegate respondsToSelector:
         @selector(request:didFailWithError:)]) {
            
            
//            NSLog(@"_delegate json %@",json);
            
//            NSError* error = nil;
//            NSDictionary* json = [NSJSONSerialization
//                                  JSONObjectWithData:data
//                                  
//                                  options:kNilOptions
//                                  error:&error];
//            id result = json;
            
            if ([_delegate respondsToSelector:
                 @selector(request:didLoad:)]) {
                
                [_delegate request:self didLoad:(result)];
            }
            
//            NSLog(@"responseString %@",json );
//            
//            
//                NSString* responseString = [[NSString alloc] initWithData:data
//                encoding:NSUTF8StringEncoding];
//            
//                //SBJSON *jsonParser = [[SBJSON new] autorelease];
//                //id result = [jsonParser objectWithString:responseString];
//                
//                if ([_delegate respondsToSelector:
//                     @selector(request:didLoad:)]) {
//                    
//                    [_delegate request:self didLoad:(result)];
//                }
        }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName

   attributes: (NSDictionary *)attributeDict

{
    if([[attributeDict objectForKey:@"name"] isEqualToString:@"flv"] ) {
        
        _videourls = [[attributeDict objectForKey:@"value"] componentsSeparatedByString:@"*"];
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string

{
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

{
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
 
        //[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_VIDEOINFO object:[_videourls objectAtIndex:QUALITY_HIGH] userInfo:nil];
        
        if ([_delegate respondsToSelector:
             @selector(parserDidFinish:)]) {
            [_delegate parserDidFinish:self];
        }
  
    
    //[_delegate parserDidFinish:self];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseText = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if ([_delegate respondsToSelector:
         @selector(request:didReceiveResponse:)]) {
        [_delegate request:self didReceiveResponse:httpResponse];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseText appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self handleResponseData:_responseText];
   
    self.responseText = nil;
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self failWithError:error];
   
    self.responseText = nil;
    self.connection = nil;
}
@end
