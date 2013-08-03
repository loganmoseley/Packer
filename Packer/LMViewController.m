//
//  LMViewController.m
//  Packer
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMViewController.h"
#import "LMItemViewController.h"
#import "Item.h"
#import "Box.h"
#import "Tag.h"
#import "NSSortDescriptor+Convenience.h"


@interface LMSectioningDescription : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sectionNameKeyPath;
@property (nonatomic, copy) NSArray *sortDescriptors;
+ (instancetype)sectioningWithTitle:(NSString *)title sectionNameKeyPath:(NSString *)keyPath sortDescriptors:(NSArray *)descriptors;
@end

@implementation LMSectioningDescription
+ (instancetype)sectioningWithTitle:(NSString *)title sectionNameKeyPath:(NSString *)keyPath sortDescriptors:(NSArray *)descriptors
{
    LMSectioningDescription *sd = [LMSectioningDescription new];
    sd.title = title; sd.sortDescriptors = descriptors; sd.sectionNameKeyPath = keyPath;
    return sd;
}
@end


@interface LMViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSEnumerator *sortingByTitleEnumerator;
@property (nonatomic, strong) NSArray *sortingByTitle; // sort by Box name, name (initial), and sending date
@property (nonatomic, weak) UILabel *navTitle; // text for titles from sortingByTitle
@end

@implementation LMViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    
    self.sortingByTitle = @[ [LMSectioningDescription sectioningWithTitle:@"By Box"
                                                       sectionNameKeyPath:@"box.name"
                                                          sortDescriptors:[NSSortDescriptor sortDescriptorsForKeys:@[@"box.name", @"name", @"sendingDate", @"packingDate"]]],
                             [LMSectioningDescription sectioningWithTitle:@"By Name"
                                                       sectionNameKeyPath:@"nameFirstLetter"
                                                          sortDescriptors:[NSSortDescriptor sortDescriptorsForKeys:@[@"nameFirstLetter", @"name", @"sendingDate", @"box.name", @"packingDate"]]],
                            ];
    self.sortingByTitleEnumerator = [self.sortingByTitle objectEnumerator];
    
    self.title = @"Cancel";
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setShadowColor:[UIColor darkGrayColor]];
    [title setShadowOffset:CGSizeMake(0, -1)];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont systemFontOfSize:22]];
    self.navTitle = title;
    self.navigationItem.titleView = title;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped:)];
    [title addGestureRecognizer:tap];
    [title setUserInteractionEnabled:YES];
    
    // sectioning description
    
    LMSectioningDescription *description = [self.sortingByTitleEnumerator nextObject];
    if (!description) description = [(self.sortingByTitleEnumerator = [self.sortingByTitle objectEnumerator]) nextObject];
    
    [title setText:description.title];
    self.fetchedResultsController = [self frcWithSortDescriptors:description.sortDescriptors sectionNameKeyPath:description.sectionNameKeyPath];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
        NSLog(@"Error in fetching managed objects: %@", [error description]);
}

- (void)titleTapped:(UITapGestureRecognizer *)recognizer
{
    LMSectioningDescription *description = [self.sortingByTitleEnumerator nextObject];
    if (!description) description = [(self.sortingByTitleEnumerator = [self.sortingByTitle objectEnumerator]) nextObject];
    
    self.navTitle.text = description.title;
    self.fetchedResultsController = [self frcWithSortDescriptors:description.sortDescriptors sectionNameKeyPath:description.sectionNameKeyPath];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
        NSLog(@"Error in fetching managed objects: %@", [error description]);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

#pragma mark - Helpers

- (BOOL)isLastRowInLastSection:(NSIndexPath *)indexPath;
{
    BOOL isLastSection = [self.tableView numberOfSections] - 1 == indexPath.section;
    BOOL isLastRow = [self.tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row;
    return isLastSection && isLastRow;
}

- (NSFetchedResultsController *)frcWithSortDescriptors:(NSArray *)sortDescriptors sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    NSParameterAssert(sortDescriptors.count > 0);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    NSParameterAssert(fetchRequest.entity);
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:sectionNameKeyPath
                                                          cacheName:nil];
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BasicIdentifier forIndexPath:indexPath];
    
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:item.name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:cell.textLabel.font.pointSize]];
    [cell.imageView setImage:[item image]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:obj];
        
        NSError *error;
        if (![self.managedObjectContext save:nil])
            NSLog(@"Error saving context after deleting: %@", [error description]);
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add"])
    {
        LMItemViewController *addController = segue.destinationViewController;
        addController.item = [Item insertBlankItemIntoManagedObjectContext:self.managedObjectContext];
        addController.managedObjectContext = self.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"Edit"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        LMItemViewController *viewController = segue.destinationViewController;
        viewController.item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        viewController.managedObjectContext = self.managedObjectContext;
    }
}

@end
