//
//  BZRTradeViewController.h
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRTradeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemOwner;
@property (strong, nonatomic) IBOutlet UILabel *numReturn;
- (IBAction)stepperValueChanged:(id)sender;
- (IBAction)sendButton:(id)sender;
@property (strong, nonatomic) PFObject *trade;
@end
