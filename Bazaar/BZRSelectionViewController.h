//
//  BZRSelectionViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRSelectionViewController : UIViewController
- (IBAction)donePressed:(id)sender;
@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) PFObject* trade;
- (IBAction)cancelPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *itemSelectionMessage;
@end
