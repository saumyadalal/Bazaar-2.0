//
//  BZRDesignUtils.h
//  Bazaar
//
//  Created by Shikhara Nalla on 5/8/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZRDesignUtils : NSObject
+ (UIColor*) purpleColor;
+ (UIColor*) greyOverlayColor;
+ (UIColor*) offWhiteColor;
+ (UIColor*) buttonDisabledColor;
+ (UIColor*) newNotificationColor;
+ (UIColor*) dateTimeColor;
+ (void) showSeenStatus:(BOOL)isNew forCell:(UITableViewCell*) cell;
@end
