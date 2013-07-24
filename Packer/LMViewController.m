//
//  LMViewController.m
//  Packer
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMViewController.h"
#import "LMItemDetailsViewController.h"
#import "LMNewItemViewController.h"
#import "Item.h"
#import "Box.h"

@interface LMViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation LMViewController

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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortByBoxName = [[NSSortDescriptor alloc] initWithKey:@"box.name" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortByBoxName]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetched results controller

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView moveSection:sectionIndex toSection:sectionIndex];
            break;
            
        default:
            break;
    }
}

/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}
 */

/*
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
}
 */

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSInteger addCell = ([tableView numberOfSections] - 1 == section) ? 1 : 0;
    return [sectionInfo numberOfObjects] + addCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BasicIdentifier = @"Basic";
    static NSString *AddIdentifier = @"Add";
    
    BOOL isLastSection = [tableView numberOfSections] - 1 == indexPath.section;
    BOOL isLastRow = [tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row;
    BOOL isAddCell = isLastSection && isLastRow;
    
    if (isAddCell)
        return [tableView dequeueReusableCellWithIdentifier:AddIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BasicIdentifier forIndexPath:indexPath];
    
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:item.name];
    [cell.detailTextLabel setText:item.box.name];
    [cell.imageView setImage:[item image]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isLastSection = [tableView numberOfSections] - 1 == indexPath.section;
    BOOL isLastRow = [tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row;
    BOOL isAddCell = isLastSection && isLastRow;
    if (isAddCell)
    {
        NSEntityDescription *itemDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        Item *item = [[Item alloc] initWithEntity:itemDescription insertIntoManagedObjectContext:self.managedObjectContext];
        [item setName:@"Zooey Deschanel"];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Details"])
    {
        LMItemDetailsViewController *detailsController = segue.destinationViewController;
        NSLog(@"prepareForSegue to %@", [detailsController class]);
    }
    else if ([segue.identifier isEqualToString:@"New"])
    {
        LMNewItemViewController *newController = segue.destinationViewController;
        NSLog(@"prepareForSegue to %@", [newController class]);
    }
}

@end
