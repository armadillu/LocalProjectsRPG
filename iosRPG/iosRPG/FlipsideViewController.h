//
//  FlipsideViewController.h
//  aaa
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import <UIKit/UIKit.h>

@class       FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController {

	IBOutlet UILabel *	info;
	IBOutlet UILabel *	subInfo;
	IBOutlet UIButton *	okButton;
}

@property (assign, nonatomic) id <FlipsideViewControllerDelegate>       delegate;

- (IBAction)done:(id)sender;

@end
