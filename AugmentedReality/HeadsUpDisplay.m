//
//  HeadsUpDisplay.m
//  Auger
//
//  Created by Robby on 1/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "HeadsUpDisplay.h"

@interface HeadsUpDisplay ()

@property UIView *universe;
@property UIView *rollMeter;
@property UIView *yawMeter;

@end

@implementation HeadsUpDisplay
{
    NSInteger height;  //size of screen
    NSInteger width;   //    "
    UILabel *pitchLabel;
    UILabel *rollLabel;
    UILabel *yawLabel;
}
@synthesize universe;  // canvas for everything
@synthesize rollMeter;
@synthesize yawMeter;

@synthesize pitch;
@synthesize roll;
@synthesize yaw;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        height = frame.size.width;
        width = frame.size.height;
        if(frame.size.height < frame.size.width){
            height = frame.size.height;
            width = frame.size.width;
        }
        
#pragma mark - calibrate here
// calibrate room size, or simulate parallax effects
// currently at farthest distance possible.
// to make objects appear closer, shrink multiplier: width*5, height*7.5
        universe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*6, height*9)];
        [universe setBackgroundColor:[UIColor clearColor]];
        [self addSubview:universe];
        
        rollMeter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*.1, universe.bounds.size.height)];
        UIView *sky = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*.1, rollMeter.bounds.size.height*.5)];
        UIView *ground = [[UIView alloc] initWithFrame:CGRectMake(0, rollMeter.bounds.size.height*.5, width*.1, rollMeter.bounds.size.height*.5)];
        UIView *skyAgain = [[UIView alloc] initWithFrame:CGRectMake(0, rollMeter.bounds.size.height, width*.1, rollMeter.bounds.size.height*.5)];
        [sky setBackgroundColor:[UIColor colorWithRed:.63 green:.81 blue:1.0 alpha:0.66]];
        [ground setBackgroundColor:[UIColor colorWithRed:.5 green:.87 blue:.34 alpha:.66]];
        [skyAgain setBackgroundColor:[UIColor colorWithRed:.63 green:.81 blue:1.0 alpha:0.66]];
        [rollMeter addSubview:sky];
        [rollMeter addSubview:ground];
        [rollMeter addSubview:skyAgain];
        [self addSubview:rollMeter];
        yawMeter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, universe.bounds.size.width, height*.025)];
        for(int i = -2; i < 14; i++){
            UIView *colorBar = [[UIView alloc] initWithFrame:CGRectMake(yawMeter.bounds.size.width/12.0*i,
                                                                        0,
                                                                        yawMeter.bounds.size.width/12.0,
                                                                        yawMeter.bounds.size.height)];
            [colorBar setBackgroundColor:[UIColor colorWithHue:1/12.0*((i+12)%12) saturation:0.66 brightness:1.0 alpha:.66]];
            [yawMeter addSubview:colorBar];
        }
        [yawMeter setCenter:CGPointMake(width*.5, height*.9875)];
        [self addSubview:yawMeter];
        
        pitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/3.0, width/6.0)];
        rollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/3.0, width/6.0)];
        yawLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/3.0, width/6.0)];
        [pitchLabel setCenter:CGPointMake(0 * width/3.0+width/6.0, height-height/12.0)];
        [rollLabel setCenter:CGPointMake(1 * width/3.0+width/6.0, height-height/12.0)];
        [yawLabel setCenter:CGPointMake(2 * width/3.0+width/6.0, height-height/12.0)];
        [pitchLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:width/6.0]];
        [rollLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:width/6.0]];
        [yawLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:width/6.0]];
        [pitchLabel setTextColor:[UIColor whiteColor]];
        [rollLabel setTextColor:[UIColor whiteColor]];
        [yawLabel setTextColor:[UIColor whiteColor]];
        [pitchLabel setTextAlignment:NSTextAlignmentCenter];
        [rollLabel setTextAlignment:NSTextAlignmentCenter];
        [yawLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:pitchLabel];
        [self addSubview:rollLabel];
        [self addSubview:yawLabel];        
    }
    return self;
}
-(void) layoutSubviews
{
    [super layoutSubviews];
    [pitchLabel setText:[NSString stringWithFormat:@"%.2f",pitch]];
    [rollLabel setText:[NSString stringWithFormat:@"%d°",(int)((.5+roll/M_PI/2)*360)]];
    [yawLabel setText:[NSString stringWithFormat:@"%d°",(int)((.5+yaw/M_PI/2)*360)]];
    [rollMeter setCenter:CGPointMake(.05*width, .5*height+.5*rollMeter.bounds.size.height*((roll-M_PI*.5)/M_PI))];
    [yawMeter setCenter:CGPointMake(.5*width+.5*yawMeter.bounds.size.width*(yaw/M_PI), height*.9875)];
    [universe setCenter:CGPointMake(.5*width+.5*universe.bounds.size.width*(yaw/M_PI), .5*height+.5*universe.bounds.size.height*((roll-M_PI*.5)/M_PI))];
}
#pragma  mark - due to device orientation, locationOfTouch x and y are switched
-(void)tapped:(CGPoint)locationOfTouch{
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [dot setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.66]];
    [dot setCenter:CGPointMake(.5*universe.bounds.size.width                  // the center of the universe view
                                    -.5*universe.bounds.size.width*(yaw/M_PI) // counter the translations due to orientation
                                    -locationOfTouch.y+width*.5,              // account for the location of touch on screen
                               .5*universe.bounds.size.height
                                    -.5*universe.bounds.size.height*((roll-M_PI*.5)/M_PI)
                                    +locationOfTouch.x-height*.5)];
    [universe addSubview:dot];
}


@end
