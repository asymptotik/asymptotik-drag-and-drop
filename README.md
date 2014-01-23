Asymptotik Drag and Drop
=================

iOS drag and drop toolkit with support for:

* Drag Source and Drop Zones by either subclassing or wrapping UIView and subclasses
* Drag shadow generation for UIView
* UIScrollView drag target auto scrolling  
* AtkDragAndDropManager uses the delegate pattern to allow a wide varienty of drag and drop scenarios
* Accepts any continuous UIGestureRecognizer class for drag recognition
* Works with the UIPasteboard as a means of data passing for the drag and drop operation.

The current limitation to the library is that drag and drop takes place for objects that are associated with a common root view. In practice this simply limits draging across UIWindows. This library does not currently use ARC. I know. I know. But my motivation was a much bigger project that has not yet been converted.

I wrote this because I needed drag and drop support and didn't find something out there that met all my needs. Please try it out and give me your feedback. I'm interested in making this pretty robust and will accept reasonable pull requests. If you want to do big changes, I'm open, but lets talk.

Example
--------

The source base provides a few examples that use most of the features. Here is a simple example of setting up a scenario that uses most of the defaults.

Here we have a UIView drag source.

```objective-c

@interface AtkSampleOneDragSourceView<HtDragSourceProtocol>

@end

@implementation AtkSampleOneDragSourceView

- (BOOL)dragStarted:(AtkDragAndDropManager *)manager
{
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    return YES;
}

@end

```

Here we have a UIView drop zone.

```objective-c

@interface AtkSampleOneDropZoneView<AtkDropZoneProtocol>

@end

@implementation AtkSampleOneDropZoneView

- (BOOL)dragStarted:(AtkDragAndDropManager *)manager
{
    // Yes, consider me for drags.
    return YES;
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
    // Only consider me for enter, exit, move and drop if
    // we are interested in what on the pasteboard.
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

@interface AtkSampleOneViewController : UIViewController

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

@end

```