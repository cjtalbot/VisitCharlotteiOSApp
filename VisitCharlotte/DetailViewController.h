//
//  DetailViewController.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDao.h"

@class MapDetailViewController;

@interface DetailViewController : UIViewController {
    IBOutlet UITextView *description;
    IBOutlet UIImageView *picture;
    IBOutlet UIButton *favorite;
    int recordNum;
    DataDao *dao;
    MapDetailViewController *map;
}

-(IBAction)viewMap:(UIButton *)sender;
-(IBAction)addToFavorites:(UIButton *)sender;


@property (nonatomic) int recordNum;
@property (retain, nonatomic) DataDao *dao;

@end
