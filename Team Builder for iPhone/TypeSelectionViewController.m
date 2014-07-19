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
    
    bannerIsVisible = NO;
    self.banner.delegate = self;
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
        
        bannerIsVisible = YES;
        banner.hidden = NO;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (bannerIsVisible) {
        NSLog(@"bannerView:didFailToReceiveAdWithError: %@", error);
        
        bannerIsVisible = NO;
        banner.hidden = YES;
    }
}

@end
