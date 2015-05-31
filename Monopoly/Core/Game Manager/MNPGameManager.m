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
#import "MNPConstants.h"

@interface MNPGameManager ()

@property (nonatomic, strong) MNPDataManager *dataManager;
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, assign) NSInteger currentPlayerIndex;

@property (nonatomic, strong) NSArray *spaceList;

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
    self.spaceList = [[NSArray alloc] initWithContentsOfFile:path];

  }
  return self;
}


#pragma mark - Public methods


- (MNPPlayer *)getCurrentPlayerInfo {
  return self.players[self.currentPlayerIndex];
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
  if ([currentSpace[@"spaceType"] isEqualToValue:@(4)]) {
    
    if ([currentSpace[@"title"] isEqualToString:@"Community Chest"]) {

      NSInteger chestType = rand()%2;
      if (chestType == 0) { // Pay a tax 100
        if ([self.delegate respondsToSelector:@selector(gameManager:didPerformPayTax:forCurrentPlayer:)]) {

          currentPlayer.playerCash -= 100;
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

          if ([self.delegate respondsToSelector:@selector(gameManager:didPerformPayTax:forCurrentPlayer:)]) {

            [self.delegate gameManager:self didPerformPayTax:cost forCurrentPlayer:currentPlayer];
          }

      } else if ([currentSpace[@"title"]isEqualToString:@"Super Tax"]) {

          NSNumber *cost = currentSpace[@"cost"];
          currentPlayer.playerCash -= [cost integerValue];

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

  if ([_delegate respondsToSelector:@selector(gameManager:didPerformActionWithPlayer:withNumberDice:)]) {
    [_delegate gameManager:self didPerformActionWithPlayer:currentPlayer withNumberDice:[diceRoll integerValue]];
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



#pragma mark - MNPDataManager delegate methods

- (void)dataManager:(MNPDataManager *)dataManager didRecievePlayersInformation:(NSArray *)players {
  
  self.players = players;
}

@end
