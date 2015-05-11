//
//  MNPGameManager.m
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPDataManager.h"
#import "MNPPlayer.h"

@interface MNPDataManager ()

@property (strong, nonatomic) NSArray *players;

@end

@implementation MNPDataManager


#pragma mark - Singleton Implementation

+ (id)sharedManager {

  static MNPDataManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [MNPDataManager new];
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

    if ([_delegate respondsToSelector:@selector(dataManager:didRecievePlayersInformation:)]) {
      [_delegate dataManager:self didRecievePlayersInformation:_players];
    }
  }
}

- (void)savePlayersInformation:(NSArray *)playersInfo {
  self.players = playersInfo;
}


@end
