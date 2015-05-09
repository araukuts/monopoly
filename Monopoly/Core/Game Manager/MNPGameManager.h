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

- (void)gameManager:(MNPGameManager *)gameManager didPerformActionWithPlayer:(MNPPlayer *)player;

@end


@interface MNPGameManager : NSObject <MNPDataManagerDelegate>

@property (nonatomic, strong) id <MNPGameManagerDelegate> delegate;

// Init methods

+ (id)sharedManager;

// Public methods

- (MNPPlayer *)getCurrentPlayerInfo;

// Performing player action

- (void)performCurrentPlayerAction;


@end
