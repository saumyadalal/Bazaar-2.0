//
//  BZRItemViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/20/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRItemViewController.h"

@interface BZRItemViewController ()

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
          NSLog(@"fetched image");
          self.itemPicture.image = [UIImage imageWithData:data];
          PFUser* owner = [self.item objectForKey:@"owner"];
          [self loadUserInfo:owner];
        }
        else {
          NSLog(@"error fetching image");
        }
      }];
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
}

- (IBAction)addToFavorites:(id)sender {
}
@end
