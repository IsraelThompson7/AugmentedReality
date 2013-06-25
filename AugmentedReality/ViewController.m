//
//  ViewController.m
//  AugmentedReality
//
//  Created by Robby on 6/25/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import "ViewController.h"
#import "HeadsUpDisplay.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController (){
    CMMotionManager *motionManager;
    UITapGestureRecognizer *tapOnceGesture;
    UITapGestureRecognizer *tapTwiceGesture;
}
@property HeadsUpDisplay *hud;
@end

@implementation ViewController
@synthesize hud;

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    [imagePicker.view setUserInteractionEnabled:NO];
    //    imagePicker.cameraViewTransform = CGAffineTransformMakeScale(1.23, 1.23);
    [self.view addSubview:imagePicker.view];
    
    hud = [[HeadsUpDisplay alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
    [[hud layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [hud setUserInteractionEnabled:NO];
    [hud setTransform:CGAffineTransformMakeRotation(-M_PI/2.0)];
    [hud setCenter:imagePicker.view.center];
    [self.view addSubview:hud];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0/15.0;
    if(motionManager.isDeviceMotionAvailable){
        [motionManager startDeviceMotionUpdates];
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *deviceMotion, NSError *error){
            CMAttitude *attitude = deviceMotion.attitude;
            [hud setPitch:attitude.pitch];
            [hud setRoll:attitude.roll];
            [hud setYaw:attitude.yaw];
            [hud setNeedsLayout];
        }];
    }
    tapOnceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];
    tapTwiceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
    [tapOnceGesture setNumberOfTapsRequired:1];
    [tapTwiceGesture setNumberOfTapsRequired:2];
    //    [tapOnceGesture requireGestureRecognizerToFail:tapTwiceGesture];
    [self.view addGestureRecognizer:tapOnceGesture];
    [self.view addGestureRecognizer:tapTwiceGesture];
}
-(void)tapOnce:(UITapGestureRecognizer*)sender{
    [hud tapped:[sender locationInView:[sender view]]];
}
-(void)tapTwice:(UITapGestureRecognizer*)sender{
    if([hud alpha]){
        [UIView beginAnimations:Nil context:nil];
        [UIView setAnimationDuration:0.33];
        [hud setAlpha:0.0];
        [UIView commitAnimations];
    }
    else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.33];
        [hud setAlpha:1.0];
        [UIView commitAnimations];
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
