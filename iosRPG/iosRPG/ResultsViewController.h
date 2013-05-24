//
//  ResultsViewController.h
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 24/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "myGraphView.h"
#include "Constants.h"

@class ResultsViewController;

@protocol ResultsViewControllerDelegate
- (void)resultViewControllerDidFinish:(ResultsViewController *)controller;
@end


@interface ResultsViewController : UIViewController{

	IBOutlet UIView * graphics;
	IBOutlet UIView * zeroBar;
	IBOutlet UIView * titlesBar;
	IBOutlet UIButton * okButton;
	IBOutlet UILabel * titleLabel;
	float barHeightMult;
}

@property (assign, nonatomic) id <ResultsViewControllerDelegate>       delegate;


- (IBAction)pressedOK:(id)sender;

@end
