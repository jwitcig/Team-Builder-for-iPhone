//
//  ViewController.m
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import "TypeSelectionViewController.h"

@interface TypeSelectionViewController () {
    BOOL bannerIsVisible;
}

@end

@implementation TypeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)randomPressed:(UIButton *)button {
    NSLog(@"random");
    selectionType = SELECTION_TYPE_RANDOM;
}

- (IBAction)skillBasedPressed:(UIButton *)button {
    NSLog(@"skill");
    selectionType = SELECTION_TYPE_SKILL;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!bannerIsVisible) {
        
        NSLog(@"bannerViewDidLoadAd");
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
        
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (bannerIsVisible) {
        
        NSLog(@"bannerView:didFailToReceiveAdWithError:");
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // assumes the banner view is at the top of the screen.
        
        banner.frame = CGRectOffset(banner.frame, 0, 50);
        
        [UIView commitAnimations];
        
        bannerIsVisible = NO;
    }
}

@end
