//
//  MPDBIntraction.h
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGlobalData.h"
@interface MPDBIntraction : NSObject
@property (nonatomic,retain) NSString *databaseName;
+ (id)databaseInteractionManager;
- (void)insertRegionList:(NSMutableArray *)arrholder;
- (void)insertAddresList:(NSMutableArray *)arrholder;
- (void)insertParkingList:(NSMutableArray *)arrholder;
- (void)insertHolidayList:(NSMutableArray *)arrholder;
- (void)insertfList:(FavoriteList *)dataHolder;
- (NSString *) getDatabasePathFromName:(NSString *)dbName;

- (void)getParkingFromDatabase:(int) parkingID;
- (void)getFavoriteListFromDatabase;

- (void)setLastActivityWithTime:(NSString*)time andRegionName: (NSString*) rName;

@end
