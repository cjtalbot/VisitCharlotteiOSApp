//
//  RootViewController.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/22/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDao.h"

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DataDao *dao;
    DetailViewController *detail;

}



@end
