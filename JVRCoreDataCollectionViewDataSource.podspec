Pod::Spec.new do |s|
 s.name         = "JVRCoreDataCollectionViewDataSource"
  s.version      = "1.0.2"
  s.summary      = "A reusable class that combines UICollectionViewDataSource and NSFetchedResultsControllerDelegate."
  s.homepage     = "https://github.com/jozsef-vesza/JVRCoreDataCollectionViewDataSource"
  s.license      = "MIT"
  s.author             = { "József Vesza" => "jozsef.vesza@outlook.com" }
  s.social_media_url   = "http://twitter.com/j_vesza"
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/jozsef-vesza/JVRCoreDataCollectionViewDataSource.git", :tag => s.version }
  s.source_files  = "*.{h,m}"
  s.public_header_files = "*.h"
  s.framework  = "CoreData"
  s.requires_arc = true
  s.dependency 'JVRCellConfiguratorDelegate'
  s.dependency 'JVRCoreDataHelperDelegate'
end
