//
//  PlayersViewController.m
//  Team Builder for iPhone
//
//  Created by Application Development on 1/4/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import "PlayersViewController.h"

@interface PlayersViewController ()

@end

@implementation PlayersViewController {
    UITextField *textFieldInEdit;
    UIStepper *playerCountStepper;
    
    NSMutableArray *existingPlayersNames;
}

@synthesize continueButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    textFieldInEdit = [[UITextField alloc] init];
    
    existingPlayersNames = [NSMutableArray array];
    
    [self addPlayerCountStepper];
    [self buildEntryFormForNumberOfPlayers:playerCountStepper.value];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTap)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)addPlayerCountStepper {
    playerCountStepper = [[UIStepper alloc] init];
    playerCountStepper.frame = CGRectMake(CGRectGetMidX(self.view.frame)-(CGRectGetWidth(playerCountStepper.frame)/2), 10, CGRectGetWidth(playerCountStepper.frame), CGRectGetHeight(playerCountStepper.frame));
    playerCountStepper.value = 4.0;
    playerCountStepper.minimumValue = 3.0;
    playerCountStepper.tag = -1;
    [playerCountStepper addTarget:self action:@selector(playerCountChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:playerCountStepper];
}

- (void)buildEntryFormForNumberOfPlayers:(int)numberOfPlayers {
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(playerCountStepper.frame)+10, self.view.frame.size.width, (self.view.frame.size.height-64)-(self.view.frame.size.height-CGRectGetMinY(continueButton.frame)))];
    scroller.tag = -2;
    
    int playerHolderWidth = 0;
    for (int i=0; i<numberOfPlayers; i++) {
        UIView *playerHolder = [[UIView alloc] init];
        playerHolder.tag = i+1;
        
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, screenSize.height/3, 20)];
        nameField.delegate = self;
        nameField.backgroundColor = [UIColor lightGrayColor];
        nameField.tag = playerHolder.tag+100;
        if (i < existingPlayersNames.count)
            nameField.text = [existingPlayersNames objectAtIndex:i];
        playerHolderWidth = CGRectGetMaxX(nameField.frame);
        
        if (selectionType == SELECTION_TYPE_SKILL) {
            UITextField *skillField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameField.frame)+10, 0, screenSize.width/10, CGRectGetHeight(nameField.frame))];
            skillField.delegate = self;
            skillField.backgroundColor = [UIColor lightGrayColor];
            skillField.keyboardType = UIKeyboardTypeNumberPad;
            skillField.tag = playerHolder.tag+1000;
            
            [playerHolder addSubview:skillField];
            playerHolderWidth = CGRectGetMaxX(skillField.frame);
        }
        
        playerHolder.frame = CGRectMake(CGRectGetMidX(scroller.frame)-(playerHolderWidth/2), (i*30), playerHolderWidth, 20);
        [playerHolder addSubview:nameField];
        
        [scroller addSubview:playerHolder];
        scroller.contentSize = CGSizeMake(CGRectGetWidth(scroller.frame), CGRectGetMaxY(playerHolder.frame)+10);
    }
    
    [self.view addSubview:scroller];
}

- (BOOL)completionTest {
    BOOL pass = YES;
    
    existingPlayersNames = [NSMutableArray array];
    UIScrollView *scroller = (UIScrollView *)[self.view viewWithTag:-2];
    
    for (UIView *playerHolder in scroller.subviews) {
        UITextField *nameField = (UITextField *)[playerHolder viewWithTag:playerHolder.tag+100];
        if ([nameField.text isEqualToString:@""])
            pass = NO;
    }
    return pass;
}

- (void)playerCountChanged:(UIStepper *)stepper {
    existingPlayersNames = [NSMutableArray array];
    UIScrollView *scroller = (UIScrollView *)[self.view viewWithTag:-2];
    
    for (UIView *playerHolder in scroller.subviews) {
        UITextField *nameField = (UITextField *)[playerHolder viewWithTag:playerHolder.tag+100];
        if ([nameField.text isEqualToString:@""] || [nameField.text isEqualToString:nil]) {
            NSLog(@"fixed");
            nameField.text = @"aaa";
        }
        else
            NSLog(@"completed %@", nameField.text);
        [existingPlayersNames addObject:nameField.text];
    }
    
    for (UIView *view in scroller.subviews) {
        [view removeFromSuperview];
    }
    
    [scroller removeFromSuperview];
    
    [self buildEntryFormForNumberOfPlayers:stepper.value];
}

- (void)mainViewTap {
    [textFieldInEdit resignFirstResponder];
    NSLog(@"tapped");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textFieldInEdit = textField;
    NSLog(@"selected");
}

- (IBAction)continuePressed:(UIButton *)button {
    if ([self completionTest]) {
        players = [NSMutableArray array];
        for (UIView *scroller in self.view.subviews) {
            for (UIView *container in scroller.subviews) {
                for (UIView *view in container.subviews) {
                    if (view.tag > 0 && view.tag < 1000) {
                        UITextField *nameField = (UITextField *)view;
                        Player *newPlayer = [[Player alloc] init];
                        newPlayer.name = nameField.text;
                        if (selectionType == SELECTION_TYPE_SKILL) {
                            UITextField *skillField = (UITextField *)[self.view viewWithTag:view.tag+900];
                            newPlayer.skill = skillField.text.intValue;
                        }
                        [players addObject:newPlayer];
                        NSLog(@"added player");
                    }
                }
            }
        }
    }
    
    for (Player *player in players) {
        NSLog(@"name : %@   skill : %i", player.name, player.skill);
    }
}

@end