//
//  PlayerHolder.m
//  Team Builder for iPhone
//
//  Created by Developer on 3/25/16.
//  Copyright © 2016 Jwit Apps. All rights reserved.
//

#import "PlayerHolder.h"

@implementation PlayerHolder

@synthesize nameField;
@synthesize skillField;

- (instancetype)initWithSelectionType: (int)selectionType {
    self = [super init];

    self.translatesAutoresizingMaskIntoConstraints = false;

    self.nameField = [[UITextField alloc] init];
    self.nameField.translatesAutoresizingMaskIntoConstraints = false;
    self.nameField.layer.cornerRadius = 10;
    self.nameField.textAlignment = NSTextAlignmentCenter;
    self.nameField.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:nameField];

    if (selectionType == SELECTION_TYPE_SKILL) {
        self.skillField = [[UITextField alloc] init];
        self.skillField.translatesAutoresizingMaskIntoConstraints = false;
        self.skillField.layer.cornerRadius = 10;
        self.skillField.backgroundColor = [UIColor lightGrayColor];
        self.skillField.keyboardType = UIKeyboardTypeNumberPad;
        self.skillField.textAlignment = NSTextAlignmentCenter;
        self.skillField.tag = self.tag+1000;
        self.skillField.text = @"0";
        [self addSubview:skillField];
        
        [NSLayoutConstraint activateConstraints: @[
           [self.nameField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
           [self.nameField.trailingAnchor constraintEqualToAnchor:self.skillField.leadingAnchor constant:-20],
           [self.skillField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

           [self.nameField.topAnchor constraintEqualToAnchor:self.topAnchor],
           [self.nameField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
           
           [self.skillField.topAnchor constraintEqualToAnchor:self.topAnchor],
           [self.skillField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

           [self.skillField.widthAnchor constraintEqualToConstant: 30],
        ]];
    } else {
        [NSLayoutConstraint activateConstraints: @[
           [self.nameField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
           [self.nameField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
           [self.nameField.topAnchor constraintEqualToAnchor:self.topAnchor],
           [self.nameField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
    }
    
   
    
    return self;
}

@end
