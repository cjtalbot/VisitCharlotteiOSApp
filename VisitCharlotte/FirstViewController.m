//
//  FirstViewController.m
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import "FirstViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "MapViewAnnotation.h"
#import "DetailViewController.h"

#define CLT_CENTER_LAT 35.22728220833
#define CLT_CENTER_LONG -80.84217325



@implementation FirstViewController

@synthesize mapView;

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    dao = [[DataDao alloc] initWithDataName:@"database"];
    self.title = @"Overview Map";

    [switcher setTitle:@"Show Itinerary" forState:UIControlStateNormal];

    ison = YES;

    [mapView setDelegate:self];

    [self refresh];

}

-(void)refresh {

    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[self.mapView.annotations count]];
    for (int i=0; i < [self.mapView.annotations count]; i++) {
        if (![[self.mapView.annotations objectAtIndex:i] isKindOfClass:[MKUserLocation class]]) {
            [arr addObject:[self.mapView.annotations objectAtIndex:i]];
        }
    }
    [self.mapView removeAnnotations:arr];
    
    [self addAllAnnotations]; // re-add them so we can see them fresh (to help with the favorites image)

    [arr release];

}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(void)addAllAnnotations {

    int count = [dao dataCount];

    NSString *title;
    CLLocationCoordinate2D coord;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[[[dao dataItemAtIndex:0] valueForKey:@"maxFavs"] intValue]];
    for (int i=0; i < count; i++) {
        if (ison || (!ison && [[[dao dataItemAtIndex:i] valueForKey:@"favorite"] boolValue])) {
            // loop through array of plist to set title & coord
            title = [[dao dataItemAtIndex:i] valueForKey:@"shortName"];
            coord.latitude =  [[[dao dataItemAtIndex:i] valueForKey:@"latitude"] doubleValue]; 
            coord.longitude = [[[dao dataItemAtIndex:i] valueForKey:@"longitude"] doubleValue];
            MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:title andCoordinate:coord andRec:i];
            [arr addObject:newAnnotation];
            [newAnnotation release];
        }
    }
    [self.mapView addAnnotations:arr];

    
    [arr release];

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
        ZoomAmt = 13;
    }
    CLLocationCoordinate2D centerCoord = { CLT_CENTER_LAT, CLT_CENTER_LONG };

    [mapView setCenterCoordinate:centerCoord zoomLevel:ZoomAmt animated:NO];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(IBAction)switcherToggle:(id)sender {


    if ([switcher.titleLabel.text isEqualToString:@"Show All"]) {
        [switcher setTitle:@"Show Itinerary" forState:UIControlStateNormal];

        ison = YES;
    } else {
        [switcher setTitle:@"Show All" forState:UIControlStateNormal];

        ison = NO;
    }
    [self refresh];

}

-(void)dealloc {

    [dao release];
    dao = nil;
    [mapView release];
    mapView = nil;
    [switcher release];
    switcher = nil;

    [super dealloc];

}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {


    MKPinAnnotationView *annView = [[[MKPinAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"MyPin"] autorelease] ;
   
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    MapViewAnnotation *check = (MapViewAnnotation*) annotation;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        // do nothing special
    } else {
        if ([[[dao dataItemAtIndex:check.recNum] objectForKey:@"favorite"] boolValue]) {             annView.pinColor = MKPinAnnotationColorGreen;
        } else {
            annView.pinColor = MKPinAnnotationColorRed;
        }
    }


    return annView;
 
}

- (void) mapView: (MKMapView *)mapView didSelectAnnotationView: (MKAnnotationView *) view {

    if (![view.annotation isKindOfClass:[MKUserLocation class]]) {
        // need to figure out which one this is so can call the detail view for it
        MapViewAnnotation *annotation = (MapViewAnnotation*)view.annotation;

        // now send recNum to detail view!
        detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        // ...
        // Pass the selected object to the new view controller.
        [detail setRecordNum:annotation.recNum];
        [detail setDao:dao];
        [self.navigationController pushViewController:detail animated:YES];
    }

}

@end
