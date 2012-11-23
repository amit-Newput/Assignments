//
//  ViewController.h
//  ImageDragSingleView
//
//  Created by Chetan Sanghi on 22/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
}
@property (strong) IBOutlet UIView* mySubView;
@property (strong,nonatomic) NSMutableArray * imageViewMutableArray;
@property (strong) UIImageView * panImage;
@property int initialPanPositionX;
@property int initialPanPositionY;
@property (strong) UIColor* backGroundColor;
@end
