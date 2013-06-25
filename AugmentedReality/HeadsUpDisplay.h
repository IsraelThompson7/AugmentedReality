//
//  HeadsUpDisplay.h
//  Auger
//
//  Created by Robby on 1/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadsUpDisplay : UIView
@property double pitch;
@property double roll;
@property double yaw;
-(void)tapped:(CGPoint)locationOfTouch;
@end