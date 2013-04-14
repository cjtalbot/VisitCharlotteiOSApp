//
//  MapDetailViewController.m
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import "MapDetailViewController.h"
#import "MapViewAnnotation.h"
#import "MKMapView+ZoomLevel.h"

#define CLT_CENTER_LAT 35.22728220833
#define CLT_CENTER_LONG -80.84217325


@implementation MapDetailViewController


@synthesize recordNum;
@synthesize dao;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dao = [[DataDao alloc] initWithDataName:@"database"];
    
}

- (void)dealloc
{
    [dao release];
    dao = nil;
    [mapView release];
    mapView = nil;
    [addr release];
    addr = nil;
    recordNum = 0;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // lets show the map, our current GPS location, and a pin for the location looking for
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    recordNum = 0;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)addOneAnnotation:(int)recNum {
    
    // set these to the data for the recNum passed
    NSString *title = [[dao dataItemAtIndex:recNum] valueForKey:@"shortName"];
    CLLocationCoordinate2D coord = { [[[dao dataItemAtIndex:recNum] valueForKey:@"latitude"] doubleValue], [[[dao dataItemAtIndex:recNum] valueForKey:@"longitude"] doubleValue]};
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:title andCoordinate:coord andRec:recNum];
	[self.mapView addAnnotation:newAnnotation];
	[newAnnotation release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!ZoomAmt) {
        ZoomAmt = 14;
    }
    CLLocationCoordinate2D centerCoord = { [[[dao dataItemAtIndex:recordNum] valueForKey:@"latitude"] doubleValue], [[[dao dataItemAtIndex:recordNum] valueForKey:@"longitude"] doubleValue] };

    [mapView setCenterCoordinate:centerCoord zoomLevel:ZoomAmt animated:NO];
    [self addOneAnnotation:recordNum];

    addr.text = [[dao dataItemAtIndex:recordNum] valueForKey:@"address"];

    
    
}

@end
