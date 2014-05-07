//
//  BZRInitiatorTradeViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRInitiatorTradeViewController.h"
#import "BZRTradeUtils.h"

@interface BZRInitiatorTradeViewController ()
@property (nonatomic, strong) NSArray* itemImageViews;
@end

@implementation BZRInitiatorTradeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemImageViews = @[self.itemImage1, self.itemImage2, self.itemImage3];
    //load item image the first time
    [BZRTradeUtils loadImage:self.itemImage fromItem:[self.trade objectForKey:@"item"]];
    [self setFont];
}


- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateContent];
}


- (void) updateContent {
  [self.tradeLabel setText:self.tradeMessage];
  //load return item images
  if ([self.trade[@"status"] isEqualToString:@"responded"]) {
      [BZRTradeUtils loadReturnItemImages:self.itemImageViews forTrade:self.trade];
  }
  else {
    //display no images yet.
  }
}

- (void) setFont {
  self.cancelTradeButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  self.acceptButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTrade:(id)sender {
  [BZRTradeUtils cancelTrade:self.trade];
}
@end
