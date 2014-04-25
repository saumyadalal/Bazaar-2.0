//
//  BZRUserMarketPlaceViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/25/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRUserMarketPlaceViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>

@interface BZRUserMarketPlaceViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@end

static NSString * const cellIdentifier = @"UserItemCell";

@implementation BZRUserMarketPlaceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    SWRevealViewController *revealController = self.tabBarController.revealViewController;
    self.navigationItem.leftBarButtonItem.target = revealController;
    self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
	// Do any additional setup after loading the view.
    [self loadMarketPlace];
    [self.collectionView reloadData];
    //[self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor whiteColor];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ViewDidRequestRefresh
{
  [self loadMarketPlace];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(120, 120);
}

- (void)loadMarketPlace
{
  PFQuery *query = [PFQuery queryWithClassName:@"Item"];
  [query whereKey:@"owner" equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      NSLog(@"Successfully retrieved %d items", objects.count);
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
  NSLog(@" %d", self.items.count);
  return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:101];
  UILabel *itemName = (UILabel *) [cell viewWithTag:102];
  PFObject* item = [self.items objectAtIndex:indexPath.row];
  //call this to fetch image data
  [item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      NSLog(@"fetched item");
      PFFile *imageFile = [object objectForKey:@"imageFile"];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          NSLog(@"fetched image");
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


@end
