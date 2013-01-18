//
//  ConnectionVO.h
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQBLineVO.h"
#import "BQBFieldVO.h"

@interface BQBConnectionVO : NSObject

@property (strong) UIView *cell1;
@property (strong) UIView *cell2;
@property (strong) BQBFieldVO *fieldVO1;
@property (strong) BQBFieldVO *fieldVO2;
@property (strong) UIColor *connectionLineColor;
@property BOOL isLineSelected;


// Tableviews of two fields
@property (strong) UIView *superView1;
@property (strong) UIView *superView2;
// Navigation controllers having tableView
@property (strong) UIView *superSuperView1;
@property (strong) UIView *superSuperView2;


-(BQBLineVO *) getLineVOForView:(UIView *)view;
-(BOOL)isEqualToConnection:(BQBConnectionVO *)connection;
-(BOOL)isTemporary;

@end
