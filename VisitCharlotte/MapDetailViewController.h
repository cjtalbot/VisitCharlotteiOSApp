//
//  MapDetailViewController.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDao.h"
#import <MapKit/MapKit.h>

@interface MapDetailViewController : UIViewController {
    DataDao *dao;
    int recordNum;
    IBOutlet MKMapView *mapView;
    int ZoomAmt;
    IBOutlet UILabel *addr;
}

@property (nonatomic) int recordNum;
@property (retain, nonatomic) DataDao *dao;
@property (retain, nonatomic) MKMapView *mapView;

@end
