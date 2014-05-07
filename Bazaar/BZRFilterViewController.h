//
//  BZRFilterViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 4/5/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BZRFilterViewControllerDelegate <NSObject>

- (void)setFilter:(NSString *)filter;

@end

@interface BZRFilterViewController : UITableViewController
@property (nonatomic, strong) id<BZRFilterViewControllerDelegate> delegate;
@end



