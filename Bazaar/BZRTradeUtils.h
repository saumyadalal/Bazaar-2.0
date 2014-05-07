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
@end
