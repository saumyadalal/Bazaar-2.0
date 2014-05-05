//
//  BZRUserMarketPlaceViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/25/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRUserMarketPlaceViewController.h"
#import <Parse/Parse.h>
#import "BZRDetailViewController.h"


@interface BZRUserMarketPlaceViewController () <BZRItemDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSMutableSet *selectedIndexPaths;
@end

static NSString * const cellIdentifier = @"UserItemCell";

@implementation BZRUserMarketPlaceViewController


- (BOOL) didReachLimit {
  NSUInteger size = [self.selectedIndexPaths count];
  NSLog(@" hi limit is %@ ", self.returnLimit);
  NSLog(@" current count %@ ", [NSNumber numberWithInt:size]);
  //can compare int values, not NSNumber
  if (size >= [self.returnLimit intValue]) {
    return YES;
  }
  return NO;
}

- (void) highlightSelectedItems {
  for (NSIndexPath* indexPath in self.selectedIndexPaths) {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
  }
}

- (BOOL) isSelected:(NSIndexPath *)indexPath {
  NSLog(@" %d he", [self.selectedIndexPaths count]);
  if ([self.selectedIndexPaths containsObject:indexPath]) {
    return YES;
  }
  return NO;
}


- (void) saveReturnItems:(PFObject*) trade {
  NSMutableArray* returnItems = [[NSMutableArray alloc] init];
  for(NSIndexPath* indexPath in self.selectedIndexPaths) {
    PFObject* item = [self.items objectAtIndex:indexPath.row];
    [returnItems addObject:item];
  }
  trade[@"returnItems"] = returnItems;
  [trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      NSLog(@"saved return items");
    }
    else {
      NSLog(@"error saving return items");
    }
  }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// to populate self.items
    [self loadMarketPlace];
    //[self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.selectedIndexPaths = [[NSMutableSet alloc] initWithArray:@[]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0; // This is the minimum inter item spacing, can be more
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(100, 100);
}

- (void) didSelectItem:(BOOL)selected AtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@" selected item %hhd", selected);
  if (selected) {
    [self.selectedIndexPaths addObject:indexPath];
  }
  else {
    [self.selectedIndexPaths removeObject:indexPath];
  }

}





//load the items owned by the user
- (void)loadMarketPlace
{
  if (self.user == nil) {
    self.user = [PFUser currentUser];
  }
  PFUser *user = self.user;
  PFQuery *query = [PFQuery queryWithClassName:@"Item"];
  [query whereKey:@"owner" equalTo:user];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      self.items = objects;
      [self.collectionView reloadData];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:101];
  UILabel *itemName = (UILabel *) [cell viewWithTag:102];
  PFObject* item = [self.items objectAtIndex:indexPath.row];
  
  //if in selection mode
  if ([self.selectedItems containsObject:item] && self.inSelectionMode) {
      //add object to selected index path
      [self.selectedIndexPaths addObject:indexPath];
      itemName.backgroundColor = [UIColor greenColor];
  }
  
  //call this to fetch image data
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
  return cell;
}


//instantiate detail view controller here since the segue in storyboard doesn't seem to work
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  BZRDetailViewController* detailView = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil]
                        instantiateViewControllerWithIdentifier:@"detailViewController"];
  detailView.items = self.items;
  detailView.currentIndexPath = indexPath;
  detailView.inSelectionMode = self.inSelectionMode;
  [detailView setDelegate:self];
  [self.navigationController pushViewController:detailView animated:YES];
}


@end
