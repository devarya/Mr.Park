//
//  MPGlobalData.h
//  Mr.Park
//
//  Created by rashmi on 9/2/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MPConstant.h"
#import "MPGlobalFunction.h"
#import "AddressDB.h"
#import "AddressUpdateControl.h"
#import "HolidayTable.h"
#import "Parking.h"
#import "Region.h"
#import "tempTable.h"
#import "UpdateTable.h"

NSString *weekday;
NSString *currentYear;
NSString *currentMonth;
NSString *currentDay;
NSString *currentHour;
NSString *currentMinute;
NSString *currentSecond;
NSDate *now;
NSString *strDate;
NSString *strTime;
NSMutableArray *ary_ptfp;
NSMutableArray *ary_ptfps;
NSMutableArray *ary_ptlt;
NSMutableArray *ary_ptmp;
NSMutableArray *ary_ptmps;
double destLatitude;
double destLongitude;
NSString *parkingType;

AddressDB *addressHolder;
Parking *parkingHolder;
AddressUpdateControl *adUCHolder;
Region *regionHolder;
HolidayTable *holidayHolder;
UpdateTable *updateHolder;

NSMutableArray *parkingArray;
NSMutableArray *addressArray;
NSMutableArray *regionArray;
NSMutableArray *holidayArray;
NSMutableArray *addressControlArray;
NSMutableArray *updateArray;


NSString *parkingTable_server_update_time;
NSString *regionTable_server_update_time;
NSString *addressTable_server_update_time;
NSString *holidayTable_server_update_time;

NSMutableArray *tempTableArray;

@interface MPGlobalData : NSObject

@end
