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
