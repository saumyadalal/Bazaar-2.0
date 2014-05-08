//
//  BZRTradeUtils.h
//  Bazaar
//
//  Created by Shikhara Nalla on 5/7/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BZRTradeUtils : NSObject

+ (void) cancelTrade:(PFObject*) trade;
+ (void) loadReturnItemImages:(NSArray*)imageViews forTrade:(PFObject *)trade;
+ (void) loadImage:(UIImageView*)imageView fromItem:(PFObject*)item;
+ (NSString *) getFirstName: (PFUser *) user;
+ (NSString *) getFirstNameOwnerFormat: (PFUser*) user;
+ (NSString *) getStatusMessage:(PFObject*)trade forUser:(PFUser*)user;
+ (NSString *) getTradeInitiatedMessage: (PFObject*) trade forUser:(PFUser*) user;
+ (BOOL) isInitiator:(PFUser*)user forTrade:(PFObject*)trade;
@end
