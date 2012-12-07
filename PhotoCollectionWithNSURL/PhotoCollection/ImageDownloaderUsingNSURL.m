//
//  ImageDownloaderUsingNSURL.m
//  PhotoCollection
//
//  Created by NewputMac04 on 06/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import "ImageDownloaderUsingNSURL.h"


@interface ImageDownloaderUsingNSURL() <NSURLConnectionDataDelegate>
@property (strong) NSURLConnection *imageConnection;
@property (strong) NSMutableData *activeDownload;
@end


@implementation ImageDownloaderUsingNSURL

@synthesize imageConnection,imageURL,imageDownloaded,indexPathInCollectionView,delegate,activeDownload;

//Start downloading the image
- (void)startDownload{
    
    self.activeDownload = [NSMutableData data];

    
    NSURLConnection *conection = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:self.imageURL]] delegate:self];
    
    self.imageConnection = conection;
    
}
//Cancel the image downloading 
- (void)cancelDownload{
    [self cleanResources];
    self.imageDownloaded = nil;
}

-(void) cleanResources{
    if(self.imageConnection){
        [self.imageConnection  cancel];
    }
    self.activeDownload  = nil;
}

#pragma mark NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //Connection failed so have to recreate the connection if want to try again
        [self cancelDownload];
    //call the receiver of this image
    [self.delegate appImageDidLoadWithImageDownloader:self];
}

#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.activeDownload appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

        UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    // if image is not properly created using this data, clean the resources
    if(image){
        self.imageDownloaded = image;
    }
    
    [ self cleanResources];

    //call the receiver of this image
    [self.delegate appImageDidLoadWithImageDownloader:self];
    
}

@end
