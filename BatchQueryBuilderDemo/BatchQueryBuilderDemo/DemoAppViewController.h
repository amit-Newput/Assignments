//
//  DemoAppViewController.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facets.h"
#import "CanvasView.h"
#import "Values.h"

@interface DemoAppViewController : UIViewController<ValuesDelegate>{
    IBOutlet UIView *canvasBackView;
    IBOutlet UIView *sourcesTableBackView;
    NSMutableDictionary *sources;
    Facets *sourcesTable;
    UINavigationController *sourcesTableNav;
    NSString *draggedCellData;
    UITableViewController *draggedTable;
    UINavigationController *draggedTableNav;
    UITableViewCell *draggedCell;
    UITableViewCell *initialDraggedCell;
    UITableViewCell *highlightedCell;
    NSMutableDictionary *canvasViewTablesDic;
}

@property (strong) IBOutlet UIView *canvasBackView;
@property (strong) IBOutlet UIView *sourcesTableBackView;
@property (strong) NSMutableDictionary *sources;
@property (strong) IBOutlet  Facets *sourcesTable;
@property (strong) UINavigationController *sourcesTableNav;
@property (strong) CanvasView *canvasView ;
@property (strong) NSMutableDictionary *canvasViewTablesDic;
@end
