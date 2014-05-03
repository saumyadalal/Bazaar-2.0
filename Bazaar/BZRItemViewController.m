//
//  BZRItemViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/20/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRItemViewController.h"

@interface BZRItemViewController ()
@property (strong, nonatomic) UIAlertView *itemAddedView;
@property (strong, nonatomic) UIAlertView *itemRemovedView;
@end

@implementation BZRItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.item) {
      self.itemTitle.text = [self.item objectForKey:@"name"]; //set item title
     // PFUser *user = [self.item objectForKey:@"owner"]; //get user info
      self.itemDescription.text = [self.item objectForKey:@"description"]; //set item description
      PFFile *imageFile = [self.item objectForKey:@"imageFile"];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          self.itemPicture.image = [UIImage imageWithData:data];
          PFUser* owner = [self.item objectForKey:@"owner"];
          [self loadUserInfo:owner];
        }
        else {
          NSLog(@"error fetching image");
        }
      }];
        PFUser *user = [PFUser currentUser];
        NSMutableArray *favoriteArray = user[@"favorites"];
        if([[[self.item objectForKey:@"owner"] objectId] isEqualToString:[user objectId]]){
            self.alreadyFav = 2; //check is user is the owner of the currently viewed item
        }
        for(PFObject *item in favoriteArray){
            NSString *itemIdArray = [item objectId]; //get object id of item in favorites array
            NSString *itemId = [self.item objectId]; //get object id of item
            NSLog(@"item owner: %@",[[self.item objectForKey:@"owner"] objectId]);
            NSLog(@"user: %@",[user objectId]);
            if([itemIdArray isEqual:itemId]){
                self.alreadyFav = 1; //check if the item is already in the favorites array
                break;
            }
            else{
                self.alreadyFav = 0;
            }
        }
        NSLog(@"alreadyFav: %d",self.alreadyFav);
        if(self.alreadyFav==0){ //make button a favorite button if it isn't already in favorites
            self.favoriteLabel.hidden = NO;
            self.unfavoriteLabel.hidden = YES;
            self.cannotFavoriteLabel.hidden = YES;
        }
        else if(self.alreadyFav==2){
            self.favoriteLabel.hidden = YES;
            self.unfavoriteLabel.hidden = YES;
            self.cannotFavoriteLabel.hidden = NO;
            [self.favoriteButton setBackgroundColor:[UIColor redColor]];
        }
        else{ //make button an unfavorite button if it is already in favorites
            self.favoriteLabel.hidden = YES;
            self.unfavoriteLabel.hidden = NO;
            self.cannotFavoriteLabel.hidden = YES;
           [self.favoriteButton setBackgroundColor:[UIColor lightGrayColor]]; //change background color of button
        }
    }
}

- (void) loadUserInfo:(PFUser *) user {
  [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      PFFile *imageFile = [user objectForKey:@"imageFile"];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          self.profilePicture.image = [UIImage imageWithData:data];
          self.ownerName.text = [user objectForKey:@"username"];
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

- (IBAction)initiateTrade:(id)sender {
    PFObject *trade = [PFObject objectWithClassName:@"Trade"];
    trade[@"item"] = self.item.objectId;
    trade[@"owner"] = [self.item objectForKey:@"owner"];
    trade[@"initiator"] = [PFUser currentUser];
    trade[@"status"] = @"initiated";
    trade[@"numItems"] = @1;
    trade[@"returnItems"] = @[];
    [trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saved new initiated trade");
        }
        else {
            NSLog(@"error setting up trade");
        }
    }];
}

- (IBAction)addToFavorites:(id)sender {
    PFUser *currentUser = [PFUser currentUser]; //get current user's info
    if(self.alreadyFav==0){ //add item only if it isn't already in favorites array
        [currentUser addObject:self.item forKey:@"favorites"]; //add current object to favorites
        NSLog(@"favorites %@",currentUser[@"favorites"]);
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"favorites added");
            }
            else {
                NSLog(@"error adding favorites");
            }
        }];
        self.itemAddedView = [[UIAlertView alloc] initWithTitle:@"Favorites" message:@"Item Added to Favorites" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]; //pop up to notify item was added to favorites
        [self.itemAddedView show];

    }
    else if(self.alreadyFav==1){ //take out item from favorites if the "unfavorite" button is clicked
        NSLog(@"array before: %@",currentUser[@"favorites"]);
        [currentUser removeObject:self.item forKey:@"favorites"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"favorites removed");
            }
            else {
                NSLog(@"error removing favorites");
            }
        }];
        self.itemRemovedView = [[UIAlertView alloc] initWithTitle:@"Favorites" message:@"Item Removed from Favorites" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]; //pop up to notify item was removed from favorites
        [self.itemRemovedView show];
    }
}

- (IBAction)swipeItem:(id)sender {
}
@end
