//
//  ConnectionVO.m
//  BatchQueryBuilderDemo
//
//  Created by NewputMac04 on 09/01/13.
//  Copyright (c) 2013 Prateek Pradhan. All rights reserved.
//

#import "ConnectionVO.h"

@interface ConnectionVO()

{
    CGPoint pSP1;
    CGPoint pSP2;
    CGPoint pEP1;
    CGPoint pEP2;
    UIView *superView1;
    UIView *superView2;
    UIView *superSuperView1;
    UIView *superSuperView2;
}

@end

@implementation ConnectionVO


-(LineVO *) getLineVOForView: (UIView*)view{
    
    CGPoint startPoint1 = CGPointMake(self.cell1.frame.origin.x  ,self.cell1.frame.origin.y + (self.cell1.frame.size.height /2) );
    CGPoint startPoint2 = CGPointMake((self.cell1.frame.origin.x-1 + self.cell1.frame.size.width) ,(self.cell1.frame.origin.y + (self.cell1.frame.size.height)/2) );
    
    CGPoint endPoint1 = CGPointMake(self.cell2.frame.origin.x  ,(self.cell2.frame.origin.y + (self.cell2.frame.size.height) /2) );
    CGPoint endPoint2 = CGPointMake((self.cell2.frame.origin.x-1 + self.cell2.frame.size.width) ,(self.cell2.frame.origin.y + (self.cell2.frame.size.height) /2) );
    
//    if (!self.isTemporary) {
//        BOOL b1 = [self.cell1.superview pointInside:startPoint1 withEvent:nil];
//        BOOL b2 = [self.cell1.superview pointInside:startPoint2 withEvent:nil];
//        BOOL b3 = [self.cell2.superview pointInside:endPoint1 withEvent:nil];
//        BOOL b4 = [self.cell2.superview pointInside:endPoint2 withEvent:nil];
//        
//        if (!b1) {
//            startPoint1 = pSP1;
//        }
//        if (!b2) {
//            startPoint2 = pSP2;
//        }
//        if (!b3) {
//            endPoint1 = pEP1;
//        }
//        if (!b4) {
//            endPoint2 = pEP2;
//        }
//        /*if (!(b1 && b2)|| !(b3 && b4)) {
//            LineVO *objLineVO = [[LineVO alloc] initWithStartPoint1:startPoint1 startPoint2:startPoint2 endPoint1:endPoint1 endPoint2:endPoint2];
//            return objLineVO;
//        }*/
//        
//    }
    
    //Convert the starting and end points in the co-oridnate system of given view
    UIView *fromView1 = nil;
    UIView *fromView2 = nil;
    if (self.cell1.superview) {
        superView1 = self.cell1.superview;
        fromView1 = superView1;
        if (superView1) {
            superSuperView1 = superView1.superview;
        }
    }else{
        
        startPoint1.y = pSP1.y < superView1.frame.size.height/2?  -22: superView1.frame.size.height;
        startPoint2.y = pSP2.y < superView1.frame.size.height/2?  -22: superView1.frame.size.height;
        fromView1 = superSuperView1;

    }
    
    if (self.cell2.superview) {
        superView2 = self.cell2.superview;
        fromView2 = superView2;
        if (superView2) {
            superSuperView2 = superView2.superview;
        }
        
    }else{
        endPoint1.y = pEP1.y < superView2.frame.size.height/2?  -22: superView2.frame.size.height;
        endPoint2.y = pEP2.y < superView2.frame.size.height/2?  -22: superView2.frame.size.height;
        fromView2 = superSuperView2;
        
    }
    
    pSP1 = startPoint1;
    pSP2 = startPoint2;
    pEP1 = endPoint1;
    pEP2 = endPoint2;
    
    if (fromView1) {
        startPoint1 = [view convertPoint:startPoint1 fromView:fromView1];
        startPoint2 = [view convertPoint:startPoint2 fromView:fromView1];
    }
    if (fromView2) {
        endPoint1 = [view convertPoint:endPoint1 fromView:fromView2];
        endPoint2 = [view convertPoint:endPoint2 fromView:fromView2];
    }

    
    LineVO *objLineVO = [[LineVO alloc] initWithStartPoint1:startPoint1 startPoint2:startPoint2 endPoint1:endPoint1 endPoint2:endPoint2];
    return objLineVO;}

-(BOOL)isEqualToConnection:(ConnectionVO *)connection{
    if ([self.value1 isEqualToString:connection.value1] && [self.value2 isEqualToString:connection.value2]) {
        return YES;
    }
    return NO;
}
@end
