//
//  BZRItemViewController.h
//  Bazaar
//
//  Created by Saumya Dalal on 4/20/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface BZRItemViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;

@property (strong, nonatomic) IBOutlet UIImageView *itemPicture;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (strong, nonatomic) PFObject* item;
@property (nonatomic) int alreadyFav;
@property (strong, nonatomic) IBOutlet UILabel *unfavoriteLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UILabel *cannotFavoriteLabel;

- (IBAction)initiateTrade:(id)sender;
- (IBAction)addToFavorites:(id)sender;
- (IBAction)swipeItem:(id)sender;

@end
