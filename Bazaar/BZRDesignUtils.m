//
//  BZRDesignUtils.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/8/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRDesignUtils.h"

@implementation BZRDesignUtils
+ (UIColor*) purpleColor {
  return [UIColor colorWithRed:79/255.0 green:44/255.0 blue:112/255.0 alpha:1];
}

+ (UIColor*) offWhiteColor {
  return [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1];
}

+ (UIColor*) greyOverlayColor {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
}

+ (UIColor*) buttonDisabledColor {
  return [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
}

+ (UIColor*) newNotificationColor {
  return [UIColor colorWithRed:79/255.0 green:44/255.0 blue:112/255.0 alpha:0.05];
}

+ (void) showSeenStatus:(BOOL)seen forCell:(UITableViewCell*) cell {
  if (!seen) {
    [cell setBackgroundColor:[self newNotificationColor]];
  }
  else {
    [cell setBackgroundColor:nil];
  }
}

+ (UIColor*) dateTimeColor {
  return [UIColor darkGrayColor];
}

+ (UIColor*) placeHolderColor {
  return [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
}

+ (UIColor*) placeHolderLightGrey {
  return [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
}


+ (UIColor*) profileBackgroundColor {
  return [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:0.5];

}



@end
