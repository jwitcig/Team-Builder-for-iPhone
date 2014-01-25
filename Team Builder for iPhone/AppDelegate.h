//
//  AppDelegate.h
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

CGSize screenSize;

NSMutableArray *players;
int selectionType;

int SELECTION_TYPE_RANDOM;
int SELECTION_TYPE_SKILL;