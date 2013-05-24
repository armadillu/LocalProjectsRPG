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
	[startButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 2.0, 0.0)];
	[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[startButton setBackgroundImage:[UIImage imageNamed:@"startButton"] forState:UIControlStateNormal];
	[titleLabel setFont:bigTitle];
	[activity stopAnimating];
}


#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)questionViewControllerDidFinish:(QuestionViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(void)showQuestionsController{
	QuestionViewController *controller = [[[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil] autorelease];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)startQuestions:(id)sender{
//	NSString * web = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://uri.cat"] encoding:nil error:nil];
//	NSLog(@"web: %@",web);
	[[AppData get] PlayStartButtonSound];
	[activity startAnimating];
	[[AppData get] performSelectorInBackground:@selector(fetchQuestions:) withObject:self];
}


-(void)gotDataSoStartGame{
	[activity stopAnimating];
	[[AppData get] startGame];
	[self showQuestionsController];
}

-(void)noDataSoNoGame:(NSString*)why{
	[activity stopAnimating];
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Can't Obtain Fresh Questions!" message:[NSString stringWithFormat:@"%@\n\nThe game will use predefined questions instead. Sorry!", why] cancelButtonTitle:@"damn!" otherButtonTitles:nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
		[self showQuestionsController];
	}];

}

- (IBAction)showInfo:(id)sender{
	FlipsideViewController *controller = [[[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil] autorelease];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:controller animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}


@end
