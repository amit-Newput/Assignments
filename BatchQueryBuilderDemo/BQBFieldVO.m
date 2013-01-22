//
//  FieldVO.m
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 11/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "BQBFieldVO.h"

@implementation BQBFieldVO

-(NSString *)expression{
    return [NSString stringWithFormat:@"%@.%@",self.sourceVO.name,self.name];
}

@end
