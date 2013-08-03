//
//  LMNewItemViewController.m
//  Packer
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMNewItemViewController.h"
#import <CoreData/CoreData.h>
#import "Item.h"
#import "Box.h"
#import <QuartzCore/QuartzCore.h>
#import <BlocksKit.h>

@interface LMNewItemViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) id keyboardObserver;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takeAPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseAPictureButton;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *packingField;
@property (weak, nonatomic) IBOutlet UITextField *sendingField;
@property (weak, nonatomic) IBOutlet UITextField *tagsField;
@property (weak, nonatomic) IBOutlet UITextField *boxField;
@property (weak, nonatomic) IBOutlet UITextView  *notesView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation LMNewItemViewController

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
        
    if (!self.item)
        self.item = [Item insertBlankItemIntoManagedObjectContext:self.managedObjectContext];
    
    self.imageView.image = self.item.image;
    self.imageView.userInteractionEnabled = !!self.imageView.image;
    self.takeAPictureButton.hidden = !!self.imageView.image;
    self.chooseAPictureButton.hidden = !!self.imageView.image;
    
    self.nameField.text     = self.item.name;
    self.boxField.text      = self.item.box.name;
    self.notesView.text     = self.item.notes;
    
    self.packingField.text  = [self stringForDate:self.item.packingDate inCalendar:nil];
    self.sendingField.text  = [self stringForDate:self.item.sendingDate inCalendar:nil];
    
    NSArray *titles         = [[self.item.tags allObjects] valueForKey:@"title"];
    self.tagsField.text     = titles.count ? [titles componentsJoinedByString:@", "] : nil;
    
    // notifications
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    id obs = [nc addObserverForName:UIKeyboardDidChangeFrameNotification object:nil queue:nil
                         usingBlock:^(NSNotification *note) {
                             NSValue *nsKeyboardFrame = [note userInfo][UIKeyboardFrameEndUserInfoKey];
                             CGRect keyboardFrame = [nsKeyboardFrame CGRectValue];
                             [self setContentInsetsBottom:CGRectGetHeight(keyboardFrame)];
                         }];
    self.keyboardObserver = obs;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 4;
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL hasLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    BOOL hasSavedAlbums = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    if (!hasCamera)
        self.takeAPictureButton.enabled = NO;
    if (!hasLibrary || !hasSavedAlbums)
        self.chooseAPictureButton.enabled = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardObserver];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.notesView.frame) + 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == persistentStoreCoordinator)
        return;
    _persistentStoreCoordinator = persistentStoreCoordinator;
    
//    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
}

- (IBAction)done:(id)sender
{
    NSString *trimmedName    = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//  NSString *trimmedPacking = [self.packingField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedSending = [self.sendingField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedBoxName = [self.boxField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedInfo    = [self.notesView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *fatTags = [self.tagsField.text componentsSeparatedByString:@","];
    NSArray *trimmedTags = [fatTags map:^NSString*(NSString *tag) {
        return [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }];
        
    self.item.name        = trimmedName;
    self.item.sendingDate = [NSDate dateWithTimeIntervalSinceNow:([trimmedSending doubleValue] * 60 * 60 * 24)];
    self.item.box         = [Box boxWithName:(trimmedBoxName?:@"") inManagedObjectContext:self.managedObjectContext];
    self.item.notes       = trimmedInfo;
    
    self.item.image = self.imageView.image;
    
    [self.item removeTags:self.item.tags];
    [self.item addTagsByTitles:[NSSet setWithArray:trimmedTags]];
    
    /* save context */
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"New item save error: %@", [error description]);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Editing

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    if ([textField isEqual:self.sendingField])
    {
        [self.view endEditing:NO];
        [self.datePicker setHidden:NO];
        [self.sendingField setHighlighted:YES];
        [self setContentInsetsBottom:CGRectGetHeight(self.datePicker.bounds)];
    }
    else
    {
        [self.view endEditing:NO];
        [self.datePicker setHidden:YES];
        [self.sendingField setHighlighted:NO];
        [self setContentInsetsBottom:0];
    }
    
    return !([textField isEqual:self.sendingField] || [textField isEqual:self.packingField]);
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)picker
{
    [self.sendingField setText:[self stringForDate:picker.date inCalendar:picker.calendar]];
}

- (void)setContentInsetsBottom:(CGFloat)bottom
{
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    UIEdgeInsets scrollInset = self.scrollView.scrollIndicatorInsets;
    contentInset.bottom = bottom;
    scrollInset.bottom = bottom;
    
    self.scrollView.contentInset = contentInset;
    self.scrollView.scrollIndicatorInsets = scrollInset;
}

#pragma mark - Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image)
    {
        self.imageView.image = image;
        self.takeAPictureButton.hidden = YES;
        self.chooseAPictureButton.hidden = YES;
        self.imageView.userInteractionEnabled = YES;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers

- (IBAction)takeAPicture:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [UIAlertView showAlertViewWithTitle:nil message:@"The camera is unavailable. You may have to allow access in your Settings app." cancelButtonTitle:@"Okay" otherButtonTitles:nil handler:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)chooseAPicture:(id)sender
{
    BOOL hasLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    BOOL hasSavedAlbums = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    if (!hasLibrary && !hasSavedAlbums) {
        [UIAlertView showAlertViewWithTitle:nil message:@"Photos are unavailable. You may have to allow access in your Settings app." cancelButtonTitle:@"Okay" otherButtonTitles:nil handler:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType: hasLibrary ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)imageViewTapped:(id)sender
{
    // BlocksKit+AlertView puts the cancel button on the wrong side
    [UIAlertView showAlertViewWithTitle:@"Clear Image?" message:@"You can set a new image." cancelButtonTitle:@"Discard" otherButtonTitles:@[@"Keep"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            self.imageView.image = nil;
            self.takeAPictureButton.hidden = NO;
            self.chooseAPictureButton.hidden = NO;
            self.imageView.userInteractionEnabled = NO;
        }
    }];
}

- (NSString *)stringForDate:(NSDate *)date inCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setCalendar:calendar];
    return [formatter stringFromDate:date];
}

@end
