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


-(NSArray *) questionsForRound:(int)round{

	return [NSArray arrayWithObjects:
			@"What is the weather like?",
			@"Should we add more schools?",
			@"Are monkeys going to take over the world?",
			@"Are you bored of this yet?",
			nil
			];
}


-(int) numRounds{
	return 1;
}


-(void)startGame{
	currentQuestion = 0;
}

-(NSString*) nextQuestion{

	NSArray * quests = [self questionsForRound:0];
	if (currentQuestion < [quests count]) {
		NSString * q = [quests objectAtIndex:currentQuestion];
		currentQuestion++;
		return q;
	}else{
		return nil;
	}
}



////////////////////////////////////////////////////////////////////////
// Singleton pattern stuff

+ (AppData*) get{
	if (appdataSingleton == nil) {
		[[self alloc] init]; // assignment not done here
	}
    return appdataSingleton;
}

+ (id)allocWithZone:(NSZone *)zone{
	if (appdataSingleton == nil) {
		appdataSingleton = [super allocWithZone:zone];
		return appdataSingleton;  // assignment and return on first allocation
	}
    return nil; //on subsequent allocation attempts return nil
}


@end
