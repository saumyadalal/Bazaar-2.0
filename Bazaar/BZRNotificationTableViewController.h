//
//  BZRNotificationTableViewController.h
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZRNotificationTableViewController : UITableViewController
- (IBAction)changeSection:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@end
