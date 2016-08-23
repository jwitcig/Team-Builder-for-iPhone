//
//  PlayersViewController.m
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import "PlayersViewController.h"

#import "PlayerHolder.h"

@interface PlayersViewController ()

@end

@implementation PlayersViewController {
    UITextField *textFieldInEdit;
    int playerCount;
    
    NSMutableArray *playerHolders;
}

@synthesize scrollView;
@synthesize scrollViewContentView;

@synthesize removePlayerButton;

@synthesize continueButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    textFieldInEdit = [[UITextField alloc] init];
    continueButton.enabled = NO;
    continueButton.alpha = 0.4f;
    
    playerCount = 4;
    
    players = [NSMutableArray array];
    playerHolders = [NSMutableArray array];
        
    [self buildEntryFormForNumberOfPlayers:playerCount];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTap)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)buildEntryFormForNumberOfPlayers:(int)numberOfPlayers {
    NSLayoutAnchor *aboveAnchor = scrollViewContentView.topAnchor;
    NSLayoutConstraint *belowAnchorConstraint;
    for (int i=0; i<numberOfPlayers; i++) {
        PlayerHolder *playerHolder;
        if (i < playerHolders.count) {
            playerHolder = playerHolders[i];
        } else {
            playerHolder = [[PlayerHolder alloc] initWithSelectionType:selectionType];
            [playerHolders addObject:playerHolder];
        }
        
        if (selectionType == SELECTION_TYPE_SKILL) {
            playerHolder.skillField.delegate = self;
        }
        
        playerHolder.nameField.delegate = self;

        [playerHolder.nameField addTarget:self action:@selector(nameFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [scrollViewContentView addSubview:playerHolder];
        
        [NSLayoutConstraint activateConstraints: @[
           [playerHolder.leadingAnchor constraintEqualToAnchor:scrollViewContentView.leadingAnchor constant:20], [scrollViewContentView.trailingAnchor constraintEqualToAnchor:playerHolder.trailingAnchor constant:20], [playerHolder.topAnchor constraintEqualToAnchor:aboveAnchor constant:20], [playerHolder.heightAnchor constraintEqualToConstant:20]
        ]];
        
        aboveAnchor = playerHolder.bottomAnchor;
        
        if (belowAnchorConstraint != nil) {
            [scrollViewContentView removeConstraint:belowAnchorConstraint];
        }
        
        belowAnchorConstraint = [scrollViewContentView.bottomAnchor constraintEqualToAnchor:playerHolder.bottomAnchor constant:20];
        
        [NSLayoutConstraint activateConstraints:@[belowAnchorConstraint]];
    }
}

- (BOOL)completionTest {
    for (PlayerHolder *playerHolder in playerHolders) {
        if ([playerHolder.nameField.text isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (void)playerCountChanged {
    NSMutableArray *playerHoldersToRemove = [NSMutableArray array];
    
    for (PlayerHolder *playerHolder in playerHolders) {
        NSUInteger i = [playerHolders indexOfObject:playerHolder];
        
        if (playerHolder.nameField.text != nil) {
            Player *player = [[Player alloc] init];
            player.name = playerHolder.nameField.text;
            
            if (playerHolder.skillField.text != nil) {
                player.skill = playerHolder.skillField.text.intValue;
            }
            
            [players addObject:player];
        }
        
        [playerHolder removeFromSuperview];
        
        if (i >= playerCount) {
            [playerHoldersToRemove addObject:playerHolder];
        }
    }
    
    [playerHolders removeObjectsInArray:playerHoldersToRemove];
    
    [self buildEntryFormForNumberOfPlayers:playerCount];
}

- (void)mainViewTap {
    [textFieldInEdit resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textFieldInEdit = textField;
}

- (void)updateContinueButton {
    if ([self completionTest]) {
        continueButton.enabled = YES;
        continueButton.alpha = 1.0f;
    } else {
        continueButton.enabled = NO;
        continueButton.alpha = 0.4f;
    }
}

- (void)nameFieldTextChanged:(UITextField *)textField {
    [self updateContinueButton];
}

- (IBAction)addPlayerPressed:(UIButton *)button {
    playerCount++;
    
    [self playerCountChanged];
    
    if (playerCount > 3) {
        removePlayerButton.enabled = true;
    }
    
    [self updateContinueButton];
}

- (IBAction)removePlayerPressed:(UIButton *)button {
    if (playerCount > 3) {
        playerCount--;
        
        [self playerCountChanged];
    }
    
    if (playerCount == 3) {
        removePlayerButton.enabled = false;
    }

    [self updateContinueButton];
}

- (IBAction)continuePressed:(UIButton *)button {
    if ([self completionTest]) {
        players = [NSMutableArray array];

        for (PlayerHolder *playerHolder in playerHolders) {
            Player *player = [[Player alloc] init];
            
            player.name = playerHolder.nameField.text;
            player.skill = playerHolder.skillField.text.intValue;
            
            [players addObject:player];
        }
    }
}

- (IBAction)skillBasedPressed:(UIButton *)button {
    selectionType = SELECTION_TYPE_SKILL;
}

@end