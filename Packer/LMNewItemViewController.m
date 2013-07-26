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

- (IBAction)done:(id)sender
{
    NSEntityDescription *itemDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    Item *item = [[Item alloc] initWithEntity:itemDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [item setName:@"Zooey Deschanel"];
    [item setImage:[UIImage imageNamed:@"zooey and kitten.jpg"]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
