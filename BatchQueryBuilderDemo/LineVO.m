//
//  LineVO.m
//  BatchQueryBuilderDemo
//
//  Created by Surendra on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "LineVO.h"

@implementation LineVO

-(id)initWithStartPoint1:(CGPoint)sp1 startPoint2:(CGPoint)sp2 endPoint1:(CGPoint)ep1 endPoint2:(CGPoint)ep2{
    if (self = [super init]) {
        self.startPoint1 = sp1;
        self.startPoint2 = sp2;
        self.endPoint1 = ep1;
        self.endPoint2 = ep2;
        self.startPoint = [self getPoint:YES];
        self.endPoint = [self getPoint:NO];
        self.length = [self getLenght];
    }
    return self;
}

-(CGPoint)getPoint:(BOOL)returnStartPoint{
    CGPoint resultPoint;
    
    CGFloat xDiff = (self.startPoint1.x - self.endPoint1.x);
    CGFloat yDiff = (self.startPoint1.y - self.endPoint1.y);
    CGFloat length1 = sqrtf(xDiff * xDiff + yDiff * yDiff);
    
    xDiff = (self.startPoint1.x - self.endPoint2.x);
    yDiff = (self.startPoint1.y - self.endPoint2.y);
    CGFloat length2 = sqrtf(xDiff * xDiff + yDiff * yDiff);
    
    xDiff = (self.startPoint2.x - self.endPoint1.x);
    yDiff = (self.startPoint2.y - self.endPoint1.y);
    CGFloat length3 = sqrtf(xDiff * xDiff + yDiff * yDiff);
    
    xDiff = (self.startPoint2.x - self.endPoint2.x);
    yDiff = (self.startPoint2.y - self.endPoint2.y);
    CGFloat length4 = sqrtf(xDiff * xDiff + yDiff * yDiff);
    if (length1 < length2 && length1 < length3 && length1 < length4) {
        if (returnStartPoint) 
            resultPoint = self.startPoint1;
        else
            resultPoint = self.endPoint1;
        NSLog(@">>>1");
        
    }else if (length2 < length3 && length2 < length4){
        if (returnStartPoint)
            resultPoint = self.startPoint1;
        else
            resultPoint = self.endPoint2;
        NSLog(@">>>2");
    }else if (length3 < length4){
        if (returnStartPoint)
            resultPoint = self.startPoint2;
        else
            resultPoint = self.endPoint2;
        NSLog(@">>>3");
    }else{
        if (returnStartPoint)
            resultPoint = self.startPoint2;
        else
            resultPoint = self.endPoint1;
        NSLog(@">>>4");
    }
    return resultPoint;
    
}

//-(CGPoint)startPoint{
//    return [self getPoint:YES];
//}
//-(CGPoint)endPoint{
//    return [self getPoint:NO];
//}
-(CGFloat)getLenght{
   
    CGPoint point1 = self.startPoint;
    CGPoint point2 = self.endPoint;
    CGFloat xDiff = (point1.x - point2.x);
    CGFloat yDiff = (point1.y - point2.y);
    return sqrtf(xDiff * xDiff + yDiff * yDiff);
}

@end
