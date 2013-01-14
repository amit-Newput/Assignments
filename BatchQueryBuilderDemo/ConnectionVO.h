//
//  ConnectionVO.h
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineVO.h"
#import "FieldVO.h"

@interface ConnectionVO : NSObject

@property (strong) UIView *cell1;
@property (strong) UIView *cell2;
@property (strong) FieldVO *fieldVO1;
@property (strong) FieldVO *fieldVO2;
@property (strong) UIColor *connectionLineColor;
@property BOOL isLineSelected;


-(LineVO *) getLineVOForView:(UIView *)view;
-(BOOL)isEqualToConnection:(ConnectionVO *)connection;
-(BOOL)isTemporary;

@end
