//
//  BZRNewPostViewController.m
//  Bazaar
//
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRNewPostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

@interface BZRNewPostViewController () <UITextViewDelegate>
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIAlertView *imageSavedView;
@property (strong, nonatomic) UIAlertView *incompleteView;
@property (nonatomic) BOOL imagePicked;
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
    
  [[UILabel appearance] setFont:[UIFont fontWithName:@"Gotham-Book" size:14.0]]; //font of labels
  [self.postButton setTitleTextAttributes:
  [NSDictionary dictionaryWithObjectsAndKeys:
  [UIFont fontWithName:@"Gotham-Medium" size:17], NSFontAttributeName,nil] forState:UIControlStateNormal]; //font of post button
  [self.clearButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Gotham-Medium" size:17], NSFontAttributeName,nil] forState:UIControlStateNormal]; //font of clear button
  [self.description setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
    
    self.imagePicked = NO;
    self.categories = [NSArray arrayWithObjects: @"Books", @"Clothes & Shoes", @"Accessories", @"Entertainment", @"Electronics", @"Food", @"Furniture", @"Household", @"Other", nil];
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
    self.incompleteView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please complete all fields!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //change border color of text boxes
    self.itemName.layer.cornerRadius=6.0f;
    self.itemName.layer.masksToBounds=YES;
    self.itemName.layer.borderColor=[[UIColor grayColor]CGColor];
    self.itemName.layer.borderWidth= 1.0f;
    self.category.layer.cornerRadius=6.0f;
    self.category.layer.masksToBounds=YES;
    self.category.layer.borderColor=[[UIColor grayColor]CGColor];
    self.category.layer.borderWidth= 1.0f;
    self.description.layer.cornerRadius=6.0f;
    self.description.layer.masksToBounds=YES;
    self.description.layer.borderColor=[[UIColor grayColor]CGColor];
    self.description.layer.borderWidth= 1.0f;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    //or this can also be set in the storyboard.
    self.description.delegate = self;
}


//accessing self.description.text = @"" does not work
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  self.description.textColor = [UIColor blackColor];
  if ([self.description.text isEqual:@"Description"]) {
      self.description.text = @"";
  }
  return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text length] == 0) {
    textView.text = @"Description";
    textView.textColor = [UIColor lightGrayColor];
    //color of description field text when user has not entered any text yet
  }
  [textView resignFirstResponder];
}

- (void)clearPressed:(id)sender{
  [self clearFields];
}

- (void)clearFields {
  self.itemName.text = @"";
  self.description.text = @"Description";
  self.description.textColor = [UIColor lightGrayColor];
  self.category.text = @"";
  self.imageView.image = nil;
  self.addObject.hidden = NO;
  self.navigationItem.leftBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)postPressed:(id)sender {
    if([self.itemName.text isEqual:@""] || [self.description.text isEqual: @"Description"] || [self.category.text  isEqual: @""] || self.imageView.image == nil || [self.description.text  isEqual: @""]){
        [self.incompleteView show];
    }
    else {
        PFObject *newItem = [PFObject objectWithClassName:@"Item"];
        NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        newItem[@"name"] = self.itemName.text;
        newItem[@"description"] = self.description.text;
        newItem[@"category"] = self.category.text;
        newItem[@"imageFile"] = imageFile;
        newItem[@"owner"] = [PFUser currentUser];
        newItem[@"status"] = @"available";
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
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


//image picker delegate methods

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = info[UIImagePickerControllerEditedImage];
  self.imageView.image = image;
  [self dismissViewControllerAnimated:YES completion:nil];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  self.imagePicked = YES;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [self dismissViewControllerAnimated:YES completion:nil];
    if (self.imagePicked == NO) {
        self.addObject.hidden = NO;
    }
}


- (IBAction)editPicture:(id)sender {
    self.addObject.hidden = YES;
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
    self.imagePicked = NO;
}


- (IBAction)titleField:(id)sender {
}

- (IBAction)categoryField:(id)sender {
}
@end
