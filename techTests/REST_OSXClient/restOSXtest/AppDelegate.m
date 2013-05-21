//
//  AppDelegate.m
//  restOSXtest
//
//  Created by Oriol Ferrer Mesià on 21/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc {
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application

	wrap = [[[Wrapper alloc] init] autorelease];
	wrap.delegate = self;
	wrap.asynchronous = FALSE;

	[wrap sendRequestTo:[NSURL URLWithString:@"http://localhost:5000/questions"]
			  usingVerb:@"GET"
		 withParameters:nil
	 ];
	NSString * resp = [wrap responseAsText];
	NSLog(@"resp1: %@", resp);
	NSError * error;
	id jsonObj = [NSJSONSerialization JSONObjectWithData:[resp dataUsingEncoding:NSUTF8StringEncoding]
															   options:kNilOptions
															   error:&error];
	
	NSLog(@"%@", jsonObj);
	//NSLog(@"%@", [jsonDict allKeys]);
	if ([jsonObj isKindOfClass:[NSArray class]]){ // got a NSArray
		for	(id obj in jsonObj){
			NSLog(@"question: %@", [obj objectForKey:@"question"]);
			NSLog(@"questionID: %@", [obj objectForKey:@"questionID"]);
		}
	}else{ //got a NSDict

	}


	//[[scroll contentView] setFrame: NSInsetRect([[scroll contentView] frame], 20, 20 )];

	[form setScrollable:true];
	for(int i = 0; i < 5; i++){
		[form addColumn];
	}
	[form sizeToCells];

	for(int i = 0; i < [form numberOfRows]; i++){
		for(int j = 0; j < [form numberOfColumns]; j++){
			NSCell * cell = [form cellAtRow:i column:j] ;
			 [cell setTitle:[NSString stringWithFormat:@"%d, %d", i, j]];
			if (i == 2) [cell setEnabled:false];
		}
	}
	//[[form cellAtRow:0 column:0] setEnabled:false];
//	[form setNeedsDisplay:YES];
	


//	[wrap sendRequestTo:[NSURL URLWithString:@"http://localhost:5000/questions"]
//			  usingVerb:@"POST"
//		 withParameters:[NSDictionary dictionaryWithObject:@"my cocoa questions?" forKey:@"question"]
//	 ];
//
//	NSLog(@"resp2: %@", [wrap responseAsText]);
}

#pragma mark WrapperDelegate methods - if async!

- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data {
	NSLog(@"wrapper didRetrieveData: %@", [wrapper responseAsText]);
}

- (void)wrapperHasBadCredentials:(Wrapper *)wrapper {
	NSLog(@"wrapper Bad Credentials");
}

- (void)wrapper:(Wrapper *)wrapper didCreateResourceAtURL:(NSString *)url {
	NSLog(@"wrapperdidCreateResourceAtURL @ %@", url);
}

- (void)wrapper:(Wrapper *)wrapper didFailWithError:(NSError *)error {
	NSLog(@"wrapper failed with error %@", [error userInfo]);
}

- (void)wrapper:(Wrapper *)wrapper didReceiveStatusCode:(int)statusCode {
	NSLog(@"wrapper didReceiveStatusCode %d", statusCode);
}


#pragma mark TableView

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row{
	
	if ([[tableColumn identifier] isEqualTo: @"icon"]){
	}
	return nil;
}


- (int)numberOfRowsInTableView:(NSTableView *)tableView{
	return 3;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;{

	return NO;
}


- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
	return YES;
}


@end
