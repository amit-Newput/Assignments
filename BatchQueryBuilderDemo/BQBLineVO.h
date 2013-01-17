//
//  LineVO.h
//  BatchQueryBuilderDemo
//
//  Created by Surendra on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQBLineVO : NSObject

@property CGPoint startPoint1;
@property CGPoint startPoint2;
@property CGPoint endPoint1;
@property CGPoint endPoint2;
@property CGPoint startPoint;
@property CGPoint endPoint;
@property CGFloat length;
@property UIColor *lineColor;
@property CGFloat lineWidth;

-(id)initWithStartPoint1:(CGPoint)sp1 startPoint2:(CGPoint)sp2 endPoint1:(CGPoint)ep1 endPoint2:(CGPoint)ep2;

@end
