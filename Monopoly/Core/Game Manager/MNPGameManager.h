//
//  MNPGameManager.h
//  Monopoly
//
//  Created by Andrew Raukut on 28.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNPDataManager.h"
#import "MNPPlayer.h"

@class MNPGameManager;


@protocol MNPGameManagerDelegate <NSObject>

@required

- (void)gameManager:(MNPGameManager *)gameManager
    didPerformActionWithPlayer:(MNPPlayer *)player
     withNumberDice:(NSInteger)rollDice;

- (void)gameManager:(MNPGameManager *)gameManager
didPerformActionWithPlayerInJail:(MNPPlayer *)player;

- (void)gameManager:(MNPGameManager *)gameManager
didPerformActionWithPlayerInFreeParking:(MNPPlayer *)player;

- (void)gameManager:(MNPGameManager *)gameManager
didPreparedGameWithPlayers:(NSArray *)players;

@optional

// Actions with specific types of space

// Go through space "GO"
- (void)gameManager:(MNPGameManager *)gameManager
    didPerformTakeSalary:(NSNumber *)salary
        forCurrentPlayer:(MNPPlayer *)player;


// Pay tax
- (void)gameManager:(MNPGameManager *)gameManager
   didPerformPayTax:(NSNumber *)tax
   forCurrentPlayer:(MNPPlayer *)player;


// Go to free parking

- (void)gameManager:(MNPGameManager *)gameManager
    didPerfromGoToFreeParkingForCurrentPlayer:(MNPPlayer *)player;

// Go to jail
- (void)gameManager:(MNPGameManager *)gameManager
    didPerformGoToJailForCurrentPlayer:(MNPPlayer *)player;

// Get free key from jail
- (void)gameManager:(MNPGameManager *)gameManager
    didPerformGetFreeKeyFromJailForCurrentPlayer:(MNPPlayer *)player;

@end


@interface MNPGameManager : NSObject <MNPDataManagerDelegate>

@property (nonatomic, strong) id <MNPGameManagerDelegate> delegate;

// Init methods

+ (id)sharedManager;

// Public methods

- (MNPPlayer *)getCurrentPlayerInfo;

// Performing player action

- (void)performCurrentPlayerActionWithDice:(NSNumber *)dice;
- (void)performCurrentPlayerActionInJail;
- (void)performCurrentPlayerActionInFreeParking;

@end
