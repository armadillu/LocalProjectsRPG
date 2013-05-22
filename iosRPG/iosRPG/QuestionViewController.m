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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



/////////////////////////////////////////////////////////////////////////////////////

int c = 0;

- (IBAction)pressedYES:(id)sender{
	((UIButton*)sender).highlighted = NO;
	//give button time to update its view
	[self performSelector:@selector(showQuestion:) withObject:[NSString stringWithFormat:@"aufidh iudsh guihdsiu? %d", c] afterDelay:0.0];
	c++;
}


- (IBAction)pressedNO:(id)sender{
	((UIButton*)sender).highlighted = NO;
	//give button time to update its view
	[self performSelector:@selector(showQuestion:) withObject:[NSString stringWithFormat:@"aufidh iudsh guihdsiu? %d", c] afterDelay:0.0];
	c++;
}


-(void)showQuestion:(NSString*) quest{

	[UIView transitionWithView:wrapper
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
						[question setText:quest];
					}
                    completion:NULL];
	
}


- (IBAction)pressedDone:(id)sender{
	[self.delegate questionViewControllerDidFinish:self];
}



/////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
