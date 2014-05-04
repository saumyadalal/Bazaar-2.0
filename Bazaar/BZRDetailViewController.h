//
//  BZRDetailViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 5/3/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRDetailViewController : UICollectionViewController
@property (strong, nonatomic) NSArray* items;
@property (strong, nonatomic) NSIndexPath* currentIndexPath;
- (IBAction)addToFavorites:(id)sender;
- (IBAction)selectItem:(id)sender;
@property (nonatomic, assign) BOOL inSelectionMode;
@end
