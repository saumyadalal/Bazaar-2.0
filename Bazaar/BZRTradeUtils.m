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
//        [object deleteInBackground];
          object[@"status"] = @"cancelled";
          [object saveInBackground];
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

+ (NSString *) getStatusMessage:(PFObject*)trade forUser:(PFUser*)user {
  NSString* status = [trade objectForKey:@"status"];
  if ([status isEqualToString:@"initiated"]) {
    return [self getTradeInitiatedMessage:trade forUser:user];
  }
  else if ([status isEqualToString:@"responded"]) {
    return [self getTradeRespondedMessage:trade forUser:user];
  }
  else if ([status isEqualToString:@"complete"]) {
    return [self getTradeCompleteMessage:trade forUser:user];
  }
  else if ([status isEqualToString:@"cancelled"]) {
    return [self getTradeCancelledMessage:trade forUser:user];
  }
  else if ([status isEqualToString:@"unavailable"]) {
    return [self getTradeUnavailableMessage:trade forUser:user];
  }
  return nil;
}

+ (NSString*) getTradeUnavailableMessage:(PFObject*) trade forUser:(PFUser*) user {
  return @"This item is no longer unavailable";
}

+ (NSString*) getTradeCancelledMessage:(PFObject*) trade forUser:(PFUser*) user {
  return @"This trade has been cancelled";
}

+ (NSString*) getTradeCompleteMessage:(PFObject*) trade forUser:(PFUser*) user {
  PFUser *initiator = [trade objectForKey:@"initiator"];
  NSString *message = @"%@ accepted %@ bid";
  NSString *messageText = @"";
  if ([self isInitiator:user forTrade:trade]) {
    messageText = @"Success: Trade Complete!";
  }
  else {
    //message shown to receiver
    messageText = [NSString stringWithFormat:message, [initiator objectForKey:@"username"], @"your"];
  }
  return messageText;
}


+ (NSString*) getTradeRespondedMessage:(PFObject*) trade forUser:(PFUser*) user {
  PFUser *initiator = [trade objectForKey:@"initiator"];
  PFUser *receiver = [trade objectForKey:@"owner"];
  
  NSString *message = @"%@ sent %@ a bid";
  NSString *messageText = @"";
  //receiver sends initiator a bid
  if ([self isInitiator:user forTrade:trade]) {
    //Shikha sent you a bid
    messageText = [NSString stringWithFormat:message, [self getFirstNameOwnerFormat:receiver], @"you"];
  }
  else {
    //message shown to receiver
    messageText = [NSString stringWithFormat:message, "You", [initiator objectForKey:@"username"]];
  }
  return messageText;
}

+ (NSString *) getTradeInitiatedMessage: (PFObject*) trade forUser:(PFUser*) user {
  PFUser *initiator = [trade objectForKey:@"initiator"];
  PFUser *receiver = [trade objectForKey:@"owner"];
  PFObject* item = [trade objectForKey:@"item"];
  
  NSString *message = @"%@ requested %@ %@";
  NSString *messageText = @"";
  //you initiated the trade
  if ([self isInitiator:user forTrade:trade]) {
    messageText = [NSString stringWithFormat:message, @"You",
                   [BZRTradeUtils getFirstNameOwnerFormat:receiver],
                   [item objectForKey:@"name"]];
  }
  //you received the trade
  else {
    messageText = [NSString stringWithFormat:message, [initiator objectForKey:@"username"],
                   @"your", [item objectForKey:@"name"]];
  }
  return messageText;
}

+ (BOOL) isInitiator:(PFUser*)user forTrade:(PFObject*)trade {
  PFUser *initiator = [trade objectForKey:@"initiator"];
  //[initator objectForKey: objectId does not work
  if ([[user objectId] isEqualToString:[initiator objectId]]) {
    return YES;
  }
  return NO;
}



@end
