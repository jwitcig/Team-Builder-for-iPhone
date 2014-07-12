//
//  ResultViewController.h
//  Team Builder for iPhone
//
//  Created by Application Development on 1/6/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <iAd/ADBannerView.h>

#import "Player.h"

@interface ResultViewController : UIViewController <ADBannerViewDelegate>

@property (retain) IBOutlet ADBannerView *banner;

@end
