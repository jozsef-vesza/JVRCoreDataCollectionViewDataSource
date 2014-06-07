//
//  JVRCoreDataCollectionViewDataSource.h
//  JVRCoreDataCollectionViewDataSource
//
//  Created by Jozsef Vesza on 29/05/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/NSFetchedResultsController.h>

/**
 *  Helper delegate implemented by the class responsible for collection view cell configuration
 */
@protocol JVRCellConfiguratorDelegate;

/**
 *  Helper delegate implemented by the class responsible for core data operations, like item deletion
 */
@protocol JVRCoreDataHelperDelegate;

/**
 *  JVRCoreDataCollectionViewDataSource iss meant to be used by UICollectionViewController classes as data source and by NSFetchedResultsController as delegate
 */
@interface JVRCoreDataCollectionViewDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

/**
 *  Property to make sure the data shown in the collection view is up to date
 */
@property (nonatomic) BOOL paused;

/**
 *  Convenience initializer
 *
 *  @param collectionView   The collection view which will use this instance as data source
 *  @param controller       The fetched results controller which will use this instance as delegate
 *  @param cellConfigurator The helper delegate instance for customizing cells
 *  @param delegate         The helper delegate instance for core data operations (e.g.: deletion)
 *
 *  @return An initialized instance of JVRCoreDataCollectionViewDataSource
 */
+ (instancetype)dataSourceForCollectionView:(UICollectionView *)collectionView withFetchedResultsController:(NSFetchedResultsController *)controller withCellConfigurator:(id <JVRCellConfiguratorDelegate>)cellConfigurator withDelegate:(id <JVRCoreDataHelperDelegate>)delegate;

/**
 *  The object at the current index path
 *
 *  @return The selected object
 */
- (id)selectedItem;


@end
