//
//  Values.h
//  BatchQueryBuilderDemo
//
//  Created by Prateek Pradhan on 08/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Values;

@protocol ValuesDelegate <NSObject>
@optional
-(void)valuesTableDidScroll:(Values *)tableVC;

@end

@interface Values : UITableViewController{
    NSMutableArray *values;
    NSString *tableName;
}

@property (strong) NSMutableArray *values;
@property (strong) NSString *tableName;
@property (strong) id<ValuesDelegate>delegate;

- (id)initWithValues:(NSMutableArray *)paramValues withTableName:(NSString *)paramTableName;
-(void) valueSelected: (NSString*)valueName;
@end
