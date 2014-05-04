//
//  BZRDetailViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 5/3/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol BZRItemDelegate <NSObject>

- (void) didSelectItem:(BOOL)selected AtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) isSelected:(NSIndexPath*) indexPath;

@end

@interface BZRDetailViewController : UICollectionViewController
@property (strong, nonatomic) NSArray* items;
@property (strong, nonatomic) NSIndexPath* currentIndexPath;
- (IBAction)addToFavorites:(id)sender;
@property (nonatomic, assign) BOOL inSelectionMode;
- (IBAction)selectItem:(id)sender;
- (IBAction)deselectItem:(id)sender;
@property (nonatomic, strong) id<BZRItemDelegate> delegate;
@end