//
//  MultiColumnTableView.h
//  BatchQueryBuilderDemo
//
//  Created by Vipin Joshi on 18/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiColumnTableView;

@protocol MultiColumnTableViewDelegate


-(int)multiColumnTableView:(MultiColumnTableView *)tableView numberOfRowsInSection:(int)section;
-(int)numberOfSectionsInMultiColumnTableView:(MultiColumnTableView *)tableView;
-(int)numberOfColumnsForMultiColumnTableView:(MultiColumnTableView *)tableView;
-(NSArray *)columnWidthRatiosForMultiColumnTableView:(MultiColumnTableView *)tableView;
-(CGFloat)multiColumnTableView:(MultiColumnTableView *)tableView heightForHeaderInSection:(int)section;
-(NSArray *)headerTitlesForColumnInMultiColumnTableView:(MultiColumnTableView *)tableView;
-(UIView *)multiColumnTableView:(MultiColumnTableView *)tableView viewForColumn:(int)columnIndex atRow:(int)rowIndex;


@end

@interface MultiColumnTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (strong) IBOutlet id<MultiColumnTableViewDelegate> multiColumnTableViewDelegate;

@end
