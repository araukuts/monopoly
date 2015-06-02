//
//  MNPPlayer.m
//  Monopoly
//
//  Created by Andrew Raukut on 21.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import "MNPPlayer.h"

@implementation MNPPlayer

- (instancetype)initPlayerWithName:(NSString *)playerName token:(UIImage *)playerToken {

  self = [super init];
  if (self) {

    self.playerName = playerName;
    self.playerToken = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.playerToken.image = playerToken;
    self.playerGetOutOfJailFree = NO;
    self.playerCash = 1500;
    self.currentLocation = CGPointMake(703, 829);
    self.houseImagePath = [[NSString alloc] init];
  }
  return self;
}

@end
