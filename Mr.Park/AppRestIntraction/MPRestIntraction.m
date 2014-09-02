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
@end