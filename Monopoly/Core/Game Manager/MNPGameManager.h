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

@class MNPGameManager, MNPSpace;


@protocol MNPGameManagerDelegate <NSObject>

@optional

- (void)gameManager:(MNPGameManager *)gameManager
    didPerformActionWithPlayer:(MNPPlayer *)player
     withNumberDice:(NSInteger)rollDice;

- (void)gameManager:(MNPGameManager *)gameManager
didPerformActionWithPlayerInJail:(MNPPlayer *)player;

- (void)gameManager:(MNPGameManager *)gameManager
didPerformActionWithPlayerInFreeParking:(MNPPlayer *)player;

- (void)gameManager:(MNPGameManager *)gameManager
didPreparedGameWithPlayers:(NSArray *)players;

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

// Stay in municipal Factory

- (void)gameManager:(MNPGameManager *)gameManager
      currentPlayer:(MNPPlayer *)player
       mustPayMoney:(NSInteger )cost
     toFactoryOwner:(MNPPlayer *)factoryOwner;

- (void)gameManager:(MNPGameManager *)gameManager
        currentPlayer:(MNPPlayer *)player
stayAtFreeMunicipalFactory:(MNPSpace *)space;


// Stay at railroad

- (void)gameManager:(MNPGameManager *)gameManager
      currentPlayer:(MNPPlayer *)player
       mustPayMoney:(NSInteger)cost
    toRailroadOwner:(MNPPlayer *)railroadOwner;

- (void)gameManager:(MNPGameManager *)gameManager
    currentPlayer:(MNPPlayer *)player
 stayAtFreeRailroad:(MNPSpace *)space;


// Stay at Building

- (void)gameManager:(MNPGameManager *)gameManager
    currentPlayer:(MNPPlayer *)player
    mustPayMoney:(NSInteger)cost
    toBuildingOwner:(MNPPlayer *)buildingOwner;

- (void)gameManager:(MNPGameManager *)gameManager
    currentPlayer:(MNPPlayer *)player
 stayAtFreeBuilding:(MNPSpace *)space;

- (void)gameManager:(MNPGameManager *)gameManager
      currentPlayer:(MNPPlayer *)player
  stayAtOwnBuilding:(MNPSpace *)space;

//Successfull buying

- (void)gameManager:(MNPGameManager *)gameManager
currentPlayerSuccesfullyBuyFactory:(MNPPlayer *)player;

- (void)gameManager:(MNPGameManager *)gameManager
currentPlayerSuccesfullyBuyRailroad:(MNPPlayer *)playr;

- (void)gameManager:(MNPGameManager *)gameManager
currentPlayerSuccesfullyPaidRent:(MNPPlayer *)player;

- (void)gameManager:(MNPGameManager *)gameManager
currentPlayerSuccesfullyBuyBuilding:(MNPPlayer *)player;

// Succesfull update

- (void)gameManager:(MNPGameManager *)gameManager
currentPLayerSuccesfullyUpdateBuilding:(MNPPlayer *)player;


// Player deleted
- (void)gameManager:(MNPGameManager *)gameManager
currentPlayerKnockoutFromGame:(MNPPlayer *)player;


@end


@interface MNPGameManager : NSObject <MNPDataManagerDelegate>

@property (nonatomic, strong) id <MNPGameManagerDelegate> delegate;

// Init methods

+ (id)sharedManager;
- (void)updateGameManager;

// Public methods

- (MNPPlayer *)getCurrentPlayerInfo;

// Performing player action

- (void)performCurrentPlayerActionWithDice:(NSNumber *)dice;
- (void)performCurrentPlayerActionInJail;
- (void)performCurrentPlayerActionInFreeParking;

- (void)player:(MNPPlayer *)player getSalaryAtTheRateOf:(NSInteger)cost;

- (void)playerRescuedFromJailByFreeKey:(MNPPlayer *)player;
- (void)player:(MNPPlayer *)player rescuedFromJailByMoney:(NSInteger)cost;

- (void)player:(MNPPlayer *)player mustPaytaxAtTheRateOf:(NSInteger)tax;
- (void)player:(MNPPlayer *)player mustPayRentToFactoryOwner:(MNPPlayer *)owner atTheRateOf:(NSInteger)rent;
- (void)player:(MNPPlayer *)player mustPayRentToRailroadOwner:(MNPPlayer *)owner atTheRateOf:(NSInteger)rent;
- (void)player:(MNPPlayer *)player mustPayRentToBuildingOwner:(MNPPlayer *)owner atTheRateOf:(NSInteger)rent;


- (void)player:(MNPPlayer *)player buyBuildingAtSpace:(MNPSpace *)space;
- (void)player:(MNPPlayer *)player buyFactoryAtSpace:(MNPSpace *)space;
- (void)player:(MNPPlayer *)player buyRailroadAtSpace:(MNPSpace *)space;

- (void)player:(MNPPlayer *)player updateBuildingAtSpace:(MNPSpace *)space;

- (NSInteger)getNumberOfExistPlayers;

@end
