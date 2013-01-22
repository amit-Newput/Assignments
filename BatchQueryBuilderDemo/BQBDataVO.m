//
//  BQBDataVO.m
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 17/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "BQBDataVO.h"


@implementation BQBDataVO

-(id) init{
    
    if (self = [super init])  {
        self.sourceVOs = [[NSMutableArray alloc] init];
        self.connectionVOs = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *) gridFields{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (BQBSourceVO *source in self.sourceVOs) {
        if (source.isSelected) {
            for (BQBFieldVO *field in source.fieldVOs) {
                if (field.isSelected) {
                    [tempArray addObject:field];
                }
            }
        }
    }
    return [NSArray arrayWithArray:tempArray];
}
@end
