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
  NSUInteger limit = [[trade objectForKey:@"numItems"] intValue];
  NSUInteger size = [items count];
  for (int i = 0; i < [imageViews count]; i++) {
    UIImageView* imageView = [imageViews objectAtIndex:i];
    if (i < size) {
      PFObject* item = [items objectAtIndex:i];
      [self loadImage:imageView fromItem:item];
    }
    //clear all previous images!!
    else {
      [imageView setImage:nil];
      if (i < limit) {
        [imageView setBackgroundColor:[UIColor lightGrayColor]];
      }
      else {
        [imageView setBackgroundColor:[UIColor clearColor]];
      }
    }
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

+ (NSString *) getFirstNameOwnerFormat: (PFUser*) user {
  return [NSString stringWithFormat:@"%@'s", [self getFirstName:user]];
}

+ (NSString *) getFirstName: (PFUser*) user {
  NSString* name = [user objectForKey:@"username"];
  NSArray* words = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  NSString* firstName = [words objectAtIndex:0];
  return firstName;
}






@end
