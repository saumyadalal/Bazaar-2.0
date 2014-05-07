//
//  BZRSelectionViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRSelectionViewController.h"
#import "BZRUserMarketPlaceViewController.h"

@interface BZRSelectionViewController ()
@property (nonatomic, strong) BZRUserMarketPlaceViewController *marketPlaceView;
@end

@implementation BZRSelectionViewController

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
	// Do any additional setup after loading the view.
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
