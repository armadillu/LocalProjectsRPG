//
//  FlipsideViewController.m
//  aaa
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController


- (void)viewWillAppear:(BOOL)animated;{

	UIFont * bigTitle = [UIFont fontWithName:@"Capita-Light" size:35];
	UIFont * smallFont = [UIFont fontWithName:@"Capita-Light" size:16];

	[info setFont:bigTitle];
	[subInfo setFont:smallFont];
	subInfo.alpha = 0.5;

	[okButton.titleLabel setFont:[UIFont fontWithName:@"Capita-Light" size:28]];
	[okButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0)];
	[okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[okButton setBackgroundImage:[UIImage imageNamed:@"yesButton"] forState:UIControlStateNormal];

}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
