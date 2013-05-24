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

-(NSArray*)getColors{
	return  colors;
}

-(int*)getScores{
	return tokenScores;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self) {

		//		for (NSString *family in [UIFont familyNames]) {
		//			NSLog(@"%@", [UIFont fontNamesForFamilyName:family]);
		//		}

		//animatedLabels = [[NSMutableArray alloc] initWithCapacity:6];
		//staticLabels = [[NSMutableArray alloc] initWithCapacity:6];
		//bars = [[NSMutableArray alloc] initWithCapacity:6];
		colors = [[NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor],
				   [UIColor yellowColor], [UIColor orangeColor], nil] retain];
		//		colors = [[NSArray arrayWithObjects: [UIColor grayColor], [UIColor grayColor], [UIColor grayColor],
		//				   [UIColor grayColor], [UIColor grayColor], nil] retain];

		//NSLog(@"initWithNibName");
	}
	firstTime = true;
	return self;
}


- (void)viewWillAppear:(BOOL)animated {

	if (firstTime) {
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
	tokenScores = (int *)malloc(sizeof(int) * n * 2); // *2 to be safe for experiments
	for(int i = 0; i < n * 2; i++) {
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


- (void)viewDidDisappear:(BOOL)animated; {
	[self cleanUpStructures];
}


-(void)cleanUpStructures {

	[staticLabel removeFromSuperview];
	[staticLabel release];
	[bar removeFromSuperview];
	[bar release];
}


- (void)setupGraphs {

	int y = 0; //starting y for graphs
	int h = 16; // each bar graph height
	int spacing = 5; //spacing betwen bars

	int n = [[AppData get] numTokens];
	currentToken = 0;
	graphics.alpha = 0;

	staticLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, graphics.frame.size.width, 40)];
	staticLabel.textAlignment = NSTextAlignmentCenter;
	staticLabel.backgroundColor = [UIColor clearColor];
	staticLabel.font = [UIFont fontWithName:@"Capita-Light" size:20];
	staticLabel.text = [NSString stringWithFormat:@"%@", [[AppData get] tokenAtIndex: 0] ];
	staticLabel.opaque = false;
	staticLabel.textColor = [UIColor whiteColor];
	staticLabel.alpha = 0;
	[graphics addSubview:staticLabel];

	animatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, graphics.frame.size.width, 40)];
	animatedLabel.textAlignment = NSTextAlignmentCenter;
	animatedLabel.backgroundColor = [UIColor clearColor];
	animatedLabel.font = [UIFont fontWithName:@"Capita-Light" size:20];
	animatedLabel.text = [NSString stringWithFormat:@"%@", [[AppData get] tokenAtIndex: 0] ];
	animatedLabel.opaque = false;
	animatedLabel.textColor = [UIColor whiteColor];
	[graphics addSubview:animatedLabel];
	animatedLabel.alpha = 0;


	bar = [[myGraphView alloc] initWithFrame: CGRectMake(0,0,0,0)];
	bar.backgroundColor = [colors objectAtIndex:0];
	[graphics addSubview:bar];
	bar.alpha = 0;
}


/////////////////////////////////////////////////////////////////////////////////////





- (IBAction)pressedYES:(id)sender {
	if(!animating) {
		pressedYes = YES;
		((UIButton *)sender).highlighted = NO;
		[[AppData get] PlayYesButtonSound];
		[self userAnsered];
	}
}


- (IBAction)pressedNO:(id)sender {
	if(!animating) {
		pressedYes = NO;
		((UIButton *)sender).highlighted = NO;
		[[AppData get] PlayNoButtonSound];
		[self userAnsered];
	}
}


-(void)userAnsered {
	[self collectScoresForThisRound];
	[self makeSpaceForGraphs];
}


-(void)layoutQuestion:(NSString*) nextQuestion {

	if(nextQuestion==nil) { // SHOW NEXT QUESTION
		nextQuestion = @"Well Done!";
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

	currentToken = 0; 
	//hide yes & no buttons, end of question, ready to show next one, hide graphics
	[UIView animateWithDuration: GRAPH_ANIMATION_DURATION
						  delay: 0
						options: UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 graphics.alpha = 0;
						 yesButton.alpha = 0;
						 noButton.alpha = 0;
					 }


					 completion:^(BOOL finished){}
	 ];


	//layout the next question halfawy the flip animation, a bit ghetto but works!
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
							[self performSelector:@selector(showResultScores) withObject:nil afterDelay:ROUND_OVER_MSG_DURATION];

						}
					}];
}

#pragma mark - 

-(void)showResultScores{
	ResultsViewController *controller = [[[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil] autorelease];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:controller animated:YES completion:nil];
}

//user pressed done, ended looking at his/her score, back to homepge
- (void)resultViewControllerDidFinish:(ResultsViewController *)controller;{
	[self.delegate questionViewControllerDidFinish:self];
}


-(void)buttonAnimEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	animating = false;
}


-(void)collectScoresForThisRound {
	//collect all scores for this round
	scores = [[NSMutableArray arrayWithCapacity:5] retain]; // scores this round
	int numTokens = [[AppData get] numTokens];
	for(int i = 0; i < numTokens; i++) {
		int growth = [[AppData get] scoreForToken:i];
		tokenScores[i] += growth; //update global scores
		[scores addObject:[NSNumber numberWithInt:growth]];
	}
}


-(void)makeSpaceForGraphs {

	animating = true;

	[UIView animateWithDuration: FADE_ANIMATION_DURATION
						  delay: 0
						options: UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 // move question to top
						 CGRect questionRect = question.frame;
						 questionRect.origin.y = SCREEN_EDGE - 10; // small tweak 
						 question.frame = questionRect;

						 // hide and moving yes / no button accordingly
						 CGRect buttonRect = yesButton.frame;
						 buttonRect.origin.y = questionRect.origin.y + questionRect.size.height + FRA_ELEMENT_GAP;
						 buttonRect.origin.x = wrapper.frame.size.width/2 - yesButton.frame.size.width/2;

						 if (pressedYes) {                                //focus on YES
							 yesButton.alpha = 1;
							 noButton.alpha = 0;
							 yesButton.frame = buttonRect;
						 }else{                                 // focus on NO
							 yesButton.alpha = 0;
							 noButton.alpha = 1;
							 noButton.frame = buttonRect;
						 }
						 graphics.alpha = 0;
						 CGRect graphsRect = graphics.frame;
						 graphsRect.origin.y = buttonRect.origin.y + buttonRect.size.height + FRA_ELEMENT_GAP;                                 //starting y for graphs
						 graphsRect.size.height = wrapper.frame.size.height - graphsRect.origin.y - SCREEN_EDGE;
						 graphics.frame = graphsRect;
					 }


					 completion:^(BOOL finished){
						 //once its all in its place, start the graphs animation
						 [self startGraphAnimation];
					 }


	 ];

}


-(void)resetGraphState { //taking in account current graphic frame, set token label to center, set bar to 0 height in middle;

	int labelHeight = FRA_ELEMENT_GAP * 1.5;
	int growth = [[scores objectAtIndex:currentToken]intValue]; // score this this question's answer for this token
	CGRect r = CGRectMake(wrapper.frame.size.width/2 - BAR_WIDTH/2,
						  graphics.frame.size.height/2 + ((growth < 0) ? labelHeight/2 : -labelHeight/2),
						  BAR_WIDTH, 0);
	bar.frame = r;
	bar.backgroundColor = [colors objectAtIndex:currentToken];

	CGRect r2 = staticLabel.frame;
	r2.origin.y = graphics.frame.size.height/2 - staticLabel.frame.size.height/2;
	staticLabel.frame = r2;
	staticLabel.text = [[AppData get] tokenAtIndex:currentToken];

	CGRect r3 = animatedLabel.frame;
	r3.origin.y = graphics.frame.size.height/2 + ((growth < 0) ? labelHeight : -labelHeight) - animatedLabel.frame.size.height/2;
	animatedLabel.frame = r3;

	if(growth > 0) {
		animatedLabel.text = [NSString stringWithFormat:@"+%d", growth];
	}else{
		if( growth < 0)
			animatedLabel.text = [NSString stringWithFormat:@"%d", growth];
		else
			animatedLabel.text = @"+0";
	}
	animatedLabel.alpha = 0;
	//staticLabel.alpha = 0;
	//bar.alpha = 0;
}


-(void)startGraphAnimation {
	[self resetGraphState];

	//this calls itself as many times as there are tokens, to show them one after each other
	[self performSelector:@selector(driveGraphAnimation) withObject:nil afterDelay:0.25]; //a bit of a rest before we start the anim, too hectic otherwise
}


-(void)driveGraphAnimation {

	[UIView animateWithDuration: EACH_TOKEN_GRAPH_DURATION
						  delay: 0
						options: UIViewAnimationOptionCurveEaseOut
					 animations:^{

						 graphics.alpha = 1;
						 //rise OR drop the bar
						 CGRect r = bar.frame;
						 int growth = 10 * [[scores objectAtIndex:currentToken] integerValue];
						 if(growth > 0) {
							 r.size.height -= growth;
						 }else{
							 r.origin.y += fabs(growth);
							 r.size.height -= fabs(growth);
						 }
						 bar.frame = r;
						 bar.alpha = 1;

						 //show and move the label withthe token score
						 r = animatedLabel.frame;
						 r.origin.y -= growth;
						 if ( growth == 0 ) r.origin.y -= 10;
						 animatedLabel.frame = r;
						 animatedLabel.alpha = 1;

						 //show static label?
						 staticLabel.alpha = 1;
					 }

					 completion:^(BOOL finished){

						 currentToken++;
						 //if another token anim avialble, flip the graphics view
						 if (currentToken < [[AppData get] numTokens]) {


							 [UIView transitionWithView:graphics
											   duration:FLIP_ANIMATION_DURATION
												options:UIViewAnimationOptionTransitionFlipFromLeft
											 animations: ^{
												 [self resetGraphState];
												 [bar removeFromSuperview];                                                                //unless we remove to add later (completion^), weird things happen during the flip
												 [animatedLabel removeFromSuperview];
											 }

											 completion:^(BOOL finished){
												 //[self resetGraphState];
												 [self performSelector:@selector(driveGraphAnimation) withObject:nil afterDelay:0.0];
												 [graphics addSubview:bar];
												 [graphics addSubview:animatedLabel];
											 }

							  ];
							 
						 }else{
							 
							 //done with token anims, hide graphs
							 [UIView animateWithDuration: GRAPH_ANIMATION_DURATION
												   delay: 0
												 options: UIViewAnimationOptionCurveEaseOut
											  animations:^{
												  graphics.alpha = 0;
											  }


											  completion:^(BOOL finished){
												  [self performSelector:@selector(showQuestion) withObject:nil afterDelay:0.0];
											  }


							  ];
							 currentToken = 0; // reset the token counter for the next question
						 }
					 }
	 ];
}


/////////////////////////////////////////////////////////////////////////////////////


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end