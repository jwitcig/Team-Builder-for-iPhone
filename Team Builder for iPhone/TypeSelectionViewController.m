//
//  ViewController.m
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import "TypeSelectionViewController.h"

@interface TypeSelectionViewController ()

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

@end
