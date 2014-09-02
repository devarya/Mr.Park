//
//  MPCustomAnnotation.m
//  Mr.Park
//
//  Created by rashmi on 9/2/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPCustomAnnotation.h"

@implementation MPCustomAnnotation

- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSub Location:(CLLocationCoordinate2D)location {
    self = [super self];
    if(self) {
        _title = newTitle;
        _subtitle = newSub;
        _coordinate = location;
    }
    return self;
}

- (MKAnnotationView *) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@""];
    annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

@end
