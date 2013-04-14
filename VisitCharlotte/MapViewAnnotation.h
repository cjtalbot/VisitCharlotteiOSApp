//
//  MapViewAnnotation.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/24/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation> {
    
	NSString *title;
	CLLocationCoordinate2D coordinate;
    int recNum;
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) int recNum;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d andRec:(int)rec;

@end
