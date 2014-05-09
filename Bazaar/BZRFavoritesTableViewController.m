//
//  BZRFavoritesTableViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRFavoritesTableViewController.h"
#import "BZRDetailViewController.h"
#import "BZRTradeUtils.h"

@interface BZRFavoritesTableViewController ()
@end

static NSString * const cellIdentifier = @"favoriteItemCell";

@implementation BZRFavoritesTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    // NSUInteger count = self.objectIdArray.count;
    return [self.favoriteArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject* item = [self.favoriteArray objectAtIndex:indexPath.row];
    [self loadItemData:item forCell:cell];
    return cell;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void) refreshData {
  PFUser *user = [PFUser currentUser]; //get current user info
  self.favoriteArray = user[@"favorites"];
  [self.tableView reloadData];
}


- (void)loadItemData: (PFObject*) item forCell:(UITableViewCell*) cell{
  UILabel *itemName = (UILabel *)[cell.contentView viewWithTag:502];
  UILabel *itemStatus = (UILabel *)[cell.contentView viewWithTag:503];
  itemName.font = [UIFont fontWithName:@"Gotham-Book" size:14];
  itemStatus.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  itemStatus.textColor = [UIColor grayColor];
  UIImageView *itemImageView = (UIImageView *)[cell.contentView viewWithTag:501];
  [item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      itemName.text = [item objectForKey:@"name"];
      itemStatus.text = [item objectForKey:@"status"];
      [BZRTradeUtils loadImage:itemImageView fromItem:item];
    }
    else {
      NSLog(@"error fetching item data");
    }
  }];
}


//instantiate detail view controller here since the segue in storyboard doesn't seem to work
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BZRDetailViewController* detailView = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailView.items = self.favoriteArray;
    detailView.currentIndexPath = indexPath;
    detailView.inSelectionMode = NO;
    [self.navigationController pushViewController:detailView animated:YES];
}


@end
