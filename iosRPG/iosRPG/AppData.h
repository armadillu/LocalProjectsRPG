//
//  AppData.h
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 22/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject{

	int currentQuestion;
}

+ (AppData*) get;

-(void)startGame;
-(NSString*) nextQuestion;


-(NSArray *) questionsForRound:(int)round;
-(int) numRounds;



@end
