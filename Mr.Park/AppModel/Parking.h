//
//  Parking.h
//  Mr. Park
//
//  Created by rashmi on 8/20/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parking : NSObject

@property (strong, nonatomic)NSNumber* str_id;
@property (strong, nonatomic)NSString* str_parking_type;
@property (strong, nonatomic)NSNumber* str_parking_free_limit;
@property (strong, nonatomic)NSString* str_parking_default_time_start;
@property (strong, nonatomic)NSString* str_parking_default_time_end;
@property (strong, nonatomic)NSString* str_parking_default_days;
@property (strong, nonatomic)NSString* str_parking_restrict_time_start;
@property (strong, nonatomic)NSString* str_parking_restrict_time_end;
@property (strong, nonatomic)NSString* str_parking_sweeping_time_start;
@property (strong, nonatomic)NSString* str_parking_sweeping_time_end;
@property (strong, nonatomic)NSString* str_notes;
@property (strong, nonatomic)NSString* str_update_at;
@property (strong, nonatomic)NSString* str_parking_holiday;

@end
