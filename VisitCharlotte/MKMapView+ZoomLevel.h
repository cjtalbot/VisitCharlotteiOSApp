//
//  MKMapView+ZoomLevel.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/24/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
