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
#import "BZRTabBarController.h"

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
    self.filters = @[@"All", @"Accessories", @"Books", @"Clothes & Shoes", @"Electronics", @"Entertainment", @"Food", @"Furniture", @"Household", @"Other"];
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
  if (indexPath.row == 0) {
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  }
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  BZRTabBarController* tabBarController = (BZRTabBarController*) [self.revealViewController frontViewController];
  UINavigationController* navController = [tabBarController.viewControllers objectAtIndex:0];
  BZRBazaarController* bazaarController = (BZRBazaarController*)[navController topViewController];
  NSString *filter = [self.filters objectAtIndex:indexPath.row];
  [bazaarController changeFilter:filter];
  [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}




@end
