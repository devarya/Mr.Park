//
//  Location.h
//  Mr.Park
//
//  Created by rashmi on 8/18/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface AddressDB : NSObject
@property(nonatomic,strong)NSNumber *str_addId;
@property(nonatomic,strong)NSString *str_cityName;
@property(nonatomic,strong)NSString *str_createdId;
@property(nonatomic,strong)NSString *str_houseFullAddress ;
@property(nonatomic,strong)NSString *str_houseLat;
@property(nonatomic,strong)NSString *str_houseLong;
@property(nonatomic,strong)NSString *str_houseNo;
@property(nonatomic,strong)NSString *str_houseSide;
@property(nonatomic,strong)NSString *str_regionName;
@property(nonatomic,strong)NSString *str_stateName;
@property(nonatomic,strong)NSString *str_status;
@property(nonatomic,strong)NSString *str_streetName;
@property(nonatomic,strong)NSString *str_updatedAt;
@property(nonatomic,strong)NSString *str_parking_ids;

@end


