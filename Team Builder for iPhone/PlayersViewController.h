//
//  PlayersViewController.h
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <iAd/ADBannerView.h>

#import "Player.h"

#import "ResultViewController.h"

@interface PlayersViewController : UIViewController <UITextFieldDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (retain) IBOutlet ADBannerView *banner;

- (IBAction)continuePressed:(UIButton *)button;

@end