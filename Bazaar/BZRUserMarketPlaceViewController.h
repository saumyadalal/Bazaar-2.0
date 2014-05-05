//
//  BZRUserMarketPlaceViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 4/25/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol BZRUserMarketPlaceDelegate <NSObject>

- (void)updateNumItems:(NSUInteger)itemCount;

@end


@interface BZRUserMarketPlaceViewController : UICollectionViewController
@property (nonatomic, strong) PFUser* user;
@property (nonatomic, assign) BOOL inSelectionMode;
@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, assign) NSNumber *returnLimit;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) id<BZRUserMarketPlaceDelegate> delegate;
- (void) saveReturnItems:(PFObject*) trade;
@end
