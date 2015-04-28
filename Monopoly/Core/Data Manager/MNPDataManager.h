//
//  MNPGameManager.h
//  Monopoly
//
//  Created by Andrew Raukut on 20.04.15.
//  Copyright (c) 2015 raukutsCorporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNPDataManager;


@protocol MNPDataManagerDelegate <NSObject>

@required
- (void)dataManager:(MNPDataManager *)dataManager didRecievePlayersInformation:(NSArray *)players;


@end

@interface MNPDataManager : NSObject

@property (strong, nonatomic) id<MNPDataManagerDelegate> delegate;

+ (MNPDataManager *)sharedManager;
- (void)preparePlayersInformation;
- (void)savePlayersInformation:(NSArray *)playersInfo;

@end
