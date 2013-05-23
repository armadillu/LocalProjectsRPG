//
//  QuestionViewController.h
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "AppData.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "myGraphView.h"

//////////////////////////////////////////////////
// define protocol for delegate
//////////////////////////////////////////////////
@class QuestionViewController;

@protocol QuestionViewControllerDelegate
- (void)questionViewControllerDidFinish:(QuestionViewController *)controller;
@end


//////////////////////////////////////////////////
// actual class definition
//////////////////////////////////////////////////
@interface QuestionViewController : UIViewController {

	IBOutlet UILabel * question;
	IBOutlet UIButton * yesButton;
	IBOutlet UIButton * noButton;
	IBOutlet UIView * wrapper;
	IBOutlet UIView * graphics;

	BOOL roundOver;
	NSMutableArray * bars;
	NSMutableArray * staticLabels;
	NSMutableArray * animatedLabels;
	NSArray * colors;
	bool animating;
	int * tokenScores;
}

@property (assign, nonatomic) id <QuestionViewControllerDelegate>       delegate;


- (IBAction)pressedDone:(id)sender;
- (IBAction)pressedYES:(id)sender;
- (IBAction)pressedNO:(id)sender;

@end
