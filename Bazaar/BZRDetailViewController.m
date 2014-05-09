//
//  BZRDetailViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/3/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRDetailViewController.h"
#import "BZRTradeViewController.h"
#import "BZRTradeUtils.h"
#import "BZRDesignUtils.h"
#import "BZRUserMarketPlaceViewController.h"
#import "BZRUserProfileViewController.h"
#import <Parse/Parse.h>

@interface BZRDetailViewController ()
@property (strong, nonatomic) UIButton *favoriteButton;
@property (strong, nonatomic) UIButton *tradeButton;
@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) UIButton *noButton;
@property (strong, nonatomic) PFObject* item;
@property (nonatomic, strong) NSArray* trades;
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
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //set the intitial current item
    self.item = [self.items objectAtIndex:self.currentIndexPath.row];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
}


- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.collectionView reloadData];
  [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

}

//- (void):(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//  //CGRect screenSize = [[[UIScreen mainScreen] bounds] size];
//}

/**********************
 *** Trade-Favorite Buttons
 **********************/

// Main method: hide labels if the item is owned by user

- (void) configureLabels:(PFObject *)item {
  if ([self userOwnsItem:item]) {
    [self hideTradeButtons:YES];
  }
  else{
    [self hideTradeButtons:NO];
  }
  if (self.inSelectionMode) {
    [self hideTradeButtons:YES];
  }
  else {
    [self hideSelectButtons:YES];
  }
  [self configureFavoriteLabel:item];
}

- (void) loadTrades: (PFObject*) item{
    PFQuery *initiatorQuery = [PFQuery queryWithClassName:@"Trade"];
    [initiatorQuery whereKey:@"initiator" equalTo:[PFUser currentUser]];
    [initiatorQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.trades = objects;
            for (PFObject *tradeItems in self.trades){
                if([[item objectId] isEqual:[[tradeItems objectForKey:@"item"] objectId]] && ![[tradeItems objectForKey:@"status"] isEqual: @"cancelled"]){
                    [self.tradeButton setTitle:@"Trading" forState:UIControlStateNormal];
                    self.tradeButton.backgroundColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
                    self.tradeButton.titleLabel.textColor = [UIColor darkGrayColor];
                    [self.tradeButton setEnabled:NO];
                    break;
                }
                else {
                    [self.tradeButton setTitle:@"Trade" forState:UIControlStateNormal];
                    self.tradeButton.backgroundColor = [BZRDesignUtils purpleColor];
                    self.tradeButton.titleLabel.textColor = [UIColor whiteColor];
                    [self.tradeButton setEnabled:YES];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
// individual configuration

- (void) configureFavoriteLabel:(PFObject*) item {
  if ([self isFavorited:item]) {
    //this doesn't work: self.favoriteButton.titleLabel.text = @"Unfavorite";
    [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
  }
  else {
    [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
  }
}

- (void) hideTradeButtons:(BOOL)isHidden {
  [self.favoriteButton setHidden:isHidden];
  [self.tradeButton setHidden:isHidden];
}

- (BOOL) userOwnsItem :(PFObject*) item {
  PFUser* owner = [item objectForKey:@"owner"];
  PFUser* user = [PFUser currentUser];
  if([[owner objectId] isEqualToString:[user objectId]]){
    return YES;
  }
  return NO;
}

/**********************
 *** Trade-Favorite Buttons
 **********************/


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
  itemName.font = [UIFont fontWithName:@"Gotham-Medium" size:14];
  UILabel *itemDescription = (UILabel *) [cell viewWithTag:405];
  self.favoriteButton = (UIButton *) [cell viewWithTag:407];
  self.tradeButton = (UIButton *) [cell viewWithTag:406];
  self.selectButton = (UIButton *) [cell viewWithTag:408];
    UIImageView *backArrow = (UIImageView *)[cell viewWithTag:409];
    UIImageView *forwardArrow = (UIImageView *)[cell viewWithTag:410];
    self.item = [self.items objectAtIndex:indexPath.item];
    if(indexPath.item == 0){
        backArrow.hidden = YES;
        forwardArrow.hidden = NO;
    }
    else if(indexPath.item == self.items.count-1){
        forwardArrow.hidden = YES;
        backArrow.hidden = NO;
    }
    else {
        backArrow.hidden = NO;
        forwardArrow.hidden = NO;
    }
  //does initial configure for the current buttons stored on the object
  [self configureLabels:self.item];
  [self configureSelectButton:self.selectButton forItem:self.item];
  [self loadTrades:self.item]; //hide trade buttons if already trading for item
  //call this to fetch image data
  [self.item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      itemName.text = [object objectForKey:@"name"];
      itemDescription.text = [object objectForKey:@"description"];
      [self loadUserInfo:[self.item objectForKey:@"owner"] onCell:cell];
      [BZRTradeUtils loadImage:itemImageView fromItem:self.item];
    }
    else {
      NSLog(@"error fetching data");
    }
  }];
  return cell;
}


/**********************
 *** Select Buttons start
 **********************/

//called in didStopScrolling
- (void)configureSelectButton:(UIButton*) button forItem:(PFObject*) item {
  BOOL isSelected = [self.delegate isSelected:item];
  //return early if limit has been reached since button should not
  //be toggled.
  if ([self.delegate didReachLimit] && !isSelected) {
    [button setEnabled:NO];
    [button setBackgroundColor:[UIColor grayColor]];
    return;
  }
  else {
    [button setEnabled:YES];
    [self toggleButton:button onSelection:isSelected];
  }
}

- (void) hideSelectButtons:(BOOL)isHidden {
  [self.selectButton setHidden:isHidden];
}

- (void) toggleButton:(UIButton*)button onSelection:(BOOL)isSelected  {
  [button setBackgroundColor:[UIColor colorWithRed:79/255.0 green:44/255.0 blue:112/255.0 alpha:1]];
  if (isSelected) {
    [button setTitle:@"Added to Bid" forState:UIControlStateNormal];
  }
  else {
    [button setTitle:@"Select Item" forState:UIControlStateNormal];
  }
}


- (IBAction)selectItem:(id)sender {
  PFObject* item = [self.items objectAtIndex:self.currentIndexPath.item];
  BOOL isSelected = [self.delegate editReturnWithItem:item];
  //to see immediate change
  [self toggleButton:self.selectButton onSelection:isSelected];
}

/**********************
 *** Select Buttons end
 **********************/




- (IBAction)goToProfileView:(id)sender {
    //[self performSegueWithIdentifier:@"viewUserProfile" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"initiateTradeView"]) //look for specific segue
  {
    BZRTradeViewController *tradeViewController
      = (BZRTradeViewController *) segue.destinationViewController;
    tradeViewController.item = self.item; //give item to destination controller
  }
  else if([[segue identifier] isEqualToString:@"viewUserProfile"]){
    BZRUserMarketPlaceViewController *marketplaceView = (BZRUserMarketPlaceViewController *) segue.destinationViewController;
      marketplaceView.user = [self.item objectForKey:@"owner"];
    BZRUserProfileViewController *profileView = (BZRUserProfileViewController *) segue.destinationViewController;
      profileView.user = [self.item objectForKey:@"owner"];
  }
  
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
            ownerName.font = [UIFont fontWithName:@"Gotham-Medium" size:14];
          ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width / 2;
          ownerImageView.clipsToBounds = YES;
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
//**** turns out clicking a button calls this too?
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  if ([[self.collectionView visibleCells] count] > 0) {
    UICollectionViewCell *currentCell = [[self.collectionView visibleCells] objectAtIndex:0];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:currentCell];
    //update labels
    if (![indexPath isEqual:self.currentIndexPath]) {
      self.currentIndexPath = indexPath;
      self.item = [self.items objectAtIndex:self.currentIndexPath.row];
      //set the current select button and favorite buttons
      self.selectButton = (UIButton*) [currentCell viewWithTag:408];
      self.favoriteButton = (UIButton*)[currentCell viewWithTag:407];
      [self configureLabels:self.item];
      [self configureSelectButton:(UIButton*)self.selectButton forItem:self.item];
    }
  }
}


- (BOOL) isFavorited:(PFObject*) currentItem {
  PFUser *user = [PFUser currentUser];
  NSMutableArray *favoritesArray = user[@"favorites"];
  for(PFObject *item in favoritesArray){
    if ([[currentItem objectId] isEqual:[item objectId]]) {
      return YES;
    }
  }
  return NO;
}

- (IBAction)addToFavorites:(id)sender {
  PFUser *currentUser = [PFUser currentUser]; //get current user's info
  if(![self isFavorited:self.item]){ //add item only if it isn't already in favorites array
    [currentUser addObject:self.item forKey:@"favorites"]; //add current object to favorites
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (!error) {
        NSLog(@"favorites added");
        [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
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
        [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
      }
      else {
        NSLog(@"error removing favorites");
      }
    }];
  }
}




@end
