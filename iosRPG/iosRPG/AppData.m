//
//  AppData.m
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "AppData.h"

static AppData * appdataSingleton = nil;

@implementation AppData


-(id)init {
	NSURL * musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
												pathForResource:@"yes"
												ofType:@"wav"]];
	yesSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
	[yesSound prepareToPlay];

	musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
										pathForResource:@"no"
										ofType:@"wav"]];
	noSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
	[noSound prepareToPlay];

	musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
										pathForResource:@"start"
										ofType:@"wav"]];
	startSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
	[startSound prepareToPlay];

	return self;
}


-(NSString *)tokenAtIndex:(int)i {

	NSArray * tokens = [NSArray arrayWithObjects :
						@"income tax",
						@"education level",
						@"public health",
						@"entrepreneurship",
						@"community art",
						@"immigration",
						nil
						];

	return [tokens objectAtIndex:i];
}


-(NSArray *) questionsForRound:(int)round {

	return [NSArray arrayWithObjects:
			@"Should we have more parks?",
			@"Should we add more schools?",
			@"Should we provide shelter for homeless people?",
			@"Are you at home?",
			@"Are you bored of this yet?",
			nil
			];
}


-(int) numRounds {
	return 1;
}


-(void)startGame {
	currentQuestion = 0;
}


-(NSString *) nextQuestion {

	NSArray * quests = [self questionsForRound:0];
	if(currentQuestion < [quests count]){
		NSString * q = [quests objectAtIndex:currentQuestion];
		currentQuestion++;
		return q;
	}
	else{
		return nil;
	}
}


-(int)numTokens {
	return 5;
}


-(int)scoreForToken:(int)token {
	return rand() % 10 - 5;
}


/////////////////////////////////////////////////////////////////////////
// SOUND stuff


-(void)PlayYesButtonSound {
	[yesSound play];
}


-(void)PlayNoButtonSound {
	[noSound play];
}


-(void)PlayStartButtonSound {
	[startSound play];
}


////////////////////////////////////////////////////////////////////////
// Singleton pattern stuff

+ (AppData *) get {
	if(appdataSingleton == nil){
		[[self alloc] init]; // assignment not done here
	}
	return appdataSingleton;
}


+ (id)allocWithZone:(NSZone *)zone {
	if(appdataSingleton == nil){
		appdataSingleton = [super allocWithZone:zone];
		return appdataSingleton;  // assignment and return on first allocation
	}
	return nil; //on subsequent allocation attempts return nil
}


@end
