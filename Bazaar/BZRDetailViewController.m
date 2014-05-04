//
//  BZRDetailViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/3/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRDetailViewController.h"
#import "BZRTradeViewController.h"
#import <Parse/Parse.h>

@interface BZRDetailViewController ()
@property (strong, nonatomic) UIButton *favoriteButton;
@property (strong, nonatomic) UIButton *tradeButton;
@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) PFObject* item;
@end

static NSString * const cellIdentifier = @"detailViewCell";

@implementation BZRDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //set the intitial current item
    self.item = [self.items objectAtIndex:self.currentIndexPath.row];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
}


- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.collectionView reloadData];
  [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
  if (self.inSelectionMode) {
    [self disableAndHideTradeButtons];
  }
  else {
    [self.selectButton setEnabled:NO];
    self.selectButton.hidden = YES;
  }
}


- (void) configureLabels:(PFObject *)item {
  if ([self userOwnsItem:item]) {
    [self disableAndHideTradeButtons];
  }
  [self configureFavoriteLabel:item];
}

- (void) disableAndHideTradeButtons {
  self.favoriteButton.hidden = YES;
  self.tradeButton.hidden = YES;
  [self.favoriteButton setEnabled:NO];
  [self.tradeButton setEnabled:NO];
}

- (void) configureFavoriteLabel:(PFObject*) item {
  if ([self isFavorited:item]) {
    //this doesn't work: self.favoriteButton.titleLabel.text = @"Unfavorite";
    [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
  }
  else {
    [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
  }
}

- (BOOL) isFavorited:(PFObject*) currentItem {
  PFUser *user = [PFUser currentUser];
  NSMutableArray *favoritesArray = user[@"favorites"];
  for(PFObject *item in favoritesArray){
    if ([currentItem objectId] == [item objectId]) {
      return YES;
    }
  }
  return NO;
}

- (BOOL) userOwnsItem :(PFObject*) item {
  PFUser* owner = [item objectForKey:@"owner"];
  PFUser* user = [PFUser currentUser];
  if([[owner objectId] isEqualToString:[user objectId]]){
    return true;
  }
  return false;
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.items.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:403];
  UILabel *itemName = (UILabel *) [cell viewWithTag:404];
  UILabel *itemDescription = (UILabel *) [cell viewWithTag:405];
  self.favoriteButton = (UIButton *) [cell viewWithTag:407];
  self.tradeButton = (UIButton *) [cell viewWithTag:406];
  self.selectButton = (UIButton *) [cell viewWithTag:408];

  PFObject* item = [self.items objectAtIndex:indexPath.item];
  [self configureLabels:item];
  //call this to fetch image data
  [item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      PFFile *imageFile = [object objectForKey:@"imageFile"];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          itemImageView.image = [UIImage imageWithData:data];
          itemName.text = [object objectForKey:@"name"];
          itemDescription.text = [object objectForKey:@"description"];
          [self loadUserInfo:[item objectForKey:@"owner"] onCell:cell];
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


- (void) loadUserInfo:(PFUser *) user onCell:(UICollectionViewCell *)cell {
  [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      PFFile *imageFile = [user objectForKey:@"imageFile"];
      UIImageView *ownerImageView = (UIImageView *)[cell viewWithTag:401];
      UILabel *ownerName = (UILabel *) [cell viewWithTag:402];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          ownerImageView.image = [UIImage imageWithData:data];
          ownerName.text = [user objectForKey:@"username"];
        }
        else {
          NSLog(@"error fetching image");
        }
      }];
    }
    else {
      NSLog(@"error fetching user data");
    }
  }];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//update current index path
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  if ([[self.collectionView visibleCells] count] > 0) {
    UICollectionViewCell *currentCell = [[self.collectionView visibleCells] objectAtIndex:0];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:currentCell];
    self.currentIndexPath = indexPath;
    self.item = [self.items objectAtIndex:self.currentIndexPath.row];
  }
}

- (IBAction)addToFavorites:(id)sender {
  NSLog(@" current item %@", [self.item objectForKey:@"name"]);
  PFUser *currentUser = [PFUser currentUser]; //get current user's info
  if(![self isFavorited:self.item]){ //add item only if it isn't already in favorites array
    [currentUser addObject:self.item forKey:@"favorites"]; //add current object to favorites
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (!error) {
        NSLog(@"favorites added");
        [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
      }
      else {
        NSLog(@"error adding favorites");
      }
    }];
  }
  else { //unfavorite
    [currentUser removeObject:self.item forKey:@"favorites"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (!error) {
        NSLog(@"favorites removed");
        [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
      }
      else {
        NSLog(@"error removing favorites");
      }
    }];
  }
}

- (IBAction)selectItem:(id)sender {
  
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"initiateTradeView"]) //look for specific segue
  {
    BZRTradeViewController *tradeViewController
      = (BZRTradeViewController *) segue.destinationViewController;
    tradeViewController.item = self.item; //give item to destination controller
  }
  
}




@end
