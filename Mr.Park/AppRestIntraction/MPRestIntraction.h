//
//  MPRestIntraction.h
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MPGlobalData.h"
#import "MPDBIntraction.h"

@class MPRestIntraction;
MPRestIntraction *restIntraction;
@interface MPRestIntraction : NSObject{
    
    NSURL * urlMain;
}
+(id)sharedManager;

- (void)requestRegionCall:(NSMutableDictionary*) info withUpdate: (NSString*) time;

- (void)requestHolidayCall:(NSMutableDictionary*) info withUpdate: (NSString*) time;

- (void)requestParkingCall:(NSMutableDictionary*) info withUpdate: (NSString*) time;

- (void)requestAddressControlCall:(NSMutableDictionary*) info;

- (void)requestAddressCall:(NSMutableDictionary*) info andRegionID:(NSNumber*) region_id adUpdateTime: (NSString*) time;

@end
