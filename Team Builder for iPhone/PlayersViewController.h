//
//  PlayersViewController.h
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import "Player.h"

#import "ResultViewController.h"

@interface PlayersViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)continuePressed:(UIButton *)button;

@end