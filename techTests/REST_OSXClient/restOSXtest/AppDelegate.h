//
//  AppDelegate.h
//  restOSXtest
//
//  Created by Oriol Ferrer Mesià on 21/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Wrapper.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{

	Wrapper * wrap;

	IBOutlet NSTableView* questionsTable;
	IBOutlet NSForm * form;
	IBOutlet NSScrollView * scroll;
	
}

@property (assign) IBOutlet NSWindow *window;

@end
