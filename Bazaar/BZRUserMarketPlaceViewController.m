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
#import "BZRTradeUtils.h"
#import "BZRDesignUtils.h"


@interface BZRUserMarketPlaceViewController () <BZRItemDelegate>
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@end

static NSString * const cellIdentifier = @"UserItemCell";

//currently items are loaded only the first time in viewDidLoad
//and the collection view is refreshed when self.selectedItems has changed.
@implementation BZRUserMarketPlaceViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //allow for multiple refresh only when not in selection mode
    if (self.inSelectionMode) {
      [self.collectionView reloadData];
    }
    else {
      [self loadMarketPlace];
    }
}

/********************
 *** Selection Mode : Start
 *********************/

- (BOOL)editReturnWithItem:(PFObject *)item {
  BOOL isSelected = [self isSelected:item];
  if (isSelected) {
    [self removeReturnItem:item];
  }
  else {
    [self.selectedItems addObject:item];
  }
  return !isSelected;
  //reload data is called in view did appear anyway
}

- (BOOL) isSelected:(PFObject *)item {
  //***** [self.selectedItems containsObject:item] does not work
  for (PFObject* currentItem in self.selectedItems) {
    if ([[currentItem objectId] isEqualToString:[item objectId]]) {
      return YES;
    }
  }
  return NO;
}

//Temporary fix for [self.selectedItems removeObject:item]
//doesn't work for items populated from self.returns.
- (void) removeReturnItem:(PFObject*) item {
  PFObject* removeItem = nil;
  for (PFObject* currentItem in self.selectedItems) {
    if ([[currentItem objectId] isEqualToString:[item objectId]]) {
      removeItem = currentItem;
      break;
    }
  }
  [self.selectedItems removeObject:removeItem];
}

- (BOOL) didReachLimit {
  NSUInteger size = [self.selectedItems count];
  //can compare int values, not NSNumber
  if (size >= [self.returnLimit intValue]) {
    return YES;
  }
  return NO;
}


- (void) saveReturnItems:(PFObject*) trade {
  trade[@"returnItems"] = self.selectedItems;
  [trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      NSLog(@"saved return items");
    }
    else {
      NSLog(@"error saving return items");
    }
  }];
}

/********************
 *** Selection Mode : End
 *********************/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// to populate self.items
    [self loadMarketPlace];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.noItemsLabel setTextColor:[BZRDesignUtils placeHolderColor]];
    [self.noItemsLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:17]];
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
  return CGSizeMake(103, 103);
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
  [query whereKey:@"status" equalTo:@"available"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      NSUInteger oldCount = [self.items count];
      //refresh only if new items have been added
      if ([objects count] > oldCount) {
        self.items = [[NSMutableArray alloc] initWithArray:objects];
        [self.collectionView reloadData];
        if ([self.items count] == 0) {
          [self.noItemsLabel setHidden:NO];
        }
        else {
          [self.noItemsLabel setHidden:YES];
        }
      }
      //to udpate number of items on profile
      [self.delegate updateNumItems:[self.items count]];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(3,3,3,3);
    
    return insets;
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
  if (self.inSelectionMode && [self isSelected:item]) {
      cell.alpha = 0.3;
  }
  else {
      cell.alpha = 1.0;
  }
  //call this to fetch image data
  [item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      itemName.text = [object objectForKey:@"name"];
      [BZRDesignUtils fitTextInLabel:itemName];
      [BZRTradeUtils loadImage:itemImageView fromItem:item];
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
