//
//  PlayerHolder.h
//  Team Builder for iPhone
//
//  Created by Developer on 3/25/16.
//  Copyright © 2016 Jwit Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerHolder : UIView

@property UITextField *nameField;
@property UITextField *skillField;

- (instancetype)initWithSelectionType: (int)selectionType;

@end

CGSize screenSize;

NSMutableArray *players;
int selectionType;

int SELECTION_TYPE_RANDOM;
int SELECTION_TYPE_SKILL;
