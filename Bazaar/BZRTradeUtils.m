//
//  BZRTradeUtils.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/7/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRTradeUtils.h"

@implementation BZRTradeUtils

+ (void) cancelTrade:(PFObject *)trade {
  NSString *objectId = [trade objectId];
  PFQuery *query = [PFQuery queryWithClassName:@"Trade"];
  [query whereKey:@"objectId" equalTo:objectId];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      NSLog(@"canceled trade");
      // Do something with the found objects
      for (PFObject *object in objects) {
        [object deleteInBackground];
      }
    } else {
      // Log details of the failure
      NSLog(@"error canceling trade");
    }
  }];
}

+ (void) loadReturnItemImages:(NSArray*)imageViews forTrade:(PFObject *)trade {
  NSArray *items = [trade objectForKey:@"returnItems"];
  for (int i = 0; i < [items count]; i++) {
    PFObject* item = [items objectAtIndex:i];
    [self loadImage:[imageViews objectAtIndex:i] fromItem:item];
  }
}

+ (void) loadImage:(UIImageView*)imageView fromItem:(PFObject*)item {
  [item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
      PFFile *imageFile = [item objectForKey:@"imageFile"];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
          [imageView setImage:[UIImage imageWithData:data]];
        }
        else {
          NSLog(@"error fetching image");
        }
      }];
    }
    else {
      NSLog(@"error fetching item data");
    }
  }];
}







@end
