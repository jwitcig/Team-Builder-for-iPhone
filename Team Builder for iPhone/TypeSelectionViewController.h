//
//  ViewController.h
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <iAd/ADBannerView.h>

@interface TypeSelectionViewController : UIViewController <ADBannerViewDelegate>

- (IBAction)randomPressed:(UIButton *)button;
- (IBAction)skillBasedPressed:(UIButton *)button;

@property (retain) IBOutlet ADBannerView *banner;

@end