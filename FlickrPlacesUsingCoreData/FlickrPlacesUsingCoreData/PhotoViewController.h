//
//  PhotoViewController.h
//  FlickrPlaces
//
//  Created by Chetan Sanghi on 26/11/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDescription.h"

@interface PhotoViewController : UIViewController <UIScrollViewDelegate>

{
    UIImageView * imageView;
    UIScrollView * scrollView;
}
@property (strong) PhotoDescription* photoDescription;
-(UIImage*)loadImageWithImageName:imageName ;
-(void)saveImage:(UIImage*)image withName:(NSString*)imageName ;
@end
