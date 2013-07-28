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
#import "NSCollections+Map.h"

@interface LMNewItemViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Item *item;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *packingField;
@property (weak, nonatomic) IBOutlet UITextField *sendingField;
@property (weak, nonatomic) IBOutlet UITextField *tagsField;
@property (weak, nonatomic) IBOutlet UITextField *boxField;
@property (weak, nonatomic) IBOutlet UITextView *infoInputView;
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
    
    self.item = [Item insertBlankItemIntoManagedObjectContext:self.managedObjectContext];
    
    self.nameField.text     = self.item.name;
    self.boxField.text      = self.item.box.name;
    self.infoInputView.text = self.item.info;
    
    NSTimeInterval sendingDateFromNow = [self.item.sendingDate timeIntervalSinceNow]; // seconds
    NSString *sendingStr    = [NSString stringWithFormat:@"%f", (sendingDateFromNow / 60 / 60 / 24)];
    self.sendingField.text  = self.item.sendingDate ? sendingStr : nil;
    self.packingField.text  = [self.item.packingDate description];
    
    NSArray *titles         = [[self.item.tags allObjects] valueForKey:@"title"];
    self.tagsField.text     = titles.count ? [titles componentsJoinedByString:@", "] : nil;
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
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
}

- (IBAction)done:(id)sender
{
    NSString *trimmedName    = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//  NSString *trimmedPacking = [self.packingField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedSending = [self.sendingField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedBoxName = [self.boxField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedInfo    = [self.infoInputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *fatTags = [self.tagsField.text componentsSeparatedByString:@","];
    NSArray *trimmedTags = [fatTags map:^NSString*(NSString *tag) {
        return [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }];
        
    self.item.name        = trimmedName;
    self.item.sendingDate = [NSDate dateWithTimeIntervalSinceNow:([trimmedSending doubleValue] * 60 * 60 * 24)];
    self.item.box         = [Box boxWithName:(trimmedBoxName?:@"") inManagedObjectContext:self.managedObjectContext];
    self.item.info        = trimmedInfo;
    
    [self.item removeTags:self.item.tags];
    [self.item addTagsByTitles:[NSSet setWithArray:trimmedTags]];
    
    /* save context */
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"New item save error: %@", [error description]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Editing

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

@end
