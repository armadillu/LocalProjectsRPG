//
//  MainViewController.h
//  aaa
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "FlipsideViewController.h"
#import "QuestionViewController.h"
#import "Constants.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, QuestionViewControllerDelegate>{

}

- (IBAction)showInfo:(id)sender;


@end
