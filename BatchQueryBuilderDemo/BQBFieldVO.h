//
//  FieldVO.h
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 11/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQBSourceVO.h"

 typedef enum {
    FieldTypeNumeric ,
    FieldTypeString
} FieldType;

@interface BQBFieldVO : NSObject

@property (strong) NSString *name;
@property (strong) NSString *fieldID;
@property  BOOL isSelected;
@property FieldType type;
@property (strong) NSString *alias;
@property (strong) NSString *aggregateFunction;
@property (strong) NSString *criteria;
@property (strong) BQBSourceVO *sourceVO;

// return sourceVO.name + field.name
-(NSString *)expression;

@end
