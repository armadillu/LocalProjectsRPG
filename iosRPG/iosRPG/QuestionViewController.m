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
//		for (NSString *family in [UIFont familyNames]) {
//			NSLog(@"%@", [UIFont fontNamesForFamilyName:family]);
//		}
	}
	return self;
}

-(void)setupGraphs{
	NSArray * colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor],
						[UIColor yellowColor], [UIColor orangeColor], nil];

	layers = [[NSMutableArray alloc] initWithCapacity:6];
	int n = [[AppData get] numTokens];
	int y = 20;
	int h = 15;
	int spacing = 2;
	graphics.alpha = 0;
	for (int i = 0; i < n; i++) {
		UIColor * col = [colors objectAtIndex:i];
		CGRect r = CGRectMake(self.view.frame.size.width/2, y, 0, h);
		myGraphView * view = [[myGraphView alloc] initWithFrame:r];
		y+= h + spacing;
		view.backgroundColor = col;
		[graphics addSubview:view];
		[layers addObject:view];
		UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, -19, 400, 50)];
		lab.backgroundColor = [UIColor clearColor];
		lab.font = [UIFont fontWithName:@"Capita-Light" size:13];
		lab.text = @"token";
		lab.opaque = false;
		lab.textColor = [UIColor whiteColor];
		[view addSubview:lab];
	}
}


- (void)viewWillAppear:(BOOL)animated;{

	[self setupGraphs];

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

-(void)updateGraph{

	animating = true;
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:GRAPH_ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(graphAnimEnded:finished:context:)];
	for (myGraphView* view in layers) {
		CGRect r = view.frame;
		r.size.width += 10 * [[AppData get] scoreForToken:0];
		[view setFrame:r];
	}
    [UIView commitAnimations];

	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:FADE_ANIMATION_DURATION];
	yesButton.alpha = 0;
	noButton.alpha = 0;
	graphics.alpha = 1;
    [UIView commitAnimations];

}

-(void)graphAnimEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	//finally flip and show new question
	//give button time to update its view
	[self performSelector:@selector(showQuestion) withObject:nil afterDelay:0.0];

}


- (IBAction)pressedYES:(id)sender {
	if (!animating){
		((UIButton*)sender).highlighted = NO;
		[[AppData get] PlayYesButtonSound];
		[self updateGraph];
	}
}


- (IBAction)pressedNO:(id)sender {
	if (!animating){
		((UIButton*)sender).highlighted = NO;
		[[AppData get] PlayNoButtonSound];
		[self updateGraph];
	}
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
							[UIView beginAnimations:nil context:nil];
							[UIView setAnimationDuration:GRAPH_ANIMATION_DURATION];
							[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
							graphics.alpha = 0;
							[UIView commitAnimations];
							[self.delegate performSelector:@selector(questionViewControllerDidFinish:) withObject:self afterDelay:1.0];
						}else{
							[UIView beginAnimations:nil context:nil];
							[UIView setAnimationDuration:BUTTON_FADE_ANIMATION_DURATION];
							yesButton.alpha = 1;
							noButton.alpha = 1;
							//graphics.alpha = 0;
							[UIView setAnimationDelegate:self];
							[UIView setAnimationDidStopSelector:@selector(buttonAnimEnded:finished:context:)];
							[UIView commitAnimations];
						}
					}];
}

-(void)buttonAnimEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	animating = false;
}


- (IBAction)pressedDone:(id)sender {
	[self.delegate questionViewControllerDidFinish:self];
}


/////////////////////////////////////////////////////////////////////////////////////


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end