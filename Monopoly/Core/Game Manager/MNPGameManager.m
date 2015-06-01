//
//  MNPGameManager.m
//  Monopoly
//
//  Created by Andrew Raukut on 28.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPGameManager.h"
#import "MNPDice.h"
#import "MNPPlayer.h"
#import "MNPSpace.h"
#import "MNPConstants.h"

@interface MNPGameManager ()

@property (nonatomic, strong) MNPDataManager *dataManager;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, assign) NSInteger currentPlayerIndex;

@property (nonatomic, strong) NSArray *spaceList; // From Monopoly Spaces plist
@property (nonatomic, strong) NSMutableArray *monopolySpaces;

@end


@implementation MNPGameManager


#pragma mark - Singleton Implementation

+ (id)sharedManager {

  static MNPGameManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [MNPGameManager new];
  });
  return sharedManager;
}

- (instancetype)init {

  self = [super init];
  if (self) {
    
    self.currentPlayerIndex = 0;
    self.dataManager = [MNPDataManager sharedManager];
    self.dataManager.delegate = self;
    [self.dataManager preparePlayersInformation];

    NSString *path = [[NSBundle mainBundle] pathForResource: @"MonopolySpaces" ofType: @"plist"];
    self.spaceList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.monopolySpaces = [[NSMutableArray alloc] init];
    for (NSDictionary *spaceDict in self.spaceList) {
      MNPSpace *currentSpace = [[MNPSpace alloc] init];
      if (spaceDict[@"cost"]) {
        currentSpace.owner = nil;
        currentSpace.cost = [spaceDict[@"cost"] integerValue];
        currentSpace.factoryName = spaceDict[@"title"];
        currentSpace.rent = spaceDict[@"rent"];
      }
      [self.monopolySpaces addObject:currentSpace];
    }
  }
  return self;
}


#pragma mark - Public methods


- (MNPPlayer *)getCurrentPlayerInfo {
  return self.players[self.currentPlayerIndex];
}

- (NSInteger)getNumberOfExistPlayers {
  return self.players.count;
}

- (void)performCurrentPlayerActionWithDice:(NSNumber *)diceRoll {

  MNPPlayer *currentPlayer = [self.players objectAtIndex:self.currentPlayerIndex];
  NSInteger nextSpace = currentPlayer.currentSpace + [diceRoll integerValue];
  if (nextSpace > 39) {
    nextSpace %= kMNPSpaceCount;
    currentPlayer.playerCash += 200;
    if ([self.delegate respondsToSelector:@selector(gameManager:didPerformTakeSalary:forCurrentPlayer:)]) {

      [self.delegate gameManager:self didPerformTakeSalary:@(200) forCurrentPlayer:currentPlayer];
    }
  }

  currentPlayer.currentSpace = nextSpace;

  srand((unsigned)time(0));

  NSDictionary *currentSpace = _spaceList[nextSpace];

  
// space type 4

  if ([currentSpace[@"spaceType"] isEqualToValue:@(4)]) {
    
    if ([currentSpace[@"title"] isEqualToString:@"Community Chest"]) {

      NSInteger chestType = rand()%2;
      if (chestType == 0) { // Pay a tax 100
        if ([self.delegate respondsToSelector:@selector(gameManager:didPerformPayTax:forCurrentPlayer:)]) {

          currentPlayer.playerCash -= 100;
          if (![self validatePlayerCashForGame:currentPlayer]) {
          }
          [self.delegate gameManager:self didPerformPayTax:@(100) forCurrentPlayer:currentPlayer];
        }
      } else if (chestType == 1) { // Recieve a money 100
          if ([self.delegate respondsToSelector:@selector(gameManager:didPerformTakeSalary:forCurrentPlayer:)]) {

            currentPlayer.playerCash += 100;
            [self.delegate gameManager:self didPerformTakeSalary:@(100) forCurrentPlayer:currentPlayer];
          }
        }
      } else if ([currentSpace[@"title"]isEqualToString:@"Income Tax"]) {

          NSNumber *cost = currentSpace[@"cost"];
          currentPlayer.playerCash -= [cost integerValue];
          if (![self validatePlayerCashForGame:currentPlayer]) {
          }
          if ([self.delegate respondsToSelector:@selector(gameManager:didPerformPayTax:forCurrentPlayer:)]) {

            [self.delegate gameManager:self didPerformPayTax:cost forCurrentPlayer:currentPlayer];
          }

      } else if ([currentSpace[@"title"]isEqualToString:@"Super Tax"]) {

          NSNumber *cost = currentSpace[@"cost"];
          currentPlayer.playerCash -= [cost integerValue];
          if (![self validatePlayerCashForGame:currentPlayer]) {}

          if ([self.delegate respondsToSelector:@selector(gameManager:didPerformPayTax:forCurrentPlayer:)]) {

            [self.delegate gameManager:self didPerformPayTax:cost forCurrentPlayer:currentPlayer];
          }
      } else if ([currentSpace[@"title"] isEqualToString:@"Chance"]) {

          NSInteger chanceType = rand()%2;

          if (chanceType == 0) { // Go to jail

            if ([self.delegate respondsToSelector:@selector(gameManager:didPerformGoToJailForCurrentPlayer:)]) {
              [self.delegate gameManager:self didPerformGoToJailForCurrentPlayer:currentPlayer];
            }
      } else if (chanceType == 1) { // Get a key from jail

          currentPlayer.playerGetOutOfJailFree = YES;
          if ([self.delegate respondsToSelector:@selector(gameManager:didPerformGetFreeKeyFromJailForCurrentPlayer:)]) {

            [self.delegate gameManager:self didPerformGetFreeKeyFromJailForCurrentPlayer:currentPlayer];
          }
      }
      } else if ([currentSpace[@"title"] isEqualToString:@"Go to Jail"]) {
        if ([self.delegate respondsToSelector:@selector(gameManager:didPerformGoToJailForCurrentPlayer:)]) {
          [self.delegate gameManager:self didPerformGoToJailForCurrentPlayer:currentPlayer];
        }
      }
  }

// Space type - 0
  else if ([currentSpace[@"spaceType"] isEqualToValue:@(0)]) {
    if ([currentSpace[@"title"] isEqualToString:@"Free Parking"]) {
      if ([self.delegate respondsToSelector:@selector(gameManager:didPerfromGoToFreeParkingForCurrentPlayer:)]) {
        [self.delegate gameManager:self didPerfromGoToFreeParkingForCurrentPlayer:currentPlayer];
      }
    }
  }


// Space type 2
  else if ([currentSpace[@"spaceType"] isEqualToValue:@(2)]) { // Municipal factory

    // check if factory have owner
    MNPSpace *monopolySpace = _monopolySpaces[nextSpace];
    if (monopolySpace.owner) {

      if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayer:mustPayMoney:toFactoryOwner:)]) {
        NSInteger rentCost = 10;
        if (currentPlayer.numberOfOwnMunicipalFactory == 1)
          rentCost *=4;
        else rentCost *= 10;
        [self.delegate gameManager:self currentPlayer:currentPlayer mustPayMoney:rentCost toFactoryOwner:monopolySpace.owner];
      }
    } else {
      // send offer to current player
      if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayer:stayAtFreeMunicipalFactory:)]) {
        [self.delegate gameManager:self currentPlayer:currentPlayer stayAtFreeMunicipalFactory:monopolySpace];
      }
    }
  }


// Space type 1
  else if ([currentSpace[@"spaceType"] isEqualToValue:@(1)]) { // Railroad
    MNPSpace *monopolySpace = _monopolySpaces[nextSpace];

    if (monopolySpace.owner) {
      if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayer:mustPayMoney:toRailroadOwner:)]) {

        MNPPlayer *owner = monopolySpace.owner;
        NSInteger rentCost = [monopolySpace.rent[owner.numberOfOwnRailroad - 1] integerValue];
        [self.delegate gameManager:self currentPlayer:currentPlayer mustPayMoney:rentCost toRailroadOwner:owner];
      }
    } else {

      if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayer:stayAtFreeRailroad:)]) {
        [self.delegate gameManager:self currentPlayer:currentPlayer stayAtFreeRailroad:monopolySpace];
      }
    }
    
  }


  if ([_delegate respondsToSelector:@selector(gameManager:didPerformActionWithPlayer:withNumberDice:)]) {
    [_delegate gameManager:self didPerformActionWithPlayer:currentPlayer withNumberDice:[diceRoll integerValue]];
  }
  ++self.currentPlayerIndex;
  self.currentPlayerIndex %= self.players.count;
}


- (void)performCurrentPlayerActionInFreeParking {

  if ([_delegate respondsToSelector:@selector(gameManager:didPerformActionWithPlayerInFreeParking:)]) {
    [self.delegate gameManager:self didPerformActionWithPlayerInFreeParking:_players[_currentPlayerIndex]];
  }

  ++self.currentPlayerIndex;
  self.currentPlayerIndex %= self.players.count;
}

- (void)performCurrentPlayerActionInJail {

  if ([_delegate respondsToSelector:@selector(gameManager:didPerformActionWithPlayerInJail:)]) {
    [self.delegate gameManager:self didPerformActionWithPlayerInJail:_players[_currentPlayerIndex]];
  }

  ++self.currentPlayerIndex;
  self.currentPlayerIndex %= self.players.count;
}

- (void)player:(MNPPlayer *)player getSalaryAtTheRateOf:(NSInteger)cost {
  player.playerCash += cost;
}

- (void)playerRescuedFromJailByFreeKey:(MNPPlayer *)player {

  player.playerInJail = NO;
  player.countOfFreeRolling = 0;
  player.playerGetOutOfJailFree = 0;
}

- (void)player:(MNPPlayer *)player rescuedFromJailByMoney:(NSInteger)cost {

  player.playerInJail = NO;
  player.countOfFreeRolling = 0;
  player.playerCash -= 50;
  if (![self validatePlayerCashForGame:player]) {
  }
  if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayerSuccesfullyPaidRent:)]) {
    [self.delegate gameManager:self currentPlayerSuccesfullyPaidRent:player];
  }
}

- (void)player:(MNPPlayer *)player mustPaytaxAtTheRateOf:(NSInteger)tax {

  player.playerCash -= tax;
  if (![self validatePlayerCashForGame:player]){
  }
  if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayerSuccesfullyPaidRent:)]) {
    [self.delegate gameManager:self currentPlayerSuccesfullyPaidRent:player];
  }
}

- (void)player:(MNPPlayer *)player mustPayRentToFactoryOwner:(MNPPlayer *)owner atTheRateOf:(NSInteger)rent {

  player.playerCash -= rent;
  owner.playerCash += rent;
  if (![self validatePlayerCashForGame:player]) {
  }
  if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayerSuccesfullyPaidRent:)]) {
    [self.delegate gameManager:self currentPlayerSuccesfullyPaidRent:player];
  }
}

- (void)player:(MNPPlayer *)player mustPayRentToRailroadOwner:(MNPPlayer *)owner atTheRateOf:(NSInteger)rent {
  player.playerCash -= rent;
  owner.playerCash += rent;
  if (![self validatePlayerCashForGame:player]){
  }
  if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayerSuccesfullyPaidRent:)]) {
    [self.delegate gameManager:self currentPlayerSuccesfullyPaidRent:player];
  }
}

- (void)player:(MNPPlayer *)player buyFactoryAtSpace:(MNPSpace *)space {

  space.owner = player;
  player.numberOfOwnMunicipalFactory++;
  player.playerCash -= space.cost;
  if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayerSuccesfullyBuyFactory:)]) {
    [self.delegate gameManager:self currentPlayerSuccesfullyBuyFactory:player];
  }
}

- (void)player:(MNPPlayer *)player buyRailroadAtSpace:(MNPSpace *)space {

  space.owner = player;
  player.numberOfOwnRailroad++;
  player.playerCash -= space.cost;
  if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayerSuccesfullyBuyRailroad:)]) {
    [self.delegate gameManager:self currentPlayerSuccesfullyBuyRailroad:player];
  }
}

#pragma mark - Private methods

- (BOOL)validatePlayerCashForGame:(MNPPlayer *)player {

  if (player.playerCash > 0) return YES;

  else {
    if ([self.delegate respondsToSelector:@selector(gameManager:currentPlayerKnockoutFromGame:)]) {
      [self.delegate gameManager:self currentPlayerKnockoutFromGame:player];
    }
    --_currentPlayerIndex;
    [self.players removeObject:player];
    return NO;
  }
}

#pragma mark - MNPDataManager delegate methods

- (void)dataManager:(MNPDataManager *)dataManager didRecievePlayersInformation:(NSArray *)players {
  
  self.players = [NSMutableArray arrayWithArray:players];
//  MNPPlayer *playerTwo = self.players[1];
//  playerTwo.playerCash = 1000000;
}

@end
