//
//  DemoAppViewController.m
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "DemoAppViewController.h"
#import "canvasView.h"

@interface DemoAppViewController ()
- (void)handleFacetPanning:(UIPanGestureRecognizer *)gesture;
- (void)validateAndStartDragging:(UIPanGestureRecognizer *)gesture;
- (void) stopDragging:(UIPanGestureRecognizer *)gesture;
- (void) dragObject:(UIPanGestureRecognizer *)gesture;
@end

@implementation DemoAppViewController

@synthesize canvasBackView;
@synthesize sourcesTableBackView;
@synthesize sources,sourcesTable,sourcesTableNav;
@synthesize canvasView;
@synthesize canvasViewTableArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    sources = [[NSMutableDictionary alloc] init];
    NSArray *table1 = [[NSArray alloc] initWithObjects:@"Field11",@"Field12",@"Field13",@"Field14",@"Field15",@"Field16", nil];
    [sources setObject:table1 forKey:@"table1"];
    NSArray *table2 = [[NSArray alloc] initWithObjects:@"Field21",@"Field22",@"Field23",@"Field24",@"Field25",@"Field26", nil];
    [sources setObject:table2 forKey:@"table2"];
    NSArray *table3 = [[NSArray alloc] initWithObjects:@"Field31",@"Field32",@"Field33",@"Field34",@"Field35",@"Field36", nil];
    [sources setObject:table3 forKey:@"table3"];
    
    sourcesTable = [[Facets alloc] initWithSources:sources];
    sourcesTableNav = [[UINavigationController alloc] initWithRootViewController:sourcesTable];
    sourcesTableNav.view.frame = CGRectMake(0, 0, sourcesTableBackView.frame.size.width, sourcesTableBackView.frame.size.height);
    [self.sourcesTableBackView addSubview:sourcesTableNav.view];
    
    canvasView = [[CanvasView alloc] initWithFrame:CGRectMake(0, 0, self.canvasBackView.frame.size.width, self.canvasBackView.frame.size.height)];
    canvasView.backgroundColor = [UIColor blueColor];
    [self.canvasBackView addSubview:canvasView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFacetPanning:)];
    [self.sourcesTableBackView addGestureRecognizer:panGesture];
    
    canvasViewTableArray = [[NSMutableArray alloc] init];
    
}
//code related to dragging Facets
//called when pan gesture starts
- (void)handleFacetPanning:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
			[self validateAndStartDragging:gesture];
			break;
		case UIGestureRecognizerStateChanged:
			[self dragObject:gesture];
			break;
		case UIGestureRecognizerStateEnded:
			[self stopDragging:gesture];
			break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
    }
}
- (void)initDraggedFacetWithCell:(UITableViewCell *)cell atPoint:(CGPoint)point
{
	if (draggedCell != nil) {
		[draggedCell removeFromSuperview];
		draggedCell = nil;
	}
	CGRect frame = CGRectMake(point.x, point.y, cell.frame.size.width, cell.frame.size.height);
	draggedCell = [[UITableViewCell alloc] init];
	draggedCell.textLabel.text = cell.textLabel.text;
	draggedCell.alpha = 0.8;
	draggedCell.frame = frame;
	//draggedCell.highlighted = YES;
    draggedCell.backgroundColor = [UIColor darkGrayColor];
    draggedCell.textLabel.textColor = [UIColor whiteColor];
    draggedCell.textLabel.font = [UIFont systemFontOfSize:14.0];
	draggedCell.selectionStyle = UITableViewCellSelectionStyleGray;
	[self.view addSubview:draggedCell];
}
- (void)validateAndStartDragging:(UIPanGestureRecognizer *)gesture{

    draggedTable =nil;
    if(!sourcesTable.isDetailedViewVisible){
        draggedTable = sourcesTable;
    }else{
        draggedTable = sourcesTable.selectedValueTable;
    }
    CGPoint startingPoint = [gesture locationInView:draggedTable.tableView];
    NSIndexPath *indexPath = [draggedTable.tableView indexPathForRowAtPoint:startingPoint];
    UITableViewCell *cell = [draggedTable.tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        CGPoint origin = cell.frame.origin;
        CGPoint locInMainView = [gesture locationInView:self.view];
        //this cell should be placed at point on which dragging initiated
        origin.x = locInMainView.x - 5;
        origin.y = locInMainView.y - 5;
        [self initDraggedFacetWithCell:cell atPoint:origin];
        cell.highlighted = NO;
        if (draggedCellData != nil) {
            draggedCellData = nil;
        }
        draggedCellData = [sourcesTable.facetKeys objectAtIndex:indexPath.row];
    }
    
}

- (void) stopDragging:(UIPanGestureRecognizer *)gesture{
     if(draggedCell != nil && draggedCellData != nil){
        BOOL droppedAtCorrectTarget = NO;

         CGPoint droppedAtPoint = [gesture locationInView:self.canvasBackView];
         if ([self.canvasBackView pointInside:droppedAtPoint withEvent:nil]) {
             droppedAtCorrectTarget = YES;
             NSMutableArray  *valueArray = nil;
             NSString *tableName = nil;
             if([draggedTable isKindOfClass:[Facets class]]){
                 valueArray = [NSMutableArray arrayWithArray:[self.sources objectForKey:draggedCellData]];
                 tableName = draggedCellData;
                 
                
             }else{
                 Values *valueTable = (Values *)draggedTable;
                 valueArray = [NSMutableArray arrayWithArray:[valueTable values]] ;
                 tableName = valueTable.tableName;
                 
             }
             
             Values *sourceValueTable = [[Values alloc] initWithValues:valueArray withTableName:tableName];
             sourceValueTable.view.frame = CGRectMake(0, 0,200, 200);
             
             UINavigationController *sourceValueTableNav = [[UINavigationController alloc] initWithRootViewController:sourceValueTable];
             [canvasViewTableArray addObject:sourceValueTable];
             
             sourceValueTableNav.view.frame =sourceValueTable.view.frame;
     
             [self.canvasBackView addSubview:sourceValueTableNav.view];
             
         }
         
     
     
     }
    
    //remove dragged cell from super view, we don't need it anymore
	[draggedCell removeFromSuperview];
	draggedCell = nil;
	draggedCellData = nil;
    draggedTable = nil;
    
}
- (void) dragObject:(UIPanGestureRecognizer *)gesture{
    if(draggedCell != nil && draggedCellData != nil){
        CGPoint translation = [gesture translationInView:draggedTable.tableView];
        [draggedCell setCenter:CGPointMake(draggedCell.center.x+translation.x, draggedCell.center.y+translation.y)];
		[gesture setTranslation:CGPointZero inView:[draggedCell superview]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
