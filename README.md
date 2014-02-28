Asymptotik Drag and Drop
=================

iOS drag and drop toolkit with support for:

* Drag Source and Drop Zones by either subclassing or wrapping UIView and subclasses
* Drag shadow generation for UIView
* UIScrollView drag target auto scrolling  
* AtkDragAndDropManager uses the delegate pattern to allow a wide varienty of drag and drop scenarios
* Accepts any continuous UIGestureRecognizer class for drag recognition
* Works with the UIPasteboard as a means of data passing for the drag and drop operation.
* Complete set of lifecycle handlers.

The current limitation to the library is that drag and drop takes place for objects that are associated with a common root view. In practice this simply limits draging across UIWindows. This library does not currently use ARC. I know. I know. But my motivation was a much bigger project that has not yet been converted.

I wrote this because I needed drag and drop support and didn't find something out there that met all my needs. Please try it out and give me your feedback. I'm interested in making this pretty robust and will accept reasonable pull requests. If you want to do big changes, I'm open, but lets talk.

Example
--------

The source base provides a few examples that use most of the features. Here is a simple example of setting up a scenario that uses most of the defaults.

Here we have a UIView drag source.

```objective-c

@interface AtkSampleOneDragSourceView<AtkDragSourceProtocol>

@end

@implementation AtkSampleOneDragSourceView

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager
{
    // This is called before any call to AtkDropZoneProtocol shouldDragStart. 
    // It's a good place to setup data for that method to examine.
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
}

@end

```

Here we have a UIView drop zone.

```objective-c

@interface AtkSampleOneDropZoneView<AtkDropZoneProtocol>

@end

@implementation AtkSampleOneDropZoneView

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    // Yes, consider me for drags. Returning true here only
    // ensures that isInterested, dragStarted, and dragEnded will
    // be called. 
    return YES;
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
    // If we return true here then dragEntered, dragExited, dragMoved and 
    // dragDropped can be called.
    // So, let's see if we are interested in what's on the pasteboard.
    // For the example this is if the pastbaord string matches
    // a string made up from the views tag property.

    BOOL ret = NO;
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *interestedInString = 
    	     [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    if([interestedInString isEqualToString:pastebaord.string])
        ret = YES;
    
    return ret;
}

@end

```

And finally, we have our UIViewController. This assumes the drag source and drop zones were layed out on the MySampleOneViewController in Interface Builder or some other means. 

```objective-c

@interface AtkSampleOneViewController : UIViewController<AtkDragAndDropManagerDelegate>

@property (nonatomic, retain) AtkDragAndDropManager *dragAndDropManager;

@end

@implementation AtkSampleOneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.navigationItem.title = @"Sample One";
    //
    // By default the AtkDragAndDropManager uses the UIApplication key windows as 
    // the rootView and a UIPanGestureRecognizer. However, these are configurable.
    // Notice there is no need to register the drag sources or drop zones. The
    // AtkDragAndDropManager will by default traverse the view hierarch and find them. 
    // This behavior is also configurable through the AtkDragAndDropManager delegate.
    //
    self.dragAndDropManager = [[[AtkDragAndDropManager alloc] init] autorelease];
    // For the AtkDragAndDropManagerDelegate methods findDragSource: finrDropZones: and
    // isDropZoneActive:recognizer:, if we do not implement them here, the 
    // relevant methods in AtkDefaultDragAndDropManagerDelegate will be called.
    // This gives us our reasonable defaults even if we want to capture drag and drop
    // events here.
    self.dragAndDropManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dragAndDropManager start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.dragAndDropManager stop];
    [super viewWillDisappear:animated];
}

/**
 * Called when a drag is dropped onto a drop zone.
 */
- (void)dragDropped:(AtkDragAndDropManager *)manager
           dropZone:(id<AtkDropZoneProtocol>)dropZone 
              point:(CGPoint)point
{
   // The drag was dropped onto an interested AtkDropZoneProtocol. Do something with it.
}

@end

```

<!---
[![Version](http://cocoapod-badges.herokuapp.com/v/AtkDragAndDrop/badge.png)](http://cocoadocs.org/docsets/AtkDragAndDrop)
[![Platform](http://cocoapod-badges.herokuapp.com/p/AtkDragAndDrop/badge.png)](http://cocoadocs.org/docsets/AtkDragAndDrop)

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

## Requirements

## Installation

AtkDragAndDrop is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "AtkDragAndDrop"

-->

## Updates
### 0.1.0 -> 0.2.0

* added drag and drop handler methods to the AtkDragAndDropManagerDelegate.
* added shouldDragStart to AtkDragSourceProtocol and AtkDropZoneProtocol. dragStarted no londer returns a boolean.
* made all protocol methods optional. this allows for maximal flexability.
* if a AtkDragAndDropManagerDelegate does not implement methods findDragSource: findDropZones: or isDropZoneActive:recognizer: we look to the AtkDefaultDragAndDropManagerDelegate.
* added dragWillStart to AtkDragSourceProtocol. this is called before dragStarted and AtkDropZoneProtocol shouldDragStart and allows us to setup data for drop zones to look at in shouldDragStart so they can determine if they want to participate as a drop zone.
* Updates to the examples and readme.

## Author

Rick Boykin, rick.boykin@gmail.com

## License

AtkDragAndDrop is available under the MIT license. See the LICENSE file for more info.

