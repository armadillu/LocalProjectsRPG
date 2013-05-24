//
//  ResultsViewController.m
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 24/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewWillAppear:(BOOL)animated;{

	UIFont * smallFont = [UIFont fontWithName:@"Capita-Light" size:28];
	UIFont * bigTitle = [UIFont fontWithName:@"Capita-Light" size:30];

	titleLabel.font = bigTitle;

	[okButton.titleLabel setFont:smallFont];
	[okButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0)];
	[okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[okButton setBackgroundImage:[UIImage imageNamed:@"yesButton"] forState:UIControlStateNormal];

	int numT = [[AppData get] numTokens];

	int* scores = [self.delegate getScores];

	int totalW = graphics.frame.size.width;
	int x = 0;
	int y = zeroBar.frame.origin.y;
	int spaceBetweenBars = 10;
	barHeightMult = 1;
	float maxHeight = 80;
	//totalW = numT * barW + (numT-1) * spaceBetweenBars >>> barW = ( totalW - (numT-1) * spaceBetweenBars ) / numT;
	int barW = ( totalW - (numT-1) * spaceBetweenBars ) / numT;

	int lowestScore = 0;
	int highestScore = 0;
	int topScore = 0;
	for(int i = 0; i < numT; i++){
		if ( scores[i] < lowestScore)
			lowestScore = scores[i];
		if ( scores[i] > highestScore)
			highestScore = scores[i];
	}
	if (fabs(lowestScore) > highestScore){
		topScore = fabs(lowestScore);
	}else{
		topScore = fabs(highestScore);
	}
	barHeightMult = (maxHeight - 20) / fabs(topScore);

	int titlesBarY = ( 2 + topScore ) * barHeightMult;
	CGRect r = titlesBar.frame;
	r.origin.y = zeroBar.frame.origin.y + titlesBarY;
	//titlesBar.frame = r;

	for(int i = 0; i < numT; i++){

		int score = -scores[i];
		UILabel * tokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(-2.2 * barW - x + (barW + spaceBetweenBars) * i,
																			titlesBar.frame.origin.y  - 23 ,
																			graphics.frame.size.width,
																			40)
								   ];
		tokenLabel.textAlignment = NSTextAlignmentLeft;
		tokenLabel.backgroundColor = [UIColor clearColor];
		tokenLabel.font = [UIFont fontWithName:@"Capita-Light" size:12];
		tokenLabel.text = [NSString stringWithFormat:@"%@", [[AppData get] tokenAtIndex: i] ];
		tokenLabel.opaque = false;
		tokenLabel.textColor = [UIColor whiteColor];
		tokenLabel.layer.anchorPoint = CGPointMake(0, 0);
		tokenLabel.transform = CGAffineTransformMakeRotation( DegreesToRadians(45));


		UILabel * scoreL = [[UILabel alloc] initWithFrame:CGRectMake(x + barW/2 + (barW + spaceBetweenBars) * (i-1),
																			y -20,
																			70,
																			40)
								   ];
		scoreL.textAlignment = NSTextAlignmentCenter;
		scoreL.backgroundColor = [UIColor clearColor];
		scoreL.font = [UIFont fontWithName:@"Capita-Light" size:12];
		if (score > 0)
			scoreL.text = [NSString stringWithFormat:@"+%d", score ];
		else
			scoreL.text = [NSString stringWithFormat:@"%d", score ];


		scoreL.opaque = false;
		scoreL.textColor = [UIColor whiteColor];
		scoreL.alpha = 0;

		int offset = 1;
		if (score > 0 ){
			offset = 1;
		}else{
			if(score < 0 ){
				offset = -1;
			}else{ // score == 0
				offset = 0;
			}
		}
		myGraphView * bar = [[myGraphView alloc] initWithFrame: CGRectMake(x + (barW + spaceBetweenBars) * i,
																		   y - offset
																		   ,barW
																		   ,0
																		   )
							 ];
		bar.backgroundColor = [[self.delegate getColors] objectAtIndex:i]; //ghetto! todo!
		[graphics addSubview:bar];
		[graphics addSubview:tokenLabel];
		[graphics addSubview:scoreL];

		[UIView animateWithDuration: FADE_ANIMATION_DURATION
							  delay: 0
							options: UIViewAnimationOptionCurveEaseOut
						 animations:^{
								int s = -score * barHeightMult;
								CGRect r = bar.frame;
								if(s > 0) {
									r.size.height = fabs(s);
								}else{
									r.origin.y += -fabs(s);
									r.size.height = fabs(s);
									//NSLog(@"bbb");
								}
								bar.frame = r;
								
								r = scoreL.frame;
								if (s > 0) r.origin.y += 10 + bar.frame.size.height;
								else r.origin.y -= 10 + bar.frame.size.height;
								scoreL.frame = r;
								scoreL.alpha = 1;

						 }

						 completion:^(BOOL finished){}
		 ];
		[tokenLabel release];
		[scoreL release];
		[bar release];
	}
	
}

- (void)viewWillDisappear:(BOOL)animated{

}

- (IBAction)pressedOK:(id)sender;{
	[self.delegate resultViewControllerDidFinish:self];
}


@end
