//
//  MNPGameManager.h
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNPGameManager;


@protocol MNPGameManagerDelegate <NSObject>

@required
- (void)gameManager:(MNPGameManager *)gameManager didRecievePlayersInformation:(NSArray *)players;


@end

@interface MNPGameManager : NSObject

@property (strong, nonatomic) id<MNPGameManagerDelegate> delegate;

+ (MNPGameManager *)sharedManager;
- (void)preparePlayersInformation;
- (void)savePlayersInformation:(NSArray *)playersInfo;

@end
