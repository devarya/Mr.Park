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
        dBMrPark  = [[FMDatabase alloc] initWithPath:[self getDatabasePathFromName:DBname]];
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
    NSString* rName;
    NSString* rID;
    [mrParkDB open];
    double latitude;
    double longtitude;
    for (int i=0; i<arrholder.count;i++)
    {
        AddressDB *dataHolder=[arrholder objectAtIndex:i];
        if(i==0){
            rName = dataHolder.str_regionName;
        }
        NSString *query=[NSString stringWithFormat:@"delete from addressTable where address_id = %@", dataHolder.str_addId];
        @try
        {
            if ([mrParkDB executeUpdate:query])
            {
                NSLog(@"successfully delete one row with id = %@ in address table", dataHolder.str_addId);
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
        if (i%2 == 0) {
            latitude = [dataHolder.str_houseLat doubleValue]+arc4random()%100/10000.0;
            longtitude = [dataHolder.str_houseLong doubleValue]+arc4random()%100/10000.0;
        }
        else{
            latitude = [dataHolder.str_houseLat doubleValue]-arc4random()%100/10000.0;
            longtitude = [dataHolder.str_houseLong doubleValue]-arc4random()%100/10000.0;
        }
        dataHolder.str_houseLat = [NSString stringWithFormat:@"%lf", latitude];
        dataHolder.str_houseLong = [NSString stringWithFormat:@"%lf", longtitude];
        query=[NSString stringWithFormat:@"insert into addressTable(address_id, city_name, created_at, houseFullAddress, houseLat, houseLong, houseNo, houseSide, regionName, stateName, status, streetName, updateAt, parking_ids) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\")",dataHolder.str_addId, dataHolder.str_cityName, dataHolder.str_createdId, dataHolder.str_houseFullAddress, dataHolder.str_houseLat, dataHolder.str_houseLong, dataHolder.str_houseNo, dataHolder.str_houseSide, dataHolder.str_regionName, dataHolder.str_stateName, dataHolder.str_status, dataHolder.str_streetName, dataHolder.str_updatedAt, dataHolder.str_parking_ids];
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
            [mrParkDB close];
        }
    }
    NSString *query=[NSString stringWithFormat:@"update addressTable set updateAt = \"%@\"", addressTable_server_update_time];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully update the server_update_time address table");
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
        [mrParkDB close];
    }
    for (AddressUpdateControl *ad in addressControlArray) {
        if([ad.str_region_name isEqual:rName]){
            rID = [NSString stringWithFormat:@"%@", ad.int_region_id];
            break;
        }
    }
    query=[NSString stringWithFormat:@"update addressUpdate set update_at = \"%@\" where region_id = \"%@\"", addressTable_server_update_time, rID];
    @try
    {
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"region %@ is updated", rID);
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

@end
