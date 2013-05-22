//
//  myGraphView.m
//  iosRPG
//
//  Created by Oriol Ferrer Mesià on 23/05/13.
//  Copyright (c) 2013 Oriol Ferrer Mesià. All rights reserved.
//

#import "myGraphView.h"

@implementation myGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//self.layer.masksToBounds = true;
		self.layer.cornerRadius = 4;
		self.layer.contents = (id)[[UIImage imageNamed:@"gradient.png"] CGImage];

//		gradientLayer = [CAGradientLayer layer];
//		gradientLayer.frame = self.bounds;
//		gradientLayer.colors = [NSArray arrayWithObjects:
//								(id)[[UIColor colorWithWhite:0.000 alpha:0.500] CGColor],
//								(id)[[UIColor clearColor] CGColor],
//								nil];
//		[self.layer insertSublayer:gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
//	gradientLayer.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
