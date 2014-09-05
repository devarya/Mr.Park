//
//  MPRestIntraction.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPRestIntraction.h"

@implementation MPRestIntraction

+(id)sharedManager{
    
    if (!restIntraction) {
        
        restIntraction = [MPRestIntraction new];
        
    }
    return  restIntraction;
}

-(id)init{
    if (self = [super init]) {
        NSString * strUrl = URL_MAIN;
        urlMain = [[NSURL alloc] initWithString:strUrl];
    }
    return self;
}

#pragma mark Reigion
- (void)requestRegionCall:(NSMutableDictionary*) info withUpdate: (NSString*) time{
    [info setValue:[NSString stringWithFormat:@"%@", time] forKey:@"update_at"];
    [info setValue:@"get_region" forKey:@"cmd"];
    [self requestForRegion:info];
}

- (void)requestForRegion: (NSMutableDictionary*)info{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonStr=  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self requestRegion:jsonStr];
}

- (void)requestRegion: (NSString*)info {
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlMain];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestRegionFail:)];
    [request setDidFinishSelector:@selector(requestRegionSuccess:)];
    [request startAsynchronous];
    
}

- (void)requestRegionFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [MPGlobalFunction showAlert:MESSAGE_NOT_RESPOND];
                   });
}

- (void)requestRegionSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser=[[SBJSON alloc]init];
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSDictionary *dataArray=[results objectForKey:@"data"];
    regionTable_server_update_time = [dataArray objectForKey:@"update_at"];
    regionArray = [NSMutableArray new];
    NSMutableArray *dataArr = ((NSMutableArray*)[dataArray objectForKey:@"data"]);
    for (int i=0; i<dataArr.count; i++) {
        
        Region *data = [Region new];
        
        data.str_region_id = [[dataArr valueForKey:@"region_id"]objectAtIndex:i];
        data.str_state_id = [[dataArr valueForKey:@"state_id"]objectAtIndex:i];
        data.str_region_name = [[dataArr valueForKey:@"region_name"]objectAtIndex:i];
        data.str_update_at = [[dataArr valueForKey:@"update_at"]objectAtIndex:i];
        
        [regionArray addObject:data];
    }
    if (regionArray.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[MPDBIntraction databaseInteractionManager] insertRegionList:regionArray];
        });
    }
    else{
        NSLog(@"regionTable no need to update");
    }
}

#pragma mark Holiday
- (void)requestHolidayCall:(NSMutableDictionary*) info withUpdate: (NSString*) time{
    [info setValue:[NSString stringWithFormat:@"%@", time] forKey:@"update_at"];
    [info setValue:currentYear forKey:@"holiday_year"];
    [info setValue:@"get_holiday" forKey:@"cmd"];
    [self requestForHoliday:info];
}
- (void) requestForHoliday: (NSMutableDictionary*)info{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonStr=  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self requestHoliday:jsonStr];
}

- (void) requestHoliday: (NSString*)info {
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlMain];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestHolidayFail:)];
    [request setDidFinishSelector:@selector(requestHolidaySuccess:)];
    [request startAsynchronous];
    
}
-(void)requestHolidayFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [MPGlobalFunction showAlert:MESSAGE_NOT_RESPOND];
                   });
}
-(void)requestHolidaySuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser=[[SBJSON alloc]init];
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSDictionary *dataArray=[results objectForKey:@"data"];
    holidayTable_server_update_time = [dataArray objectForKey:@"update_at"];
    
    holidayArray = [NSMutableArray new];
    if (dataArray!=nil) {
        for (int i=0; i<dataArray.count-1; i++) {
            NSMutableArray *dataArr = ((NSMutableArray*)[dataArray objectForKey:[NSString stringWithFormat:@"%d", i]]);
            HolidayTable *data = [HolidayTable new];
            data.str_id = [dataArr valueForKey:@"holiday_id"];
            data.str_name = [dataArr valueForKey:@"holiday_name"];
            data.str_date = [[dataArr valueForKey:@"holiday_date"] componentsSeparatedByString:@" "][0];
            data.str_create_at = [dataArr valueForKey:@"create_timestamp"];
            data.str_update_at = [dataArr valueForKey:@"update_timestamp"];
            [holidayArray addObject:data];
        }
    }
    if (holidayArray.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MPDBIntraction databaseInteractionManager] insertHolidayList:holidayArray];
        });
    }
    else{
        NSLog(@"holidayTable no need to update");
    }
}

#pragma mark Parking
- (void)requestParkingCall:(NSMutableDictionary*) info withUpdate: (NSString*) time{
    [info setValue:[NSString stringWithFormat:@"%@", time] forKey:@"update_at"];
    [info setValue:@"get_parking" forKey:@"cmd"];
    [self requestForParking:info];
}
- (void)requestForParking: (NSMutableDictionary*)info{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonStr=  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self requestParking:jsonStr];
}

- (void) requestParking: (NSString*)info {
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlMain];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestParkingFail:)];
    [request setDidFinishSelector:@selector(requestParkingSuccess:)];
    [request startAsynchronous];
    
}

- (void)requestParkingFail:(ASIFormDataRequest*)request{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [MPGlobalFunction showAlert:MESSAGE_NOT_RESPOND];
                   });
}

- (void)requestParkingSuccess:(ASIFormDataRequest*)request{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser=[[SBJSON alloc]init];
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSDictionary *dataArray=[results objectForKey:@"data"];
    parkingTable_server_update_time = [dataArray objectForKey:@"update_at"];
    parkingArray = [NSMutableArray new];
    if (dataArray != nil) {
        for (int i=0; i<dataArray.count-1; i++) {
            NSMutableArray *dataArr = ((NSMutableArray*)[dataArray objectForKey:[NSString stringWithFormat:@"%d", i]]);
            Parking *data = [Parking new];
            data.str_id = [dataArr valueForKey:@"id"];
            data.str_update_at = parkingTable_server_update_time;
            data.str_parking_type = [dataArr valueForKey:@"parking_type"];
            data.str_parking_free_limit = [dataArr valueForKey:@"parking_limit"];
            data.str_parking_default_time_start = [dataArr valueForKey:@"parking_default_time_start"];
            data.str_parking_default_time_end = [dataArr valueForKey:@"parking_default_time_end"];
            data.str_parking_default_days = [dataArr valueForKey:@"parking_default_days"];
            data.str_parking_restrict_time_start = [dataArr valueForKey:@"parking_restrict_time_start"];
            data.str_parking_restrict_time_end = [dataArr valueForKey:@"parking_restrict_time_end"];
            data.str_parking_sweeping_time_start = [dataArr valueForKey:@"parking_sweeping_time_start"];
            data.str_parking_sweeping_time_end = [dataArr valueForKey:@"parking_sweeping_time_end"];
            data.str_parking_holiday = [dataArr valueForKey:@"parking_holiday"];
            data.str_notes = [dataArr valueForKey:@"notes"];
            [parkingArray addObject:data];
        }
    }
    if (parkingArray.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MPDBIntraction databaseInteractionManager] insertParkingList:parkingArray];
        });
    }
    else{
        NSLog(@"parkingTable no need to update");
        
    }
}


#pragma mark addressUpdate

- (void)requestAddressControlCall:(NSMutableDictionary*) info{
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    NSString *query;
    query = [NSString stringWithFormat:@"Select * from addressUpdate"];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            addressControlArray = [NSMutableArray new];
            while ([dataArr next]){
                adUCHolder = [AddressUpdateControl new];
                adUCHolder.int_region_id = [NSNumber numberWithInt:[dataArr intForColumn:@"region_id"]];
                adUCHolder.str_update_at = [dataArr stringForColumn:@"update_at"];
                adUCHolder.str_region_name = [dataArr stringForColumn:@"region_name"];
                [addressControlArray addObject:adUCHolder];
            }
        }
        else
        {
            NSLog(@"error in select from addressUpdate");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    for (AddressUpdateControl* ad in addressControlArray) {
        NSMutableDictionary* info = [NSMutableDictionary new];
        [self requestAddressCall:info andRegionID:ad.int_region_id adUpdateTime:ad.str_update_at];
    }
}

#pragma mark Address Table
- (void)requestAddressCall:(NSMutableDictionary*) info andRegionID:(NSNumber*) region_id adUpdateTime: (NSString*) time{
    if (![time isEqualToString:@"2000-01-01 00:00:00"]) {
        isUpdate = YES;
    }
    [info setValue:[NSString stringWithFormat:@"%@", region_id] forKey:@"region_id"];
    [info setValue:time forKey:@"update_at"];
    [info setValue:@"get_address" forKey:@"cmd"];
    [self requestForAddress:info];
}
- (void)requestForAddress: (NSMutableDictionary*)info{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonStr=  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self requestAddress:jsonStr];
}

- (void)requestAddress: (NSString*)info {
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlMain];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddressFail:)];
    [request setDidFinishSelector:@selector(requestAddressSuccess:)];
    [request startAsynchronous];
    
}

- (void)requestAddressFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [MPGlobalFunction showAlert:MESSAGE_NOT_RESPOND];
                   });
}

- (void)requestAddressSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser=[[SBJSON alloc]init];
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSDictionary *dataArray = [results objectForKey:@"data"];
    addressTable_server_update_time = [dataArray objectForKey:@"update_at"];
    addressArray = [NSMutableArray new];
    if (dataArray != nil) {
        for (int i=0; i<dataArray.count; i++) {
            NSMutableArray *dataArr=((NSMutableArray*)[dataArray objectForKey:[NSString stringWithFormat:@"%d", i]]);
            AddressDB *data = [AddressDB new];
            data.str_addId = [dataArr valueForKey:@"address_id"];
            data.str_cityName = [dataArr valueForKey:@"city_name"];
            data.str_createdId = [dataArr valueForKey:@"created_at"];
            data.str_houseFullAddress = [dataArr valueForKey:@"house_full_address"];
            data.str_houseLat = [dataArr valueForKey:@"house_latitude"];
            data.str_houseLong = [dataArr valueForKey:@"house_longitude"];
            data.str_houseNo = [dataArr valueForKey:@"house_no"];
            data.str_houseSide = [dataArr valueForKey:@"house_side"];
            data.str_regionName = [dataArr valueForKey:@"region_name"];
            data.str_stateName = [dataArr valueForKey:@"state_name"];
            data.str_status = [dataArr valueForKey:@"status"];
            data.str_streetName = [dataArr valueForKey:@"street_name"];
            data.str_updatedAt = [dataArr valueForKey:@"updated_at"];
            NSString * parkingIDS = [dataArr valueForKey:@"parking_ids"];
            NSCharacterSet * doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\"[]"];
            data.str_parking_ids = [[parkingIDS componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];
            [addressArray addObject:data];
        }
    }
    if (addressArray.count!= 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MPDBIntraction databaseInteractionManager] insertAddresList:addressArray];
        });
    }
    else{
        NSLog(@"addressTable no need to update");
    }
}
@end