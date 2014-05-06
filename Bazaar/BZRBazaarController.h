//
//  BZRBazaarController.h
//  Bazaar
//
//  Created by Meghan Chandarana on 4/26/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRBazaarController : UICollectionViewController
@property (nonatomic, strong) NSString *currentFilter;
@property (nonatomic, strong) NSArray *items;
- (void)viewDidRequestRefresh;
- (void) viewWillAppear:(BOOL)animated;

@end
