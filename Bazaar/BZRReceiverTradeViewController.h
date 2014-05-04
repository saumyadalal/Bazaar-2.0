//
//  BZRReceiverTradeViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRReceiverTradeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *initiatorLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *numItems;
@property (strong, nonatomic) PFObject* trade;
@property (strong, nonatomic) IBOutlet UILabel *initiatorLabel2;
@end