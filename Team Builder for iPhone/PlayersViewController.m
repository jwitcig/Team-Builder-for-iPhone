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
    
    NSMutableArray *existingInformation;
    
    BOOL bannerIsVisible;
}

@synthesize continueButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    textFieldInEdit = [[UITextField alloc] init];
    continueButton.enabled = NO;
    continueButton.alpha = 0.4f;
    
    [self clearExistingInformation];
    
    [self addPlayerCountStepper];
    [self buildEntryFormForNumberOfPlayers:playerCountStepper.value];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTap)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)clearExistingInformation {
    existingInformation = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
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
        nameField.text = @"";
        [nameField addTarget:self action:@selector(nameFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        
        NSArray *existingNames = [NSArray arrayWithArray:[existingInformation objectAtIndex:0]];
        NSArray *existingSkills = [NSArray arrayWithArray:[existingInformation objectAtIndex:1]];
        
        NSLog(@"%@ : %i", existingNames, existingNames.count);
        
        if (i < existingNames.count)
            nameField.text = [existingNames objectAtIndex:i];
        playerHolderWidth = CGRectGetMaxX(nameField.frame);
        
        if (selectionType == SELECTION_TYPE_SKILL) {
            UITextField *skillField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameField.frame)+10, 0, screenSize.width/10, CGRectGetHeight(nameField.frame))];
            skillField.delegate = self;
            skillField.backgroundColor = [UIColor lightGrayColor];
            skillField.keyboardType = UIKeyboardTypeNumberPad;
            skillField.tag = playerHolder.tag+1000;
            skillField.text = @"0";
            if (i < existingSkills.count)
                skillField.text = [[existingSkills objectAtIndex:i] stringValue];
            
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
    
    [self clearExistingInformation];
    UIScrollView *scroller = (UIScrollView *)[self.view viewWithTag:-2];
    
    for (UIView *playerHolder in scroller.subviews) {
        UITextField *nameField = (UITextField *)[playerHolder viewWithTag:playerHolder.tag+100];
        if ([nameField.text isEqualToString:@""])
            pass = NO;
    }
    return pass;
}

- (void)playerCountChanged:(UIStepper *)stepper {
    [self clearExistingInformation];
    UIScrollView *scroller = (UIScrollView *)[self.view viewWithTag:-2];
    
    for (UIView *playerHolder in scroller.subviews) {
        UITextField *nameField = (UITextField *)[playerHolder viewWithTag:playerHolder.tag+100];
        UITextField *skillField = (UITextField *)[playerHolder viewWithTag:playerHolder.tag+1000];
        
        if ([nameField.text isEqualToString:@""] || nameField.text == nil)
            NSLog(@"fixed");
        else
            NSLog(@"completed %@", nameField.text);
        
        if (nameField.text != nil) {
            NSMutableArray *existingNames = [NSMutableArray arrayWithArray:[existingInformation objectAtIndex:0]];
            [existingNames addObject:nameField.text];
            [existingInformation replaceObjectAtIndex:0 withObject:existingNames];
        }
        if (skillField.text != nil) {
            NSMutableArray *existingSkills = [NSMutableArray arrayWithArray:[existingInformation objectAtIndex:1]];
            [existingSkills addObject:[NSNumber numberWithInt:skillField.text.intValue]];
            [existingInformation replaceObjectAtIndex:1 withObject:existingSkills];
        }
        
        
        NSLog(@"%@ : %i", [existingInformation objectAtIndex:0], [[existingInformation objectAtIndex:0] count]);
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

- (void)nameFieldTextChanged:(UITextField *)textField {
    if ([self completionTest]) {
        continueButton.enabled = YES;
        continueButton.alpha = 1.0f;
    } else {
        continueButton.enabled = NO;
        continueButton.alpha = 0.4f;
    }
    
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
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Form"
                                                        message:@"One or more fields have not been filled out properly."
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    for (Player *player in players) {
        NSLog(@"name : %@   skill : %i", player.name, player.skill);
    }
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