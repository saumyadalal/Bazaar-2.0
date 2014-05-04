//
//  BZRTradeViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRTradeViewController.h"

@interface BZRTradeViewController ()

@end

@implementation BZRTradeViewController

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
    self.numReturn.text = @"1";
    NSLog(@"%@",self.trade);
    self.itemTitle.text =[[self.trade objectForKey:@"item"] objectForKey:@"name"];
    self.itemOwner.text = [[self.trade objectForKey:@"owner"] username];
    PFFile *imageFile = [[self.trade objectForKey:@"item"] objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.itemImage.image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"error fetching image");
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperValueChanged:(id)sender {
    double value = [(UIStepper*)sender value];
    [self.numReturn setText:[NSString stringWithFormat:@"%d", (int)value]];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    self.numItems = [f numberFromString:self.numReturn.text];
}

- (IBAction)sendButton:(id)sender {
    self.trade[@"numItems"] = self.numItems;
    [self.trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Updated numItems in trade");
        }
        else {
            NSLog(@"error updating numItems in trade");
        }
    }];

}
@end
