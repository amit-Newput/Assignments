//
//  ConnectionVO.m
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "ConnectionVO.h"

@implementation ConnectionVO


-(LineVO *) getLineVOForView: (UIView*)view{
    CGPoint startPoint1 = CGPointMake(self.cell1.frame.origin.x  ,(self.cell1.frame.origin.y + self.cell1.frame.size.height) /2 );
   CGPoint startPoint2 = CGPointMake((self.cell1.frame.origin.x + self.cell1.frame.size.width) ,(self.cell1.frame.origin.y + self.cell1.frame.size.height) /2 );
    
    CGPoint endPoint1 = CGPointMake(self.cell2.frame.origin.x  ,(self.cell2.frame.origin.y + self.cell2.frame.size.height) /2 );
    CGPoint endPoint2 = CGPointMake((self.cell2.frame.origin.x + self.cell2.frame.size.width) ,(self.cell2.frame.origin.y + self.cell2.frame.size.height) /2 );
    
    
    //Convert the starting and end points in the co-oridnate system of given view
    startPoint1 = [view convertPoint:startPoint1 fromView:self.cell1.superview];
    startPoint2 = [view convertPoint:startPoint2 fromView:self.cell1.superview];
    endPoint1 = [view convertPoint:endPoint1 fromView:self.cell2.superview];
    endPoint2 = [view convertPoint:endPoint2 fromView:self.cell2.superview];
    
    
    LineVO * objLineVO = [[LineVO alloc] initWithStartPoint1:startPoint1 startPoint2:startPoint2 endPoint1:endPoint1 endPoint2:endPoint2];
    
    return objLineVO;
}

@end
