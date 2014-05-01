//
//  BZRFavoritesTableViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRFavoritesTableViewController.h"
#import "BZRItemViewController.h"

@interface BZRFavoritesTableViewController ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation BZRFavoritesTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser *user = [PFUser currentUser]; //get current user info
    self.favoriteArray = user[@"favorites"]; //get current user's favorite's info
    NSLog(@"favorite array: %@",self.favoriteArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // NSUInteger count = self.objectIdArray.count;
    return [self.favoriteArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(self.favoriteArray){
        for (PFObject *item in self.favoriteArray){
            NSString *objectID = [item objectId];
            //            NSLog(@"objectID: %@",objectID);
            PFQuery *query = [PFQuery queryWithClassName:@"Item"];
            [query getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
                if (!error) {
                    
                    PFFile *imageFile = [object objectForKey:@"imageFile"];
                    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            

                            NSString *name = object[@"name"];
                            
                            UILabel *label = (UILabel *)[cell.contentView viewWithTag:104];
                            [label setText:[NSString stringWithFormat:@"%@", name]];
                            
                            UIImageView *imageCell = (UIImageView *)[cell.contentView viewWithTag:103];
                            imageCell.image = [UIImage imageWithData:data];
                        }
                        else {
                            NSLog(@"error fetching image");
                        }
                    }];
                }
                else {
                    NSLog(@"error fetching data");
                }
            }];
        }
    }
    // Configure the cell...
    
    return cell;
}

//instantiate detail view controller here since the segue in storyboard doesn't seem to work
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BZRItemViewController* detailView = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil]
//                                         instantiateViewControllerWithIdentifier:@"itemViewController"];
//    detailView.item = [self.favoriteArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detailView animated:YES];
//}


@end
