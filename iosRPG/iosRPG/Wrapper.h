//
//  Wrapper.h
//  WrapperTest
//
//  Created by Adrian on 10/18/08.
//  Copyright 2008 Adrian Kosmaczewski. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "WrapperDelegate.h"

@interface Wrapper : NSObject 

@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic) BOOL asynchronous;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) id<WrapperDelegate> delegate; // Do not retain delegates!

- (NSError*)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withParameters:(NSDictionary *)parameters;
- (void)uploadData:(NSData *)data toURL:(NSURL *)url;
- (void)cancelConnection;

//oriol modified those, so that once called, the response is yours, and
//erased from the Wrapper object (so that it doesnt accumulate over time)
- (NSDictionary *)responseAsPropertyList;
- (NSString *)responseAsText;

@end

