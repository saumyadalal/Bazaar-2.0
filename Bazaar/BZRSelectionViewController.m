//
//  BZRSelectionViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRSelectionViewController.h"
#import "BZRUserMarketPlaceViewController.h"
#import "BZRDesignUtils.h"

@interface BZRSelectionViewController ()
@property (nonatomic, strong) BZRUserMarketPlaceViewController *marketPlaceView;
@end

@implementation BZRSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.header.backgroundColor = [BZRDesignUtils profileBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSInteger limit = [[self.trade objectForKey:@"numItems"] intValue];
  NSInteger currentSize = [[self.trade objectForKey:@"returnItems"] count];
  NSString* baseStr = @"You can pick %d more %@";
  NSInteger diff = limit - currentSize;
  NSString* itemStr = @"items";
  if (diff == 1) {
    itemStr = @"item";
  }
  NSString* message = [NSString stringWithFormat:baseStr, diff, itemStr];
  [self.itemSelectionMessage setText:message];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(103, 103);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(3,3,3,3);
    
    return insets;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"receiverEmbedMarketPlace"]) {
    self.marketPlaceView = segue.destinationViewController;
    self.marketPlaceView.user = self.user;
    self.marketPlaceView.inSelectionMode = YES;
    self.marketPlaceView.selectedItems = [self.trade objectForKey:@"returnItems"];
    self.marketPlaceView.returnLimit = [self.trade objectForKey:@"numItems"];
  }
}

- (IBAction)donePressed:(id)sender {
  [self.marketPlaceView saveReturnItems:self.trade];
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}





@end
