//
//  ImageDownloaderUsingNSURL.h
//  PhotoCollection
//
//  Created by NewputMac04 on 06/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageDownloaderUsingNSURL;
@protocol ImageDownloaderDelegate

- (void)appImageDidLoadWithImageDownloader:(ImageDownloaderUsingNSURL *)object;

@end

@interface ImageDownloaderUsingNSURL : NSObject

@property (strong) NSIndexPath *indexPathInCollectionView;
@property (strong) id <ImageDownloaderDelegate> delegate;
@property (strong) UIImage *imageDownloaded;
@property (strong) NSString *imageURL;



- (void)startDownload;
- (void)cancelDownload;

@end


