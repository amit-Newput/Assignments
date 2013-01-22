//
//  DemoAppViewController.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourcesTable.h"
#import "CanvasView.h"
#import "FieldsTable.h"
#import "DataCell.h"
#import "BQBDataVO.h"
#import "MultiColumnTableView.h"

@interface BatchQueryController : UIViewController<FieldsTableDelegate,CanvasViewDelegate,MultiColumnTableViewDelegate>{
    IBOutlet UIView *canvasBackView;
    IBOutlet UIView *sourcesTableBackView;
    SourcesTable *sourcesTable;
    UINavigationController *sourcesTableNav;
    //UITableViewController *draggedTable;
    UINavigationController *draggedTableNav;
    DataCell *draggedCell;
    DataCell *initialDraggedCell;
    DataCell *highlightedCell;
    NSMutableDictionary *canvasViewTablesDic;
}

@property (strong) IBOutlet UIView *canvasBackView;
@property (strong) IBOutlet MultiColumnTableView *grid;
@property (strong) IBOutlet CanvasView *canvasView ;

@property (strong) IBOutlet UIView *sourcesTableBackView;
@property (strong) UIScrollView   *connectionListView;
//@property (strong) NSMutableArray *sourceVOs;
@property (strong) SourcesTable *sourcesTable;
@property (strong) UINavigationController *sourcesTableNav;

@property (strong) NSMutableDictionary *canvasViewTablesDic;
@property (strong) BQBDataVO * dataVO;
@end
