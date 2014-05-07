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
@property (strong, nonatomic) UIButton *yesButton;
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
    //set the intitial current item
//    NSLog(@"item: %@",self.items);
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
    [self disableAndHideTradeButtons];
  }
  else{
    [self enableTradeButtons];
  }
  if (self.inSelectionMode) {
    [self disableAndHideTradeButtons];
  }
  else {
    [self disableAndHideSelectButtons];
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
                NSLog(@"trade items: %@",[[tradeItems objectForKey:@"item"] objectId]);
                NSLog(@"current item: %@",[item objectId]);
                if([[item objectId] isEqual:[[tradeItems objectForKey:@"item"] objectId]]){
                    NSLog(@"here");
                    self.tradeButton.hidden = YES;
                    [self.tradeButton setEnabled:NO];
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

- (void) disableAndHideTradeButtons {
  self.favoriteButton.hidden = YES;
  self.tradeButton.hidden = YES;
  [self.favoriteButton setEnabled:NO];
  [self.tradeButton setEnabled:NO];
}

- (void) enableTradeButtons {
    self.favoriteButton.hidden = NO;
    self.tradeButton.hidden = NO;
    [self.favoriteButton setEnabled:YES];
    [self.tradeButton setEnabled:YES];
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
  UILabel *itemDescription = (UILabel *) [cell viewWithTag:405];
  self.favoriteButton = (UIButton *) [cell viewWithTag:407];
  self.tradeButton = (UIButton *) [cell viewWithTag:406];
  self.yesButton = (UIButton *) [cell viewWithTag:408];
  self.noButton = (UIButton *) [cell viewWithTag:409];
  PFObject* item = [self.items objectAtIndex:indexPath.item];
  [self configureLabels:item];
  [self configureSelectButtons:indexPath];
    [self loadTrades:item];
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


/**********************
 *** Select Buttons
 **********************/

- (void)configureSelectButtons:(NSIndexPath*) currentIndexPath {
  //the item is selected
  if ([self.delegate isSelected:currentIndexPath]) {
    [self toggleSelected:self.yesButton];
  }
  else {
    [self toggleSelected:self.noButton];
  }
  if ([self.delegate didReachLimit]) {
    //disable yes button selection
    [self.yesButton setEnabled:NO];
    return;
  }
}

- (void) disableAndHideSelectButtons {
  [self.yesButton setEnabled:NO];
  [self.noButton setEnabled:NO];
  self.yesButton.hidden = YES;
  self.noButton.hidden = YES;
}


- (void) toggleSelected: (UIButton*)button {
  //disable the selected button
  UIButton* disableButton = button;
  UIButton* enableButton;
  //yes button is selected
  if ([button isEqual:self.yesButton]) {
    enableButton = self.noButton;
      self.yesButton.backgroundColor = [UIColor grayColor];
      self.noButton.backgroundColor = [UIColor purpleColor];
  }
  else {
    enableButton = self.yesButton;
      self.noButton.backgroundColor = [UIColor grayColor];
      self.yesButton.backgroundColor = [UIColor purpleColor];
  }
  [enableButton setEnabled:YES];
  [disableButton setEnabled:NO];
}

/**********************
 *** Select Buttons
 **********************/

- (IBAction)selectItem:(id)sender {
  [self toggleSelected:self.yesButton];
  [self.delegate didSelectItem:YES AtIndexPath:self.currentIndexPath];
}

- (IBAction)deselectItem:(id)sender {
  [self toggleSelected:self.noButton];
  [self.delegate didSelectItem:NO AtIndexPath:self.currentIndexPath];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"initiateTradeView"]) //look for specific segue
  {
    BZRTradeViewController *tradeViewController
      = (BZRTradeViewController *) segue.destinationViewController;
    tradeViewController.item = self.item; //give item to destination controller
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
  NSLog(@"did stop decelerating");
  if ([[self.collectionView visibleCells] count] > 0) {
    UICollectionViewCell *currentCell = [[self.collectionView visibleCells] objectAtIndex:0];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:currentCell];
    //update labels
    if (![indexPath isEqual:self.currentIndexPath]) {
      self.currentIndexPath = indexPath;
      self.item = [self.items objectAtIndex:self.currentIndexPath.row];
      [self configureLabels:self.item];
      [self configureSelectButtons:indexPath];
        [self loadTrades:self.item];
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
