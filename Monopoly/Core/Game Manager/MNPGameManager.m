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
  }
  return self;
}


#pragma mark - Public methods

- (void)performCurrentPlayerAction {

  MNPPlayer *currentPlayer = [self.players objectAtIndex:self.currentPlayerIndex];
  NSInteger nextSpace = currentPlayer.currentSpace + [MNPDice roll];
  if (nextSpace > 39) nextSpace %= kMNPSpaceCount;

  currentPlayer.currentSpace = nextSpace;
  /*
   
   
   SOME ACTION
   
   
   */


  if ([_delegate respondsToSelector:@selector(gameManager:didPerformActionWithPlayer:)]) {
    [_delegate gameManager:self didPerformActionWithPlayer:currentPlayer];
  }
}



#pragma mark - MNPDataManager delegate methods

- (void)dataManager:(MNPDataManager *)dataManager didRecievePlayersInformation:(NSArray *)players {
  
  self.players = players;
}

@end
