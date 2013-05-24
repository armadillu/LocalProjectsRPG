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
	if(self) {

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

		NSLog(@"initWithNibName");
	}
	firstTime = true;
	return self;
}


- (void)viewWillAppear:(BOOL)animated {

	if (firstTime){
		originalQuestionFrame = question.frame;
		originalYesFrame = yesButton.frame;
		originalNoFrame = noButton.frame;

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

	}else{
		firstTime = false;
	}

	//reset scores
	int n = [[AppData get] numTokens];
	tokenScores = (int *)malloc(sizeof(int) * n);
	for(int i = 0; i < n; i++) {
		tokenScores[i] = 0;
	}

	[self setupGraphs];

	NSString * firstQuestion = [[AppData get] nextQuestion];
	if(firstQuestion) {
		//question.text = firstQuestion;
		[self layoutQuestion:firstQuestion];
		roundOver = false;
	}else{
		roundOver = true;
	}
}

- (void)viewDidDisappear:(BOOL)animated;{
	[self cleanUpStructures];
}


-(void)cleanUpStructures{

	for(UILabel* v in staticLabels){
		[v removeFromSuperview];
		[v release];
	}
	[staticLabels removeAllObjects];

	for(myGraphView* v in bars){
		[v removeFromSuperview];
		[v release];
	}
	[bars removeAllObjects];
}


- (void)setupGraphs {

	int y = 0; //starting y for graphs
	int h = 16; // each bar graph height
	int spacing = 5; //spacing betwen bars
	int initialBarW = INITIAL_GRAPH_BAR_W; //

	int n = [[AppData get] numTokens];
	graphics.alpha = 0;

	for(int i = 0; i < n; i++) {
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
		lab.layer.shadowOffset = CGSizeMake(0, 0);
		lab.layer.shadowRadius = 1.0;
		lab.layer.shadowOpacity = 1;
		lab.textColor = [UIColor whiteColor];
		[staticLabels addObject:lab];
		[graphics addSubview:lab];
	}
}



/////////////////////////////////////////////////////////////////////////////////////


- (IBAction)pressedYES:(id)sender {
	if(!animating) {
		pressedYes = YES;
		((UIButton *)sender).highlighted = NO;
		[[AppData get] PlayYesButtonSound];
		[self makeSpaceForGraphs];
		[self updateGraph];
	}
}


- (IBAction)pressedNO:(id)sender {
	if(!animating) {
		pressedYes = NO;
		((UIButton *)sender).highlighted = NO;
		[[AppData get] PlayNoButtonSound];
		[self makeSpaceForGraphs];
		[self updateGraph];
	}
}


-(void)resetAllGraphBars {

	for(myGraphView * view in bars) {
		//reset to center
		CGRect r = view.frame;
		r.origin.x = self.view.frame.size.width / 2 - INITIAL_GRAPH_BAR_W / 2;
		r.size.width = INITIAL_GRAPH_BAR_W;
		//view.alpha = 0;
		[view setFrame:r];
	}
}

-(void)layoutQuestion:(NSString*) nextQuestion{

	if(nextQuestion==nil) { // SHOW NEXT QUESTION
		nextQuestion = @"Round is Over!";
		roundOver = true;
		yesButton.hidden = true;
		noButton.hidden = true;
	}
	question.frame = originalQuestionFrame;
	question.text = nextQuestion;
	[question sizeToFit];
	int verticalSpace = originalQuestionFrame.size.height - question.frame.size.height;
	CGRect r = question.frame;
	r.origin.y += verticalSpace/2;
	question.frame = r;

}

-(void)showQuestion {


	//set plot bars to initial state, clean up graphs and buttons
	[UIView animateWithDuration: GRAPH_ANIMATION_DURATION
						  delay: 0
						options: UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 graphics.alpha = 0;
						 yesButton.alpha = 0;
						 noButton.alpha = 0;
						 [self resetAllGraphBars];
					 }
					 completion:^(BOOL finished){}
	 ];


	[self performSelector:@selector(layoutQuestion:) withObject:[[AppData get] nextQuestion] afterDelay:GRAPH_ANIMATION_DURATION*0.5];

	[UIView transitionWithView:question
					  duration:FLIP_ANIMATION_DURATION
					   options:UIViewAnimationOptionTransitionFlipFromTop | UIViewAnimationOptionAllowUserInteraction
					animations: ^{
						//[self layoutQuestion: [[AppData get] nextQuestion]];
					}

					completion:^(BOOL finished){

						if(roundOver==false) {
							//question is over, next question is up, let's show the YES/NO buttons again
							yesButton.frame = originalYesFrame;
							noButton.frame = originalNoFrame;
							[UIView beginAnimations:nil context:nil];
							[UIView setAnimationDuration:FADE_ANIMATION_DURATION];
							yesButton.alpha = 1;
							noButton.alpha = 1;
							CGRect f = question.frame;
							//f.origin.y += QUESTION_SLIDE_DISTANCE;
							f.size.height -= QUESTION_SLIDE_DISTANCE;
							//question.frame = f;
							//graphics.alpha = 0;
							[UIView setAnimationDelegate:self];
							[UIView setAnimationDidStopSelector:@selector(buttonAnimEnded:finished:context:)];
							[UIView commitAnimations];
						}else{
							//end of game, good bye!
							[UIView beginAnimations:nil context:nil];
							[UIView setAnimationDuration:FADE_ANIMATION_DURATION];
							[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
							graphics.alpha = 0;
							[UIView commitAnimations];
							[self.delegate performSelector:@selector(questionViewControllerDidFinish:) withObject:self afterDelay:FLIP_ANIMATION_DURATION + ROUND_OVER_MSG_DURATION];
						}
					}];
}


-(void)buttonAnimEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	animating = false;
}


-(void)makeSpaceForGraphs{

	animating = true;

	// move question to top
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:FADE_ANIMATION_DURATION];
	CGRect questionRect = question.frame;
	questionRect.origin.y = SCREEN_EDGE;
	question.frame = questionRect;

	// hide and moving yes / no button accordingly
	CGRect buttonRect = yesButton.frame;
	buttonRect.origin.y = SCREEN_EDGE + questionRect.size.height + FRA_ELEMENT_GAP;
	buttonRect.origin.x = wrapper.frame.size.width/2 - yesButton.frame.size.width/2;

	if (pressedYes){ //focus on YES
		yesButton.alpha = 1;
		noButton.alpha = 0;
		yesButton.frame = buttonRect;
	}else{ // focus on NO
		yesButton.alpha = 0;
		noButton.alpha = 1;
		noButton.frame = buttonRect;
	}
	graphics.alpha = 1;
	CGRect graphsRect = graphics.frame;
	graphsRect.origin.y = buttonRect.origin.y + buttonRect.size.height + FRA_ELEMENT_GAP; //starting y for graphs
	graphics.frame = graphsRect;
	[UIView commitAnimations];

}


-(void)updateGraph {

	int c = 0;

	//collect all scores for this round
	NSMutableArray * scores = [NSMutableArray arrayWithCapacity:5];
	for(myGraphView * view in staticLabels) {
		int growth = [[AppData get] scoreForToken:0];
		tokenScores[c] += growth; //update global scores
		[scores addObject:[NSNumber numberWithInt:growth]];
		c++;
	}

	c = 0; //add score labels, non animating yet
	for(myGraphView * view in staticLabels) {
		CGRect f = ((UIView *)[bars objectAtIndex:c]).frame;
		int scoreChange = [[scores objectAtIndex:c] intValue];
		int labelBarPadding = 5;
		if(scoreChange >= 0) {
			f.origin.x = f.origin.x + f.size.width + labelBarPadding;
		}else{
			f.origin.x = f.origin.x - labelBarPadding - 10; //TODO
		}
		UILabel * lab = [[UILabel alloc] initWithFrame:f];
		if(scoreChange > 0) {
			lab.text = [NSString stringWithFormat:@"+%d", scoreChange];
		}else{
			lab.text = [NSString stringWithFormat:@"%d", scoreChange];
		}

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
	for(myGraphView * view in bars) {

		[UIView animateWithDuration: GRAPH_ANIMATION_DURATION
							  delay: c * GRAPH_ANIMATION_DURATION
							options: UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 CGRect r = view.frame;
							 int growth = 10 * [[scores objectAtIndex:c] integerValue];
							 [scores addObject:[NSNumber numberWithInt:growth]];
							 if(growth > 0) {
								 r.size.width += growth;
							 }else{
								 r.origin.x -= fabs(growth);
								 r.size.width += fabs(growth);
							 }
							 [view setFrame:r];
							 view.alpha = 1;
						 }


						 completion:^(BOOL finished){

							//update the score for all tokens
							 UILabel * lab = [staticLabels objectAtIndex:c];
							 [UIView transitionWithView:lab
											   duration:GRAPH_ANIMATION_DURATION
												options:UIViewAnimationOptionTransitionFlipFromTop
											 animations: ^{
												 if(tokenScores[c] > 0) {
													 lab.text = [NSString stringWithFormat:@"%@: +%d", [[AppData get] tokenAtIndex: c], tokenScores[c]];
												 }else{
													 lab.text = [NSString stringWithFormat:@"%@: %d", [[AppData get] tokenAtIndex: c], tokenScores[c]];
												 }
											 }
											 completion:^(BOOL finished){}
							  ];

						 }


		 ];
		c++;
	}

	c = 0;
	UILabel * lastView = [animatedLabels lastObject];
	for(UILabel * label in animatedLabels) {

		//delayed animation of score labels
		[UIView animateWithDuration: GRAPH_ANIMATION_DURATION
							  delay: c * GRAPH_ANIMATION_DURATION
							options: UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 int grow = [[scores objectAtIndex:c] integerValue];
							 CGRect r = label.frame;
							 r.origin.x += 10 * grow;
							 [label setFrame:r];
							 label.alpha = 1;
							 if(grow > 0) {
								 label.text = [NSString stringWithFormat:@"+%d", grow];
							 }else{
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
												  if(label == lastView) { //we finally show the next question
													  [animatedLabels removeAllObjects];
													  [self performSelector:@selector(showQuestion) withObject:nil afterDelay:0.0];
												  }

											  }];

						 }];
		c++;
	}

}


/////////////////////////////////////////////////////////////////////////////////////


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end