//
//  MPCustomAnnotation.h
//  Mr.Park
//
//  Created by rashmi on 9/2/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MPCustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSub Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end

