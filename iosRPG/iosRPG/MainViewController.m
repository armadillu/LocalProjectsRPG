//
//  MainViewController.m
//  aaa
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated;{

	UIFont * bigTitle = [UIFont fontWithName:@"Capita-Light" size:30];
	UIFont * smallFont = [UIFont fontWithName:@"Capita-Light" size:28];
	[startButton.titleLabel setFont:smallFont];
	[startButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0)];
	[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[startButton setBackgroundImage:[UIImage imageNamed:@"startButton"] forState:UIControlStateNormal];
	[titleLabel setFont:bigTitle];

}

- (void)viewDidLoad{

	[super viewDidLoad];
	//question.alpha = 0;

}


- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)questionViewControllerDidFinish:(QuestionViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)startQuestions:(id)sender{

	[[AppData get] startGame];
	QuestionViewController *controller = [[[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil] autorelease];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:controller animated:YES completion:nil];

}


- (IBAction)showInfo:(id)sender{

	FlipsideViewController *controller = [[[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil] autorelease];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:controller animated:YES completion:nil];
}

@end
