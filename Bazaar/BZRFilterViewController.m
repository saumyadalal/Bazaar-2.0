//
//  BZRFilterViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/5/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRFilterViewController.h"
#import "BZRBazaarController.h"
#import "SWRevealViewController.h"

@interface BZRFilterViewController ()
@property (strong, nonatomic) NSArray *filters;
@end

static NSString * const cellIdentifier = @"filterCell";

@implementation BZRFilterViewController

//always register the nib here, not in init
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.filters = @[@"Accessories", @"Books", @"Clothes", @"Electronics", @"Entertainment", @"Food", @"Furniture", @"Household"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
  return self.filters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  UILabel *filterLabel = (UILabel *)[cell viewWithTag:201];
  filterLabel.text = [self.filters objectAtIndex:indexPath.row];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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



// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //selected filter
    NSString *filter = [self.filters objectAtIndex:indexPath.row];
  // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showFilter"]) {
      //throws error with rootViewController
      BZRBazaarController *bazaarVC = (BZRBazaarController*)[segue.destinationViewController topViewController];
      bazaarVC.currentFilter = filter;
      //require this to reload data
      [bazaarVC viewDidRequestRefresh];
      /*
      NSLog(@" %@", bazaarVC.navigationItem.title);
      NSLog(@" %@", bazaarVC.title);
      NSLog(@" %@", [[segue.destinationViewController topViewController] class]);
      bazaarVC.navigationItem.title = filter;
      bazaarVC.title = filter;
      
      [bazaarVC viewDidRequestRefresh];
      NSLog(@"hi");
      NSLog(@" %@", bazaarVC.navigationItem.title); */
    }
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
      SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
      swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc,
                               UIViewController* dvc) {
          UITabBarController* tabController = (UITabBarController*) self.revealViewController.frontViewController;
          //loads the view of the respective tab
          [tabController setSelectedIndex:0];
          //slide the sidebar back
          [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}



@end
