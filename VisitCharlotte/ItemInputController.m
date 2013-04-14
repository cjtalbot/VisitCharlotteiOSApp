//
//  ItemInputController.m
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/25/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import "ItemInputController.h"
#import "DataDao.h"


@implementation ItemInputController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [dao release];
    dao = nil;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dao = [[DataDao alloc] initWithDataName:@"database"];
    self.title = @"Choose an Item to Add";
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    int count = [dao dataCount];
    
    return count + 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [dao dataCount] ||[[[dao dataItemAtIndex:indexPath.row] valueForKey:@"favorite"] boolValue]) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.2 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DataListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    if(indexPath.row == [dao dataCount]) {
        cell.textLabel.text = @"Cancel Selection";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    } else {
    
        cell.textLabel.text = [[dao dataItemAtIndex:indexPath.row] valueForKey:@"shortName"];
        if ([[[dao dataItemAtIndex:indexPath.row] valueForKey:@"favorite"] boolValue]) {
            cell.detailTextLabel.text = @"Already in Itinerary";

        } else {
            cell.detailTextLabel.text = [[dao dataItemAtIndex:indexPath.row] valueForKey:@"name"];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    
        if ([[[dao dataItemAtIndex:indexPath.row] valueForKey:@"favorite"] boolValue]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    
        if ([[dao dataItemAtIndex:indexPath.row] valueForKey:@"image"] != nil) {
            NSString *path = [[NSBundle mainBundle] pathForResource:[[dao dataItemAtIndex:indexPath.row]  
                                                                 valueForKey:@"image"] 
                                                         ofType:[[dao dataItemAtIndex:indexPath.row] 
                                                                 valueForKey:@"extension"]];
            if (path != nil) {
                cell.imageView.image = [UIImage imageWithContentsOfFile:path];
            }

            path = nil;
        } else {

            cell.imageView.image = nil;
        }

    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check if clicked cancel
    if (indexPath.row == [dao dataCount] || [[[dao dataItemAtIndex:indexPath.row] valueForKey:@"favorite"] boolValue]) {
        // do nothing & return
    } else {
    // else
    [dao addToFavorites:indexPath.row atPosition:[[[dao dataItemAtIndex:0] valueForKey:@"maxFavs"] intValue]];
    }
    [self dismissModalViewControllerAnimated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
