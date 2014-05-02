//
//  BZRBazaarController.m
//  Bazaar
//
//  Created by Meghan Chandarana on 4/26/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRBazaarController.h"
#import "SWRevealViewController.h"
#import "BZRItemViewController.h"

@interface BZRBazaarController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@end

static NSString * const cellIdentifier = @"ItemCell";

@implementation BZRBazaarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    SWRevealViewController *revealController = self.tabBarController.revealViewController;
    self.navigationItem.leftBarButtonItem.target = revealController;
    self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
    [self viewDidRequestRefresh];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.currentFilter;
   // NSLog(@"hi loading marketplace");
   // NSLog(@" %@", self.navigationItem.title);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//reload from database and reload view
- (void)viewDidRequestRefresh
{
    [self loadMarketPlace];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0; // This is the minimum inter item spacing, can be more
}

//collection view reloads data on fetching objects
- (void)loadMarketPlace
{
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    if (self.currentFilter) {
      [query whereKey:@"category" equalTo:self.currentFilter];
    }
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
    UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *itemName = (UILabel *) [cell viewWithTag:2];
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Gotham-Book" size:14.0]];
    PFObject* item = [self.items objectAtIndex:indexPath.row];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"bazaarView"]) //look for specific segue
  {
    BZRItemViewController *detailViewBazaar = (BZRItemViewController *) segue.destinationViewController; //set destination
    NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0]; //look for object index of selected item
    PFObject* item = [self.items objectAtIndex:selectedIndexPath.row];
    detailViewBazaar.item=item; //give item to destination controller
  }
  
}

@end
