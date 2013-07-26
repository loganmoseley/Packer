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

@interface LMNewItemViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
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
	// Do any additional setup after loading the view.
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
    [Item insertPlaceholderItemIntoManagedObjectContext:self.managedObjectContext];
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"New item save error: %@", [error description]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
