//
//  SecondViewController.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDao.h"
#import "ItemInputController.h"

@class DetailViewController;

@interface SecondViewController : UITableViewController {
    DataDao *dao;
    DetailViewController *detail;
    ItemInputController *itemInputController;

}

- (IBAction) EditTable:(id)sender;
- (void) addItem;


@end
