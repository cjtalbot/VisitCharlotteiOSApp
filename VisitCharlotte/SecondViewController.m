//
//  SecondViewController.m
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/23/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import "SecondViewController.h"
#import "DetailViewController.h"
#import "ItemInputController.h"


@implementation SecondViewController

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dao = [[DataDao alloc] initWithDataName:@"database"];
    self.title = @"Itinerary";
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];

}

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


- (void)dealloc
{
    [dao release];
    dao = nil;
    [detail release];
    detail = nil;
    [itemInputController release];
    itemInputController = nil;
    [super dealloc];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int count = [[[dao dataItemAtIndex:0] valueForKey:@"maxFavs"] intValue];
    if(self.editing) count++;
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    // Set up the cell...
    if(indexPath.row == ([[[dao dataItemAtIndex:0] valueForKey:@"maxFavs"] intValue]) && self.editing){
        cell.textLabel.text = @"Add New Row";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
        return cell;
    }
    int recordLoc = [[[[dao dataItemAtIndex:0] valueForKey:@"favlist"] objectAtIndex:indexPath.row] intValue];
   
    cell.textLabel.text = [[dao dataItemAtIndex:recordLoc] valueForKey:@"shortName"];
    cell.detailTextLabel.text = [[dao dataItemAtIndex:recordLoc] valueForKey:@"name"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if ([[dao dataItemAtIndex:recordLoc] valueForKey:@"image"] != nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[[dao dataItemAtIndex:recordLoc]  
                                                                 valueForKey:@"image"] 
                                                         ofType:[[dao dataItemAtIndex:recordLoc] 
                                                                 valueForKey:@"extension"]];
        if (path != nil) {
            cell.imageView.image = [UIImage imageWithContentsOfFile:path];
        }
        
        path = nil;
    } else {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    
    // need to change this to carry over the favlist's index # not indexPath.row
    int mainRowNum = [[[[dao dataItemAtIndex:0] valueForKey:@"favlist"] objectAtIndex:indexPath.row] intValue];
    [detail setRecordNum:mainRowNum];
    [detail setDao:dao];
    [self.navigationController pushViewController:detail animated:YES];

	
}

-(void)viewDidLoad {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Itinerary" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
    [self.navigationItem setLeftBarButtonItem:addButton];
    [addButton release];
}

- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit Itinerary"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done Editing"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already
    // existing content. Existing content can be deleted.
    if (self.editing && indexPath.row == ([[[dao dataItemAtIndex:0] valueForKey:@"maxFavs"] intValue])) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dao removeForReorderingFavorites:indexPath.row]; // is this the right number to pass?
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // add item from a list
        [self addItem];

        [self.tableView reloadData];
    }
}

-(void)addItem {
    if (itemInputController == nil) {
        itemInputController = [[ItemInputController alloc] init];
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:itemInputController];

    [[self navigationController] presentModalViewController:navigationController animated:YES];
    [navigationController release];
    
}

-(void)save:(int)rowNum {
    
    [dao addToFavorites:rowNum atPosition:[[[dao dataItemAtIndex:0] valueForKey:@"maxFavs"] intValue]];
    [self dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
    
}

#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != [[[dao dataItemAtIndex:0] valueForKey:@"maxFavs"] intValue]) {
        return YES;
    } else {
        return NO; // don't allow reordering the add new row record
    }
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    int item = [[[[dao dataItemAtIndex:0] valueForKey:@"favlist"] objectAtIndex:fromIndexPath.row] intValue];//[[arryData objectAtIndex:fromIndexPath.row] retain];

    [dao removeForReorderingFavorites:fromIndexPath.row];

    [dao addToFavorites:item atPosition:toIndexPath.row];

}

@end
