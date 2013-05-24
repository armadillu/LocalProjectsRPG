//
//  AppData.h
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "Wrapper.h"
#include "Constants.h"

@interface AppData : NSObject{

	int currentQuestion;
	AVAudioPlayer * yesSound;
	AVAudioPlayer * noSound;
	AVAudioPlayer * startSound;
	NSMutableArray * questions;
}

+ (AppData*) get;

-(void)fetchQuestions:(id)delegate;

-(void)startGame;
-(NSString*) nextQuestion;
-(void)userAnsweredYes;
-(void)userAnsweredNo;

-(void)PlayYesButtonSound;
-(void)PlayNoButtonSound;
-(void)PlayStartButtonSound;

-(int)numTokens;
-(int)scoreForToken:(int)token;
-(NSString*)tokenAtIndex:(int)i;

-(NSArray *) questionsForRound:(int)round;
-(int) numRounds;



@end
