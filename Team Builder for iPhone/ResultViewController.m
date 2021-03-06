//
//  ResultViewController.m
//  Team Builder for iPhone
//
//  Created by Application Development on 1/6/14.
//  Copyright (c) 2014 Jwit Apps. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController {
    NSMutableArray *generatedPlayersList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    generatedPlayersList = [NSMutableArray array];
    
    if (selectionType == SELECTION_TYPE_RANDOM) {
        NSArray *randomPlayersList = [NSArray arrayWithArray:[self generateRandomTeams]];
        [self buildFormsForPlayers:randomPlayersList];
    } else if (selectionType == SELECTION_TYPE_SKILL) {
        NSMutableArray *combos = [NSMutableArray arrayWithArray:[self powerSet:players]];
        combos = [NSMutableArray arrayWithArray:[self trimNonusableCombos:combos]];
        
        int lowestDifference = 10000000;
        NSUInteger bestComboIndex = -1;
        for (NSArray *combo in combos) {
            int difference = [self comboScoreDifference:[self addOpponentToCombo:combo]];
            if (difference < lowestDifference) {
                lowestDifference = difference;
                bestComboIndex = [combos indexOfObject:combo];
            }
        }
        
        NSArray *bestCombo = [self addOpponentToCombo:[combos objectAtIndex:bestComboIndex]];
        NSMutableArray *playersList = [NSMutableArray array];
        [playersList addObjectsFromArray:[bestCombo firstObject]];
        [playersList addObjectsFromArray:[bestCombo lastObject]];
        for (Player *player in playersList)
            NSLog(@"%@", player.name);
        
        [self buildFormsForPlayers:playersList];
    }
    
}

- (NSArray *)addOpponentToCombo:(NSArray *)teamOne {
    NSMutableArray *teamTwo = [NSMutableArray arrayWithArray:players];
    [teamTwo removeObjectsInArray:teamOne];
    
    return [NSArray arrayWithObjects:teamOne, teamTwo, nil];
}

- (int)comboScoreDifference:(NSArray *)matchUp {
    NSArray *teamOne = [NSArray arrayWithArray:[matchUp firstObject]];
    NSArray *teamTwo = [NSArray arrayWithArray:[matchUp lastObject]];
    
    int teamOneScoreTotal = 0;
    int teamTwoScoreTotal = 0;
    for (Player *player in teamOne)
        teamOneScoreTotal += player.skill;
    for (Player *player in teamTwo)
        teamTwoScoreTotal += player.skill;
    
    int difference = abs(teamOneScoreTotal - teamTwoScoreTotal);
    return difference;
}

- (NSArray *)trimNonusableCombos:(NSMutableArray *)combos {
    NSMutableIndexSet *logToDelete = [NSMutableIndexSet indexSet];
    for (int i=0; i<combos.count; i++) {
        NSArray *combo = [NSArray arrayWithArray:[combos objectAtIndex:i]];
        
        if (combo.count != players.count/2) {
            [logToDelete addIndex:i];
        }
    }
    [combos removeObjectsAtIndexes:logToDelete];
    return combos;
}

- (void)buildFormsForPlayers:(NSArray *)playersList {
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-64))];
    
    int playerHolderWidth = 0;
    int controller = 0;
    for (int i=0; i<players.count; i++) {
        if (i >= (players.count/2))
            controller = i+1;
        else
            controller = i;
        
        UIView *playerHolder = [[UIView alloc] init];
        
        UILabel *nameDisplay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.height/3, 20)];
        nameDisplay.text = [(Player *)[playersList objectAtIndex:i] name];
        nameDisplay.tag = i+1;
        nameDisplay.textColor = [UIColor whiteColor];
        playerHolderWidth = CGRectGetMaxX(nameDisplay.frame);
        
        playerHolder.frame = CGRectMake(CGRectGetMidX(scroller.frame)-(playerHolderWidth/2), (controller*30)+40, playerHolderWidth, 20);
        [playerHolder addSubview:nameDisplay];
        
        if (selectionType == SELECTION_TYPE_SKILL) {
            UILabel *skillDisplay = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameDisplay.frame), 0, screenSize.height/4, 20)];
            skillDisplay.text = [NSString stringWithFormat:@"%i", [(Player *)[playersList objectAtIndex:i] skill]];
            skillDisplay.tag = i+1;
            skillDisplay.textColor = [UIColor whiteColor];
            playerHolderWidth = CGRectGetMaxX(skillDisplay.frame);
            [playerHolder addSubview:skillDisplay];
        }
        
        [scroller addSubview:playerHolder];
        scroller.contentSize = CGSizeMake(CGRectGetWidth(scroller.frame), CGRectGetMaxY(playerHolder.frame)+10);
        
        if (i == 0) {
            UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(scroller.frame)-(100), ((controller-1)*30)+40, 100, 20)];
            teamLabel.text = @"Team 1";
            teamLabel.font = [UIFont boldSystemFontOfSize:teamLabel.font.pointSize];
            teamLabel.textColor = [UIColor lightGrayColor];
            [scroller addSubview:teamLabel];
        } else if (i == (players.count/2)) {
            UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(scroller.frame)-(100), ((i )*30)+40, 100, 20)];
            teamLabel.text = @"Team 2";
            teamLabel.font = [UIFont boldSystemFontOfSize:teamLabel.font.pointSize];
            teamLabel.textColor = [UIColor lightGrayColor];
            [scroller addSubview:teamLabel];
        }
    }
    [self.view addSubview:scroller];
}

- (NSMutableArray *)namesFromPlayersArray:(NSArray *)array {
    NSMutableArray *names = [NSMutableArray array];
    for (Player *player in array)
        [names addObject:player.name];
    return names;
}

- (NSMutableArray *)generateRandomTeams {
    NSMutableArray *randomOrder = [NSMutableArray array];
    NSMutableArray *startPlayers = [NSMutableArray arrayWithArray:players];
    for (int i=0; i<players.count; i++) {
        int randomSelection = arc4random() % startPlayers.count;
        [randomOrder addObject:[startPlayers objectAtIndex:randomSelection]];
        [startPlayers removeObjectAtIndex:randomSelection];
    }
    return randomOrder;
}

- (NSArray *)powerSet:(NSArray *)array {
    
    NSInteger length = array.count;
    if (length == 0) return [NSArray arrayWithObject:[NSArray array]];
    
    // get an object from the array and the array without that object
    id lastObject = [array lastObject];
    NSArray *arrayLessOne = [array subarrayWithRange:NSMakeRange(0, length-1)];
    
    // compute the powerset of the array without that object
    // recursion makes me happy
    NSArray *powerSetLessOne = [self powerSet:arrayLessOne];
    
    // powerset is the union of the powerSetLessOne and powerSetLessOne where
    // each element is unioned with the removed element
    NSMutableArray *powerset = [NSMutableArray arrayWithArray:powerSetLessOne];
    
    // add the removed object to every element of the recursive power set
    for (NSArray *lessOneElement in powerSetLessOne) {
            [powerset addObject:[lessOneElement arrayByAddingObject:lastObject]];
    }
    return [NSArray arrayWithArray:powerset];
}


- (IBAction)skillBasedPressed:(UIButton *)button {
    selectionType = SELECTION_TYPE_SKILL;
}

@end
