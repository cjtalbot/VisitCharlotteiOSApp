//
//  FirstViewController.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"
#import "DataDao.h"

@class DetailViewController;

@interface FirstViewController : UIViewController  <MKMapViewDelegate> {
    IBOutlet MKMapView *mapView;
    int ZoomAmt;
    DataDao *dao;
    DetailViewController *detail;
    IBOutlet UIButton *switcher;
    BOOL ison;

}

@property (retain, nonatomic) MKMapView *mapView;


-(void)addAllAnnotations;

-(IBAction)switcherToggle:(id)sender;
-(void)refresh;


@end
