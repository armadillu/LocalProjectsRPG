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

	questions = nil;
	return self;
}


-(void)fetchQuestions:(id)delegate{

	Wrapper * wrap = [[Wrapper alloc] init] ;
	wrap.asynchronous = FALSE;

	NSError * err = [wrap sendRequestTo:[NSURL URLWithString:[NSString stringWithFormat:@"%@/questions", BACKEND_SERVER_URL]]
			  usingVerb:@"GET"
		 withParameters:nil
	 ];
	NSString * resp = [wrap responseAsText];
	//NSLog(@"resp1: %@", resp);
	[wrap release];

	//return on connection error
	if (err != nil){
		[delegate performSelectorOnMainThread:@selector(noDataSoNoGame:) withObject:@"Cant Connect to the backend." waitUntilDone:NO];
		return;
	}
	//return on error
	if ([resp length] == 0){
		[delegate performSelectorOnMainThread:@selector(noDataSoNoGame:) withObject:@"Silent reply from the backend; no questions in DB?" waitUntilDone:NO];
		return;
	}

	NSError * error = nil;
	//decode json into a Cocoa Obj
	id jsonObj = [NSJSONSerialization JSONObjectWithData:[resp dataUsingEncoding:NSUTF8StringEncoding]
												 options:kNilOptions
												   error:&error];
	if (error!= nil){
		NSLog(@"error: %@", [error userInfo]);
		[delegate performSelectorOnMainThread:@selector(noDataSoNoGame:) withObject:@"Unexpected reply from the backend; JSON malformed!" waitUntilDone:NO];
		return;
	}

	NSLog(@"%@", jsonObj);
	if ([jsonObj isKindOfClass:[NSArray class]]){ // got a NSArray

		if (questions != nil){ //make space for new set of questions
			[questions removeAllObjects];
			[questions release];
		}
		questions = [[NSMutableArray alloc] initWithCapacity:4];

		for	(id obj in jsonObj){
			//NSLog(@"question: %@", [obj objectForKey:@"question"]);
			//NSLog(@"questionID: %@", [obj objectForKey:@"questionID"]);
			[questions addObject:[obj objectForKey:@"question"]];
		}

	}else{ //got a NSDict
		//???
	}
	[delegate performSelectorOnMainThread:@selector(gotDataSoStartGame) withObject:nil waitUntilDone:NO];
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

	if (questions == nil){
		return [NSArray arrayWithObjects:
				@"Should we have more parks?(hardcoded)",
				@"Should we add more schools?(hardcoded)",
				@"Should we provide shelter for homeless people?(hardcoded)",
				@"Are you at home?(hardcoded)",
				@"Are you bored of this yet?(hardcoded)",
				nil
				];
	}else{
		return [NSArray arrayWithArray:questions];
	}
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
