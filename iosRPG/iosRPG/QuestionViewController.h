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
#import "ResultsViewController.h"

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
@interface QuestionViewController : UIViewController <ResultsViewControllerDelegate>{

	IBOutlet UITextView * question;
	IBOutlet UIButton * yesButton;
	IBOutlet UIButton * noButton;
	IBOutlet UIView * wrapper;
	IBOutlet UIView * graphics;

	BOOL roundOver;

	myGraphView * bar;
	UILabel * staticLabel;
	UILabel * animatedLabel;
	int currentToken; //this drives the tokens animation

	NSArray * colors;
	bool animating;
	int * tokenScores; // global scores for this game
	NSMutableArray * scores;//scores for this question

	bool pressedYes;
	bool firstTime;
	CGRect originalQuestionFrame;
	CGRect originalYesFrame;
	CGRect originalNoFrame;
}

@property (assign, nonatomic) id <QuestionViewControllerDelegate>       delegate;

-(NSArray*)getColors;
-(int*)getScores;
- (IBAction)pressedYES:(id)sender;
- (IBAction)pressedNO:(id)sender;

@end
