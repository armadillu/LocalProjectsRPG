//
//  QuestionViewController.m
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization

		//list all font
//		for (NSString *family in [UIFont familyNames]) {
//			NSLog(@"%@", [UIFont fontNamesForFamilyName:family]);
//		}
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated;{
	UIFont * bigTitle = [UIFont fontWithName:@"Capita-Light" size:30];
	UIFont * smallFont = [UIFont fontWithName:@"Capita-Light" size:28];
	[question setFont:bigTitle];

	[yesButton.titleLabel setFont:smallFont];
	[noButton.titleLabel setFont:smallFont];

	[yesButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0)];
	[noButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0)];


	[yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	[yesButton setBackgroundImage:[UIImage imageNamed:@"yesButton"] forState:UIControlStateNormal];
	[noButton setBackgroundImage:[UIImage imageNamed:@"noButton"] forState:UIControlStateNormal];

	NSString * firstQuestion = [[AppData get] nextQuestion];
	if (firstQuestion){
		question.text = firstQuestion;
	}

	roundOver = false;
}


/////////////////////////////////////////////////////////////////////////////////////

int c = 0;

- (IBAction)pressedYES:(id)sender {
	((UIButton*)sender).highlighted = NO;
	//give button time to update its view
	[self performSelector:@selector(showQuestion) withObject:nil afterDelay:0.0];
	c++;
}


- (IBAction)pressedNO:(id)sender {
	((UIButton*)sender).highlighted = NO;
	//give button time to update its view
	[self performSelector:@selector(showQuestion) withObject:nil afterDelay:0.0];
	c++;
}


-(void)showQuestion{

	[UIView transitionWithView:wrapper
					  duration:0.5
					   options:UIViewAnimationOptionTransitionFlipFromRight
					animations: ^{
						NSString * nextQuestion = [[AppData get] nextQuestion];
						if (nextQuestion){
							[question setText:nextQuestion];
						}else{
							roundOver = true;
							[question setText:@"Round is Over!"];
							yesButton.hidden = true;
							noButton.hidden = true;
						}
					}
					completion:^(BOOL finished){
						if(roundOver){
							[self.delegate performSelector:@selector(questionViewControllerDidFinish:) withObject:self afterDelay:1.0];
							//[self.delegate questionViewControllerDidFinish:self]; //finish round!
						}
					}];
}


- (IBAction)pressedDone:(id)sender {
	[self.delegate questionViewControllerDidFinish:self];
}


/////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
