//
//  MapViewAnnotation.m
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/24/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate, recNum;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d andRec:(int)rec {
	[super init];
	title = ttl;
	coordinate = c2d;
    recNum = rec;
	return self;
}

- (void)dealloc {
	[title release];
    title = nil;
	[super dealloc];
}

@end