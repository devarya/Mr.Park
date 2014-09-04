//
//  MPGlobalData.h
//  Mr.Park
//
//  Created by rashmi on 9/2/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AddressDB.h"
#import "AddressUpdateControl.h"
#import "HolidayTable.h"
#import "Parking.h"
#import "Region.h"
#import "tempTable.h"
#import "UpdateTable.h"
#import "CoordinatePoint.h"
#import "FavoriteList.h"

BOOL isSeverResponse;


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
CLLocationCoordinate2D destCoordinate;

double currentLatitude;
double currentLongitude;
CLLocationCoordinate2D currentCoordinate;
CLLocation *currentLocation;

NSString *parkingType;
NSString *destStreetName;
NSString *destAddress;
NSString *destParkingType;
NSString *destParkingTime;
NSString *destRestrictTime;
AddressDB *addressHolder;
Parking *parkingHolder;
AddressUpdateControl *adUCHolder;
Region *regionHolder;
HolidayTable *holidayHolder;
UpdateTable *updateHolder;
FavoriteList *flistHolder;

NSMutableArray *parkingArray;
NSMutableArray *addressArray;
NSMutableArray *regionArray;
NSMutableArray *holidayArray;
NSMutableArray *addressControlArray;
NSMutableArray *updateArray;
NSMutableArray *favoriteListArray;
NSMutableArray *tempTableArray;

NSString *destStreetName;
NSString *destAddress;

NSString *parkingTable_server_update_time;
NSString *regionTable_server_update_time;
NSString *addressTable_server_update_time;
NSString *holidayTable_server_update_time;

@interface MPGlobalData : NSObject

@end
