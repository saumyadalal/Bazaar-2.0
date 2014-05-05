//
//  BZRUserMarketPlaceViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 4/25/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRUserMarketPlaceViewController : UICollectionViewController
@property (nonatomic, strong) PFUser* user;
@property (nonatomic, assign) BOOL inSelectionMode;
@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, assign) NSNumber *returnLimit;
- (void) saveReturnItems:(PFObject*) trade;
@end
