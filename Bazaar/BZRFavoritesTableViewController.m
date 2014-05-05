//
//  BZRFavoritesTableViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRFavoritesTableViewController.h"

@interface BZRFavoritesTableViewController ()
@property (nonatomic, strong) NSArray *items;
@end

static NSString * const cellIdentifier = @"favoriteItemCell";

@implementation BZRFavoritesTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser *user = [PFUser currentUser]; //get current user info
    self.favoriteArray = user[@"favorites"]; //get current user's favorite's info
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


- (void)loadItemData: (PFObject*) item forCell:(UITableViewCell*) cell{
  UILabel *itemName = (UILabel *)[cell.contentView viewWithTag:502];
  UIImageView *itemImageView = (UIImageView *)[cell.contentView viewWithTag:501];
  [item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      PFFile *imageFile = [object objectForKey:@"imageFile"];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          itemImageView.image = [UIImage imageWithData:data];
          itemName.text = [object objectForKey:@"name"];
        }
        else {
          NSLog(@"error fetching image");
        }
      }];
    }
    else {
      NSLog(@"error fetching data");
    }
  }];
}

//instantiate detail view controller here since the segue in storyboard doesn't seem to work
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BZRItemViewController* detailView = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil]
//                                         instantiateViewControllerWithIdentifier:@"itemViewController"];
//    detailView.item = [self.favoriteArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detailView animated:YES];
//}


@end
