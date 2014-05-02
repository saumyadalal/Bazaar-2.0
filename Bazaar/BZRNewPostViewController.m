//
//  BZRNewPostViewController.m
//  Bazaar
//
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRNewPostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BZRNewPostViewController ()
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIAlertView *imageSavedView;
@end

@implementation BZRNewPostViewController

@synthesize categories;

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.categories = [NSArray arrayWithObjects: @"Books", @"Clothes", @"Accessories", @"Entertainment", @"Electronics", @"Food", @"Furniture", @"Household", nil];
    //set category input as picker
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.category.inputView = picker;
    //configure bar button action
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(clearPressed:);
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(postPressed:);
    self.imageSavedView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Image Uploaded Successfully" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.description.text isEqualToString:@"description"]) {
        self.description.text = @"";
        self.description.textColor = [UIColor colorWithRed:56 green:50 blue:53 alpha:1]; //color of description field font when user begins typing
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.description.text isEqualToString:@""]) {
        self.description.text = @"description";
        self.description.textColor = [UIColor lightGrayColor]; //color of description field text when user has not entered any text yet
    }
    [textView resignFirstResponder];
}

- (void)clearPressed:(id)sender{
  [self clearFields];
}

- (void)clearFields {
  self.itemName.text = @"Name";
  self.description.text = @"Description";
  self.category.text = @"Select Category";
  self.imageView.image = nil;
}

- (void)postPressed:(id)sender {
  PFObject *newItem = [PFObject objectWithClassName:@"Item"];
  NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
  PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
  newItem[@"name"] = self.itemName.text;
  newItem[@"description"] = self.description.text;
  newItem[@"category"] = self.category.text;
  newItem[@"imageFile"] = imageFile;
  newItem[@"owner"] = [PFUser currentUser];
  [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
        [self.imageSavedView show];
      NSLog(@"saved new item");
      [self clearFields];
    }
    else {
      NSLog(@"error saving item");
    }
  }];
}


//image picker delegate methods

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = info[UIImagePickerControllerEditedImage];
  self.imageView.image = image;
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editPicture:(id)sender {
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage,
      (NSString *) kUTTypeMovie];
    [self presentViewController:imagePicker animated:YES completion:nil];
    // Do any additional setup after loading the view.

}

//category picker delegate methods

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
    self.category.text = [self.categories objectAtIndex:row];
}

- (IBAction)resign:(id)sender {
    [self.category resignFirstResponder];
    [self.description resignFirstResponder];
    [self.itemName resignFirstResponder];
}


@end
