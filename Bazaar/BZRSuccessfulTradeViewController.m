//
//  BZRSuccessfulTradeViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 5/7/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRSuccessfulTradeViewController.h"
#import "BZRTradeUtils.h"

@interface BZRSuccessfulTradeViewController ()
@property (nonatomic, strong) NSArray* itemImageViews;

@end

@implementation BZRSuccessfulTradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser* owner = [self.trade objectForKey:@"owner"];
    PFUser *initiator = [self.trade objectForKey:@"initiator"];
    self.ownerLabel.text = [BZRTradeUtils getFirstName:owner];
    self.initiatorLabel.text = [BZRTradeUtils getFirstName:initiator];
    NSNumber *numItems = [self.trade objectForKey:@"numItems"];
    if([numItems isEqualToNumber:@1])
        self.itemImageViews = @[self.itemImage2];
    else if ([numItems isEqualToNumber:@2])
        self.itemImageViews = @[self.itemImage2_1, self.itemImage2_2];
    else if ([numItems isEqualToNumber:@3])
        self.itemImageViews = @[self.itemImage1, self.itemImage2, self.itemImage3];
    [BZRTradeUtils loadReturnItemImages:self.itemImageViews forTrade:self.trade];
    [BZRTradeUtils loadImage:self.keyItemImage fromItem:[self.trade objectForKey:@"item"]];
    self.ownerLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:23];
    self.initiatorLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:23];
    self.successLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:35];
    self.tradedLabel.font = [UIFont fontWithName:@"Gotham-Book" size:20];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
