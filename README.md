### JVRCoreDataCollectionViewDataSource

`JVRCoreDataCollectionViewDataSource` aims to make your collection view controllers lighter by encapsulating logic from `NSFetchedResultsControllerDelegate` and `UICollectionViewDataSource`.

#### Usage

Using `JVRCoreDataCollectionViewDataSource` is really simple, you only need a few lines in your view collection controller class.

```objc

@interface MyViewController()
@property (nonatomic, strong) JVRCoreDataCollectionViewDataSource *dataSource;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [JVRCoreDataCollectionViewDataSource dataSourceForCollectionView:self.collectionView withFetchedResultsController:self.model withCellConfigurator:[[MyCellConfigurator alloc] init]];
    }
    
@end
```
As you might have noticed, you will also need a cell configurator class (`MyCellConfigurator` in this example), which has to  implement the methods of the `JVRCellConfiguratorDelegate` protocol. See the [project page](https://github.com/jozsef-vesza/JVRCellConfiguratorDelegate) for details about how to do this.

#### Installation

[CocoaPods](http://cocoapods.org) is a great way to add third party libraries to your project so I recommend using it for `JVRCoreDataCollectionViewDataSource` as well. Add the following line to your Podfile:

```ruby
  pod 'JVRCoreDataCollectionViewDataSource'
```

This will also add the previously mentioned `JVRCellConfiguratorDelegate` as dependency.
