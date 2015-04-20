//
//  MNPGameManager.m
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPGameManager.h"


@interface MNPGameManager ()

@property (strong, nonatomic) NSArray *players;

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
    return self;
}


#pragma mark - Public Methods

- (void)preparePlayersInformation {

  if ([_players count] > 0) {

    if ([_delegate respondsToSelector:@selector(gameManager:didRecievePlayersInformation:)]) {
      [_delegate gameManager:self didRecievePlayersInformation:_players];
    }
  }
}

- (void)savePlayersInformation:(NSArray *)playersInfo {
  self.players = playersInfo;
}


@end
