//
//  DetailViewController.m
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import "DetailViewController.h"
#import "MapDetailViewController.h"

@implementation DetailViewController

@synthesize recordNum;
@synthesize dao;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [description release];
    description = nil;
    [picture release];
    picture = nil;
    [dao release];
    dao = nil;
    [favorite release];
    favorite = nil;
    [map release];
    map = nil;
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
    // Do any additional setup after loading the view from its nib.)
    [(UITextView *)description setText:[[dao dataItemAtIndex:recordNum] valueForKey:@"fulltext"]];

    self.title = [[dao dataItemAtIndex:recordNum] valueForKey:@"shortName"];
    NSString *path = [[NSBundle mainBundle] pathForResource:[[dao dataItemAtIndex:recordNum]  
                                                             valueForKey:@"image"] 
                                                     ofType:[[dao dataItemAtIndex:recordNum] 
                                                             valueForKey:@"extension"]];

    picture.image = [UIImage imageWithContentsOfFile:path];
 
    if ([[[dao dataItemAtIndex:recordNum] objectForKey:@"favorite"] boolValue]) {
        

        [favorite setTitle:@"Remove from Itinerary" forState:UIControlStateNormal];

    } else {
        [favorite setTitle:@"Add to Itinerary" forState:UIControlStateNormal];

    }

    path = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)viewMap:(UIButton *)sender {

    map = [[MapDetailViewController alloc] initWithNibName:@"MapDetailViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [map setRecordNum:recordNum];
    [map setDao:dao];
    [self.navigationController pushViewController:map animated:YES];

}

-(IBAction)addToFavorites:(UIButton *)sender {

    if([[[dao dataItemAtIndex:recordNum] objectForKey:@"favorite"] boolValue]) {
        [dao removeFromFavorites:recordNum];
        [favorite setTitle:@"Add to Itinerary" forState:UIControlStateNormal];
    } else {
        [dao addToFavorites:recordNum atPosition:[[[dao dataItemAtIndex:0] objectForKey:@"maxFavs"] intValue]];
        [favorite setTitle:@"Remove from Itinerary" forState:UIControlStateNormal];
    }
}


@end
