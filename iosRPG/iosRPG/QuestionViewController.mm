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
	if(self){

		//		for (NSString *family in [UIFont familyNames]) {
		//			NSLog(@"%@", [UIFont fontNamesForFamilyName:family]);
		//		}

		animatedLabels = [[NSMutableArray alloc] initWithCapacity:6];
		staticLabels = [[NSMutableArray alloc] initWithCapacity:6];
		bars = [[NSMutableArray alloc] initWithCapacity:6];
		colors = [[NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor],
				   [UIColor yellowColor], [UIColor orangeColor], nil] retain];
//		colors = [[NSArray arrayWithObjects: [UIColor grayColor], [UIColor grayColor], [UIColor grayColor],
//				   [UIColor grayColor], [UIColor grayColor], nil] retain];

	}
	return self;
}

int y = 20; //starting y for graphs
int h = 16;	// each bar graph height
int spacing = 5; //spacing betwen bars
int initialBarW = 130; //

- (void)setupGraphs {

	int n = [[AppData get] numTokens];

	graphics.alpha = 0;
	for(int i = 0; i < n; i++){
		UIColor * col = [colors objectAtIndex:i];
		CGRect r = CGRectMake(self.view.frame.size.width / 2 - initialBarW / 2, y, initialBarW, h);
		myGraphView * view = [[myGraphView alloc] initWithFrame:r];
		y += h + spacing;
		view.backgroundColor = col;
		[graphics addSubview:view];
		[bars addObject:view];
		UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, y - 24, graphics.frame.size.width, 20)];
		lab.textAlignment = NSTextAlignmentCenter;
		lab.backgroundColor = [UIColor clearColor];
		lab.font = [UIFont fontWithName:@"Capita-Light" size:13];
		lab.text = [NSString stringWithFormat:@"%@: %d", [[AppData get] tokenAtIndex: i], tokenScores[i]];
		lab.opaque = false;
//		lab.shadowColor = [UIColor blackColor];
//		lab.shadowOffset = CGSizeMake(0,2);
		lab.layer.shadowColor = [[UIColor blackColor] CGColor];
		lab.layer.shadowOffset = CGSizeMake(0,0);
		lab.layer.shadowRadius = 1.0;
		lab.layer.shadowOpacity = 1;
		lab.textColor = [UIColor whiteColor];
		[staticLabels addObject:lab];
		[graphics addSubview:lab];
	}
}


- (void)viewWillAppear:(BOOL)animated {

	//reset scores
	int n = [[AppData get] numTokens];
	tokenScores = (int*) malloc( sizeof(int) * n);
	for(int i = 0; i < n; i++){
		tokenScores[i] = 0;
	}

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
	if(firstQuestion){
		question.text = firstQuestion;
	}

	roundOver = false;
}


/////////////////////////////////////////////////////////////////////////////////////

-(void)updateGraph {

	int c = 0;
	animating = true;
	//collect all scores for this round
	NSMutableArray * scores = [NSMutableArray arrayWithCapacity:5];
	for(myGraphView * view in staticLabels){
		int growth = [[AppData get] scoreForToken:0];
		tokenScores[c] += growth; //update global scores
		[scores addObject:[NSNumber numberWithInt:growth]];
		c++;
	}

	c = 0; //add score labels, non animating yet
	for(myGraphView * view in staticLabels){
		CGRect f = ((UIView*)[bars objectAtIndex:c]).frame;
		int scoreChange = [[scores objectAtIndex:c] intValue];
		int labelBarPadding = 5;
		if (scoreChange >= 0 ){
			f.origin.x = f.origin.x + f.size.width + labelBarPadding;
		}else{
			f.origin.x = f.origin.x - labelBarPadding - 10; //TODO
		}
		UILabel * lab = [[UILabel alloc] initWithFrame:f];
		if ( scoreChange > 0)
			lab.text = [NSString stringWithFormat:@"+%d", scoreChange];
		else
			lab.text = [NSString stringWithFormat:@"%d", scoreChange];

		lab.backgroundColor = [UIColor clearColor];
		lab.font = [UIFont fontWithName:@"Capita-Light" size:13];
		lab.opaque = false;
		lab.alpha = 0;
		lab.textColor = [UIColor whiteColor];
		[graphics addSubview:lab];
		[animatedLabels addObject:lab];
		c++;
	}


	c = 0; //delayed anim of the bars
	for(myGraphView * view in bars){

		[UIView animateWithDuration: GRAPH_ANIMATION_DURATION
							  delay: c
							options: UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 CGRect r = view.frame;
							 int growth = 10 * [[scores objectAtIndex:c] integerValue];
							 [scores addObject:[NSNumber numberWithInt:growth]];
							 if(growth > 0){
								 r.size.width += growth;
							 }
							 else{
								 r.origin.x -= fabs(growth);
								 r.size.width += fabs(growth);
							 }
							 [view setFrame:r];
							 view.alpha = 1;
						 }

						 completion:^(BOOL finished){

							 UILabel * lab = [staticLabels objectAtIndex:c];
							 [UIView transitionWithView:lab
											   duration:GRAPH_ANIMATION_DURATION
												options:UIViewAnimationOptionTransitionFlipFromTop
											 animations: ^{
												 if ( tokenScores[c] > 0)
													 lab.text = [NSString stringWithFormat:@"%@: +%d", [[AppData get] tokenAtIndex: c], tokenScores[c]];
												 else
													 lab.text = [NSString stringWithFormat:@"%@: %d", [[AppData get] tokenAtIndex: c], tokenScores[c]];
											 }
											 completion:^(BOOL finished){}
							  ];

						 }
		 ];
		c++;
	}

	c = 0;
	UILabel * lastView = [animatedLabels lastObject];
	for(UILabel * label in animatedLabels){

		//delayed animation of score labels
		[UIView animateWithDuration: GRAPH_ANIMATION_DURATION
							  delay: c
							options: UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 int grow = [[scores objectAtIndex:c] integerValue];
							 CGRect r = label.frame;
							 r.origin.x += 10 * grow;
							 [label setFrame:r];
							 label.alpha = 1;
							 if(grow > 0){
								 label.text = [NSString stringWithFormat:@"+%d", grow];
							 }
							 else{
								 label.text = [NSString stringWithFormat:@"%d", grow];
							 }
						 }
						 completion:^(BOOL finished){

							 [UIView animateWithDuration:GRAPH_ANIMATION_DURATION
												   delay: 0.0
												 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
											  animations:^{
												  label.alpha = 0;
											  }


											  completion:^(BOOL finished){

												  //remove temp label from superview
												  [label removeFromSuperview];
												  [label release];
												  if(label == lastView){                                                                                                                                                                                 //we finally sho the next question
													  [animatedLabels removeAllObjects];
													  [self performSelector:@selector(showQuestion) withObject:nil afterDelay:0.0];
												  }

											  }];

						 }];
		c++;
	}

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:FADE_ANIMATION_DURATION];
	yesButton.alpha = 0;
	noButton.alpha = 0;
	graphics.alpha = 1;
	[UIView commitAnimations];
}


- (IBAction)pressedYES:(id)sender {
	if(!animating){
		((UIButton *)sender).highlighted = NO;
		[[AppData get] PlayYesButtonSound];
		[self updateGraph];
	}
}


- (IBAction)pressedNO:(id)sender {
	if(!animating){
		((UIButton *)sender).highlighted = NO;
		[[AppData get] PlayNoButtonSound];
		[self updateGraph];
	}
}


-(void)resetAllGraphBars {

	for(myGraphView * view in bars){
		//reset to center
		CGRect r = view.frame;
		r.origin.x = self.view.frame.size.width / 2 - initialBarW / 2;
		r.size.width = initialBarW;
		//view.alpha = 0;
		[view setFrame:r];
	}
}


-(void)showQuestion {


	[UIView transitionWithView:wrapper
					  duration:FADE_ANIMATION_DURATION
					   options:UIViewAnimationOptionTransitionFlipFromRight
					animations: ^{
						NSString * nextQuestion = [[AppData get] nextQuestion];
						if(nextQuestion){
							[question setText:nextQuestion];
						}
						else{
							roundOver = true;
							[question setText:@"Round is Over!"];
							yesButton.hidden = true;
							noButton.hidden = true;
						}

						[self resetAllGraphBars];
					}


					completion:^(BOOL finished){
						if(roundOver){
							[UIView beginAnimations:nil context:nil];
							[UIView setAnimationDuration:GRAPH_ANIMATION_DURATION];
							[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
							graphics.alpha = 0;
							[UIView commitAnimations];
							[self.delegate performSelector:@selector(questionViewControllerDidFinish:) withObject:self afterDelay:1.0];
						}
						else{
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


-(void)buttonAnimEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
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