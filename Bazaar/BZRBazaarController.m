//
//  BZRBazaarController.m
//  Bazaar
//
//  Created by Meghan Chandarana on 4/26/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRBazaarController.h"
#import "SWRevealViewController.h"

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
    NSLog(@"hi loading marketplace");
    NSLog(@" %@", self.navigationItem.title);
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
    return CGSizeMake(120, 120);
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
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" items %d", self.items.count);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *itemName = (UILabel *) [cell viewWithTag:2];
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

@end
