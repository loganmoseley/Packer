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
#import "Tag.h"
#import "NSSortDescriptor+Convenience.h"

@interface LMViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation LMViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextDidSaveNotification:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setSortDescriptors:[NSSortDescriptor sortDescriptorsForKeys:@[@"box.name", @"name", @"sendingDate"] ascending:YES]];
    [fetchRequest setEntity:entity];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
        NSLog(@"Error in fetching managed objects: %@", [error description]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (BOOL)isLastRowInLastSection:(NSIndexPath *)indexPath;
{
    BOOL isLastSection = [self.tableView numberOfSections] - 1 == indexPath.section;
    BOOL isLastRow = [self.tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row;
    return isLastSection && isLastRow;
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
    return [sectionInfo numberOfObjects];
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
    
//    if ([self isLastRowInLastSection:indexPath])
//        return [tableView dequeueReusableCellWithIdentifier:AddIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BasicIdentifier forIndexPath:indexPath];
    
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:item.name];
    [cell.detailTextLabel setText:item.box.name];
    [cell.imageView setImage:[item image]];
    
    Tag *tag = [[item tags] anyObject];
    if (tag)
        [cell.detailTextLabel setText:tag.title];
    else
        [cell.detailTextLabel setText:@"missing tag"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return ![self isLastRowInLastSection:indexPath];
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) // && ![self isLastRowInLastSection:indexPath])
    {
        id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:obj];
        
        NSError *error;
        if (![self.managedObjectContext save:nil])
            NSLog(@"Error saving context after deleting: %@", [error description]);
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if ([self isLastRowInLastSection:indexPath])
//        [Item insertPlaceholderItemIntoManagedObjectContext:self.managedObjectContext];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Details"])
    {
        LMItemDetailsViewController *detailsController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Item *selectedItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
        detailsController.item = selectedItem;
    }
    else if ([segue.identifier isEqualToString:@"Add"])
    {
        LMNewItemViewController *addController = segue.destinationViewController;
        addController.persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator;
    }
}

#pragma mark - Notifications

- (void)managedObjectContextDidSaveNotification:(NSNotification *)note
{
    NSManagedObjectContext *context = [note object];
    if (self.managedObjectContext == context)
        return;
    if (self.managedObjectContext.persistentStoreCoordinator != context.persistentStoreCoordinator)
        return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
    });
}

@end
