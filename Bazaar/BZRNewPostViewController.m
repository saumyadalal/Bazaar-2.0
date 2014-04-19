//
//  BZRNewPostViewController.m
//  Bazaar
//
//  Created by Brian Oldak on 4/6/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRNewPostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>

@interface BZRNewPostViewController ()
@end

@implementation BZRNewPostViewController

@synthesize categories;

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
    self.categories = [NSArray arrayWithObjects: @"Books",@"Clothes/Accessories",@"Entertainment",@"Electronics", @"Food", @"Furniture", @"Household", nil];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.categoryTF.inputView = picker;
    
    [super viewDidLoad];
}

//IMAGE PICKER CONTROLLER DELEGATE ACTIONS

-(void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    // Code here to work with media
    NSLog(@"FINISHED PICKING");
    self.itemPic.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)editPicture:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage,
      (NSString *) kUTTypeMovie];
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
    // Do any additional setup after loading the view.

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.categories objectAtIndex:row];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.categories count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.categoryTF.text = [self.categories objectAtIndex:row];
}

- (IBAction)resign:(id)sender {
    [self.categoryTF resignFirstResponder];
    [self.description resignFirstResponder];
    [self.titleField resignFirstResponder];
    
}
- (void)postButton:(id)sender {
    printf("start");
    PFObject *newItem = [PFObject objectWithClassName:@"Item"];
    NSData *imageData = UIImagePNGRepresentation(self.itemPic.image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    newItem[@"itemName"] = self.titleField.text;
    newItem[@"itemDescription"] = self.description.text;
    newItem[@"itemCategory"] = self.categoryTF.text;
    newItem[@"itemImage"] = imageFile;
    [newItem saveInBackground];
    printf("end");
}
@end
