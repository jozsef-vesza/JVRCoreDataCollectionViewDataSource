//
//  JVRCoreDataCollectionViewDataSource.m
//  JVRCoreDataCollectionViewDataSource
//
//  Created by Jozsef Vesza on 29/05/14.
//
//

#import "JVRCoreDataCollectionViewDataSource.h"
#import "JVRCellConfiguratorDelegate.h"
#import "JVRCoreDataHelperDelegate.h"

@interface JVRCoreDataCollectionViewDataSource ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) id<JVRCellConfiguratorDelegate> cellConfigurator;
@property (nonatomic, strong) id<JVRCoreDataHelperDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *objectChanges;
@property (nonatomic, strong) NSMutableArray *sectionChanges;

@end

@implementation JVRCoreDataCollectionViewDataSource

+ (instancetype)dataSourceForCollectionView:(UICollectionView *)collectionView withFetchedResultsController:(NSFetchedResultsController *)controller withCellConfigurator:(id <JVRCellConfiguratorDelegate>)cellConfigurator withDelegate:(id <JVRCoreDataHelperDelegate>)delegate {
    return [[self alloc] initWithCollectionView:collectionView withFetchedResultsController:controller withCellConfigurator:cellConfigurator withDelegate:delegate];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView withFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController withCellConfigurator:(id <JVRCellConfiguratorDelegate>)cellConfigurator withDelegate:(id <JVRCoreDataHelperDelegate>)delegate {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        _collectionView.dataSource = self;
        _fetchedResultsController = fetchedResultsController;
        _fetchedResultsController.delegate = self;
        _cellConfigurator = cellConfigurator;
        _delegate = delegate;
        NSError *error;
        [_fetchedResultsController performFetch:&error];
    }
    return self;
}

- (NSMutableArray *)objectChanges {
    if (!_objectChanges) {
        _objectChanges = [NSMutableArray array];
    }
    
    return _objectChanges;
}

- (NSMutableArray *)sectionChanges {
    if (!_sectionChanges) {
        _sectionChanges = [NSMutableArray array];
    }
    
    return _sectionChanges;
}

- (id)selectedItem {
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
    return indexPath ? [self.fetchedResultsController objectAtIndexPath:indexPath] : nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectionIndex {
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id objectAtIndex = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *reuseIdentifierForCell = [self.cellConfigurator fetchReuseIdentifierForObject:objectAtIndex];
    id cellAtIndex = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierForCell forIndexPath:indexPath];
    cellAtIndex = [self.cellConfigurator configureCell:cellAtIndex withObject:objectAtIndex];
    
    return cellAtIndex;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
    }
    
    [self.sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    
    [self.objectChanges addObject:change];
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    __weak typeof(self) weakSelf = self;
    if ([self.sectionChanges count] > 0) {
        [weakSelf.collectionView performBatchUpdates:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.sectionChanges enumerateObjectsUsingBlock:^(NSDictionary *change, NSUInteger idx, BOOL *stop) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [strongSelf.collectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [strongSelf.collectionView deleteItemsAtIndexPaths:@[obj]];
                        case NSFetchedResultsChangeUpdate:
                            [strongSelf.collectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [strongSelf.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }];
        } completion:nil];
    }
    
    if ([self.objectChanges count] > 0 && [self.sectionChanges count] == 0) {
        [weakSelf.collectionView performBatchUpdates:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.objectChanges enumerateObjectsUsingBlock:^(NSDictionary *change, NSUInteger idx, BOOL *stop) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [strongSelf.collectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [strongSelf.collectionView deleteItemsAtIndexPaths:@[obj]];
                        case NSFetchedResultsChangeUpdate:
                            [strongSelf.collectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [strongSelf.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }];
        } completion:nil];
    }
    
    [self.objectChanges removeAllObjects];
    [self.sectionChanges removeAllObjects];
}

- (void)setPaused:(BOOL)paused {
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        [self.collectionView reloadData];
    }
}

@end
