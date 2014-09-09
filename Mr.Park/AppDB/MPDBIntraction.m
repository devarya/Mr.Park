//
//  MPDBIntraction.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPDBIntraction.h"
MPDBIntraction *databaseManager = nil;
@implementation MPDBIntraction
@synthesize databaseName;

+ (id)databaseInteractionManager
{
    @synchronized(self)
    {
        if (databaseManager == nil)
        {
            databaseManager = [[self alloc] init];
        }
    }
    return databaseManager;
}

- (id)init
{
    if (self = [super init])
    {
        mrParkDB  = [[FMDatabase alloc] initWithPath:[self getDatabasePathFromName:DBname]];
    }
    return self;
}

- (NSString *) getDatabasePathFromName:(NSString *)dbName
{
	return [self getDatabaseFolderPath:dbName];
}

-(NSString *) getDatabaseFolderPath : (NSString *)dbName
{
	databaseName = [dbName stringByAppendingString:@".sqlite"];
	NSString *databasePath = [[self getDocumentsDirectoryPath] stringByAppendingPathComponent:databaseName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:databasePath]) return databasePath;
	else
    {
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	}
	return databasePath;
}

- (NSString *) getDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

#pragma insert region

-(void)insertRegionList:(NSMutableArray *)arrholder
{
    [mrParkDB open];
    for (int i=0; i<arrholder.count;i++)
    {
        
        Region *dataHolder=[arrholder objectAtIndex:i];
        NSString *query=[NSString stringWithFormat:@"delete from regionTable where region_id = %@", dataHolder.str_region_id];
        @try
        {
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully delete one row with id = %@ in region table", dataHolder.str_region_id);
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
        query=[NSString stringWithFormat:@"insert into regionTable(region_id, state_id, region_name) values(\"%@\",\"%@\",\"%@\")", dataHolder.str_region_id, dataHolder.str_state_id, dataHolder.str_region_name];
        @try
        {
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully inserted to region table");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
    }
    NSString *query=[NSString stringWithFormat:@"update regionTable set update_at = \"%@\"", regionTable_server_update_time];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully update the server_update_time region table");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
        [mrParkDB close];
    }
    query = [NSString stringWithFormat:@"update updateTable set updated_at = \"%@\" where tableName = \"regionTable\"", regionTable_server_update_time];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"Region Table updated");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally
    {
        [mrParkDB close];
    }
}
#pragma insert holiday

-(void)insertHolidayList:(NSMutableArray *)arrholder
{
    [mrParkDB open];
    for (int i=0; i<arrholder.count;i++)
    {
        
        HolidayTable *dataHolder=[arrholder objectAtIndex:i];
        NSString *query=[NSString stringWithFormat:@"delete from holidayTable where id = %@", dataHolder.str_id];
        @try
        {
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully delete one row with id = %@ in holiday table", dataHolder.str_id);
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
        query=[NSString stringWithFormat:@"insert into holidayTable(id, name, date, create_at, update_at) values(\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")", dataHolder.str_id, dataHolder.str_name, dataHolder.str_date, dataHolder.str_create_at, dataHolder.str_update_at];
        @try
        {
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully inserted to holiday table");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
    }
    NSString *query=[NSString stringWithFormat:@"update holidayTable set update_at = \"%@\"", holidayTable_server_update_time];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully update the server_update_time holiday table");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
        [mrParkDB close];
    }
    query = [NSString stringWithFormat:@"update updateTable set updated_at = \"%@\" where tableName = \"holidayTable\"", holidayTable_server_update_time];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"holiday table updated");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally
    {
        [mrParkDB close];
    }
}


#pragma insert address

-(void)insertAddresList:(NSMutableArray *)arrholder
{
    NSString *query = [NSString stringWithFormat:@"select count(*) from addressUpdate"];
    AddressDB *dataHolder = [arrholder objectAtIndex:0];
    NSString* rName = dataHolder.str_regionName;
    
    int numberOfRegionStored;
    int rID;
    
    @try
    {   [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            
            [dataArr next];
            numberOfRegionStored = [[dataArr stringForColumn:@"count(*)"] intValue];
        }
        else
        {
            NSLog(@"error in addressUpdate retrieving data");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally{
        [mrParkDB close];
    }

    if (numberOfRegionStored == NUMBEROFROWREGIONSTORED) {
        [self deleteAddressWithEarliestActivity];
    }
    
    for (int i=0; i<arrholder.count-1;i++)
    {
        AddressDB *dataHolder=[arrholder objectAtIndex:i];
        NSString *query=[NSString stringWithFormat:@"delete from addressTable where address_id = %@", dataHolder.int_addId];
        @try
        {
            [mrParkDB open];
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully delete one row with id = %@ in address table", dataHolder.int_addId);
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally{
            [mrParkDB close];
        }
//        if (i%2 == 0) {
//        latitude = [dataHolder.double_houseLat doubleValue];
//        longtitude = [dataHolder.double_houseLong doubleValue];
//        }
//        else{
//            latitude = [dataHolder.str_houseLat doubleValue]-arc4random()%100/10000.0;
//            longtitude = [dataHolder.str_houseLong doubleValue]-arc4random()%100/10000.0;
////        }
//        dataHolder.double_houseLat = [NSString stringWithFormat:@"%lf", latitude];
//        dataHolder.double_houseLong = [NSString stringWithFormat:@"%lf", longtitude];
        query=[NSString stringWithFormat:@"insert into addressTable(address_id, city_name, created_at, houseFullAddress, houseLat, houseLong, houseNo, houseSide, regionName, stateName, status, streetName, parking_id) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\")",dataHolder.int_addId, dataHolder.str_cityName, dataHolder.str_createdId, dataHolder.str_houseFullAddress, dataHolder.double_houseLat, dataHolder.double_houseLong, dataHolder.str_houseNo, dataHolder.str_houseSide, dataHolder.str_regionName, dataHolder.str_stateName, dataHolder.str_status, dataHolder.str_streetName, dataHolder.int_parking_ids];
        @try
        {
            [mrParkDB open];
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully inserted to address table");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally{
            [mrParkDB close];
        }
    }
    query=[NSString stringWithFormat:@"select region_id from regionTable where region_name = \"%@\"", rName];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            [dataArr next];
            rID = [[dataArr stringForColumn:@"region_id"] intValue];
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally
    {
        [mrParkDB close];
    }
    query=[NSString stringWithFormat:@"insert into addressUpdate (region_id, region_name) values (%d, \"%@\")", rID, rName];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully insert to addressUpate");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"213   %@",e);
    }
    @finally
    {
        [mrParkDB close];
    }
    query=[NSString stringWithFormat:@"update addressUpdate set update_at = \"%@\" where region_name = \"%@\"", addressTable_server_update_time, rName];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"%@ is updated", rName);
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally
    {
        [mrParkDB close];
    }
    
}

#pragma insert parking

-(void)insertParkingList:(NSMutableArray *)arrholder
{
    [mrParkDB open];
    for (int i=0; i<arrholder.count;i++)
    {
        Parking *dataHolder=[arrholder objectAtIndex:i];
        NSString *query=[NSString stringWithFormat:@"delete from parkingTable where id = %@", dataHolder.str_id];
        @try
        {
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully delete one row with id = %@ in parking table", dataHolder.str_id);
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
        query=[NSString stringWithFormat:@"insert into parkingTable(parking_type, parking_limit, parking_default_time_start, parking_default_time_end, parking_default_days, parking_restrict_time_start, parking_restrict_time_end, parking_sweeping_time_start, parking_sweeping_time_end, parking_holiday, notes, id, update_at) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%@\",\"%@\")", dataHolder.str_parking_type, dataHolder.str_parking_free_limit, dataHolder.str_parking_default_time_start, dataHolder.str_parking_default_time_end, dataHolder.str_parking_default_days, dataHolder.str_parking_restrict_time_start, dataHolder.str_parking_restrict_time_end, dataHolder.str_parking_sweeping_time_start, dataHolder.str_parking_sweeping_time_end, dataHolder.str_parking_holiday, dataHolder.str_notes, dataHolder.str_id, dataHolder.str_update_at];
        @try
        {
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully inserted to parking table");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
    }
    NSString *query=[NSString stringWithFormat:@"update parkingTable set update_at = \"%@\"", parkingTable_server_update_time];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully update the server_update_time parking table");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    query = [NSString stringWithFormat:@"update updateTable set updated_at = \"%@\" where tableName = \"parkingTable\"", parkingTable_server_update_time];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"ParkingTable updated");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
        [mrParkDB close];
    }
    
    @finally
    {
        [mrParkDB close];
    }
    
}

#pragma mark insert favoriteTable


-(void)insertfList:(FavoriteList *)dataHolder
{
    NSString *query=[NSString stringWithFormat:@"insert into favoriteTable(address_id, city_name, created_at, houseFullAddress, houseLat, houseLong, houseNo, houseSide, regionName, stateName, status, streetName, updateAt, parking_ids) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",dataHolder.int_addId, dataHolder.str_cityName, dataHolder.str_createdId, dataHolder.str_houseFullAddress, dataHolder.double_houseLat, dataHolder.double_houseLong, dataHolder.str_houseNo, dataHolder.str_houseSide, dataHolder.str_regionName, dataHolder.str_stateName, dataHolder.str_status, dataHolder.str_streetName, dataHolder.int_parking_id];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully inserted to favorite table");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally
    {
        [mrParkDB close];
    }
}

#pragma mark get data for local database



- (void)getFavoriteListFromDatabase{
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select * FROM favoriteTable"];
    
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            favoriteListArray = [NSMutableArray new];
            while ([dataArr next]) {
            
            flistHolder = [FavoriteList new];
            
            flistHolder.int_addId = [NSNumber numberWithInt:[dataArr intForColumn:@"address_id"]];
            flistHolder.str_cityName = [dataArr stringForColumn:@"city_name"];
            flistHolder.str_createdId = [dataArr stringForColumn:@"created_at"];
            flistHolder.str_houseFullAddress = [dataArr stringForColumn:@"houseFullAddress"];
            flistHolder.double_houseLat = [NSNumber numberWithDouble:[dataArr doubleForColumn:@"houseLat"]];
            flistHolder.double_houseLong = [NSNumber numberWithDouble:[dataArr doubleForColumn:@"houseLong"]];
            flistHolder.str_houseNo = [dataArr stringForColumn:@"houseNo"];
            flistHolder.str_houseSide = [dataArr stringForColumn:@"houseSide"];
            flistHolder.str_regionName = [dataArr stringForColumn:@"regionName"];
            flistHolder.str_stateName = [dataArr stringForColumn:@"stateName"];
            flistHolder.str_status = [dataArr stringForColumn:@"status"];
            flistHolder.str_streetName = [dataArr stringForColumn:@"streetName"];
            flistHolder.int_parking_id = [NSNumber numberWithInt:[dataArr intForColumn:@"parking_ids"]];
            [favoriteListArray addObject:flistHolder];
            }
        }
        else
        {
            NSLog(@"error in favoriteTable retrieving data");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}

//
//- (void)getAddressFromDatabase{
//    if (!mrParkDB)
//    {
//        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
//        mrParkDB = [[FMDatabase alloc] initWithPath:path];
//    }
//    
//    NSString *query;
//    
//    query = [NSString stringWithFormat:@"Select * FROM addressTable where houseLat = \"%lf\" AND houseLong = \"%lf\"", destLatitude, destLatitude];
//    
//    @try
//    {
//        [mrParkDB open];
//        if ([mrParkDB executeQuery:query])
//        {
//            FMResultSet *dataArr = [mrParkDB executeQuery:query];
//            [dataArr next];
//            addressHolder = [AddressDB new];
//            
//            addressHolder.str_addId = [NSNumber numberWithInt:[dataArr intForColumn:@"address_id"]];
//            addressHolder.str_cityName = [dataArr stringForColumn:@"city_name"];
//            addressHolder.str_createdId = [dataArr stringForColumn:@"created_at"];
//            addressHolder.str_houseFullAddress = [dataArr stringForColumn:@"houseFullAddress"];
//            addressHolder.str_houseLat = [dataArr stringForColumn:@"houseLat"];
//            addressHolder.str_houseLong = [dataArr stringForColumn:@"houseLong"];
//            addressHolder.str_houseNo = [dataArr stringForColumn:@"houseNo"];
//            addressHolder.str_houseSide = [dataArr stringForColumn:@"houseSide"];
//            addressHolder.str_regionName = [dataArr stringForColumn:@"regionName"];
//            addressHolder.str_stateName = [dataArr stringForColumn:@"stateName"];
//            addressHolder.str_status = [dataArr stringForColumn:@"status"];
//            addressHolder.str_streetName = [dataArr stringForColumn:@"streetName"];
//            addressHolder.str_updatedAt = [dataArr stringForColumn:@"updateAt"];
//            addressHolder.str_parking_ids = [dataArr stringForColumn:@"parking_ids"];
//            
//        }
//        else
//        {
//            NSLog(@"error in address table retrieving data");
//        }
//        [mrParkDB close];
//    }
//    @catch (NSException *e)
//    {
//        NSLog(@"%@",e);
//    }
//}

- (void)getParkingFromDatabase:(int) parkingID{
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select * FROM parkingTable where id  = \"%d\"", parkingID];
    
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            [dataArr next];
            parkingHolder = [Parking new];
            parkingHolder.str_id = [NSNumber numberWithInt:[dataArr intForColumn:@"id"]];
            parkingHolder.str_parking_type = [dataArr stringForColumn:@"parking_type"];
            parkingHolder.str_parking_free_limit = [NSNumber numberWithInt:[dataArr intForColumn:@"parking_limit"]];
            parkingHolder.str_parking_default_time_start = [dataArr stringForColumn:@"parking_default_time_start"];
            parkingHolder.str_parking_default_time_end = [dataArr stringForColumn:@"parking_default_time_end"];
            parkingHolder.str_parking_default_days = [dataArr stringForColumn:@"parking_default_days"];
            parkingHolder.str_parking_restrict_time_start = [dataArr stringForColumn:@"parking_restrict_time_start"];
            parkingHolder.str_parking_restrict_time_end = [dataArr stringForColumn:@"parking_restrict_time_end"];
            parkingHolder.str_parking_sweeping_time_start = [dataArr stringForColumn:@"parking_sweeping_time_start"];
            parkingHolder.str_parking_sweeping_time_end = [dataArr stringForColumn:@"parking_sweeping_time_end"];
            parkingHolder.str_notes = [dataArr stringForColumn:@"notes"];
            parkingHolder.str_update_at = [dataArr stringForColumn:@"update_at"];
        }
        else
        {
            NSLog(@"error in parking table retrieving data");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}
- (NSString*)getParkingTypeWithID:(int) parkingID{
    NSString *parkingType;
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select * FROM parkingTable where id  = \"%d\"", parkingID];
    
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            [dataArr next];
            parkingType = [dataArr stringForColumn:@"parking_type"];
        }
        else
        {
            NSLog(@"error in parking table retrieving data");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    return parkingType;
}
//- (void) getRegionFromDatabase{
//    if (!mrParkDB)
//    {
//        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
//        mrParkDB = [[FMDatabase alloc] initWithPath:path];
//    }
//
//    NSString *query;
//
//    query = [NSString stringWithFormat:@"Select * FROM regionTable"];
//
//    @try
//    {
//        [mrParkDB open];
//        if ([mrParkDB executeQuery:query])
//        {
//            FMResultSet *dataArr = [mrParkDB executeQuery:query];
//
//            while([dataArr next])
//            {
//                Region *data = [Region new];
//                data.str_region_id = [NSNumber numberWithInt:[dataArr intForColumn:@"region_id"]];
//                data.str_state_id = [NSNumber numberWithInt: [dataArr intForColumn:@"state_id"]];
//                data.str_region_name = [dataArr stringForColumn:@"region_name"];
//                [arr_regionFromDB addObject:data];
//            }
//        }
//        else
//        {
//            NSLog(@"error in region table retrieving data");
//        }
//        [mrParkDB close];
//    }
//    @catch (NSException *e)
//    {
//        NSLog(@"%@",e);
//    }
//}





-(void)deleteAddressWithEarliestActivity{
    NSString *earlistName;
    [mrParkDB open];
    NSString *query=[NSString stringWithFormat:@"select * from addressUpdate order by last_activity"];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            [dataArr next];
            earlistName = [dataArr stringForColumn:@"region_name"];
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
        [mrParkDB close];
    }
    query=[NSString stringWithFormat:@"delete from addressUpdate where region_name = \"%@\"", earlistName];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully delete %@ in addressUpdate", earlistName);
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
        [mrParkDB close];
    }
    query=[NSString stringWithFormat:@"delete from addressTable where regionName = \"%@\"", earlistName];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully delete %@ in addressTable", earlistName);
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally{
    [mrParkDB close];
    }
}


-(void)setLastActivityWithTime:(NSString*)time andRegionName: (NSString*) rName{
    [mrParkDB open];
    NSString *query=[NSString stringWithFormat:@"update addressUpdate set last_activity = \"%@\" where region_name = \"%@\"", time, rName];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully update %@ last activity time", rName);
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    @finally{
        [mrParkDB close];
    }
}


@end
