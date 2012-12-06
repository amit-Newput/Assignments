//
//  PhotoCollectionViewController.m
//  PhotoCollection
//
//  Created by NewputMac04 on 05/12/12.
//  Copyright (c) 2012 NewputMac04. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "FlickrFetcher.h"


@interface PhotoCollectionViewController ()
{
    NSMutableArray * listOfPhotos;
    NSMutableDictionary * urlCellDictionary;
    NSMutableDictionary* urlPhotoDictionary;

}
@end

@implementation PhotoCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    listOfPhotos = [[NSMutableArray alloc] init];
    urlCellDictionary = [[NSMutableDictionary alloc] init];
    urlPhotoDictionary= [[NSMutableDictionary alloc] init];
    NSArray* photoDataArray = [FlickrFetcher recentGeoreferencedPhotos];
    for(NSDictionary* flickrPhotoData in photoDataArray){
        NSString* url = [FlickrFetcher urlStringForPhotoWithFlickrInfo:flickrPhotoData format:FlickrFetcherPhotoFormatThumbnail];
        [listOfPhotos addObject:url];
    }
	// Do any additional setup after loading the view.
}

-(void) processImageDataWithURL: (NSString*) imageURL withBlock:(void (^) (NSString* url,NSData * imageData)) processImage{
    NSString* url = imageURL;
    dispatch_queue_t callerQueue =  dispatch_get_main_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("PhotoDownloadQueue", NULL);
    dispatch_async(downloadQueue, ^{
    
        NSData * imageData = [FlickrFetcher imageDataForPhotoWithURLString:url];
        dispatch_async(callerQueue, ^{
            processImage(url,imageData);
        });}
    );
}

    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrPhotoCell" forIndexPath:indexPath];
    
    NSString* imageURL = [listOfPhotos objectAtIndex:indexPath.row];
    NSData* imageData = [urlPhotoDictionary objectForKey:imageURL];
    if(imageData ==nil){
        [cell.spinner startAnimating];
        [self processImageDataWithURL:imageURL withBlock:^(NSString* url, NSData*   imageData){
            [urlPhotoDictionary setObject:imageData forKey:url];
            UIImage* img = [UIImage imageWithData:imageData];
            PhotoCollectionViewCell * thisCell = [urlCellDictionary objectForKey:url];
            if(thisCell.photoImageView.image !=img)
                [[thisCell photoImageView] setImage:img];
            [thisCell.spinner stopAnimating];
        }];
    [urlCellDictionary setObject:cell forKey:imageURL];
    }
    else{
        cell.photoImageView.image = [UIImage imageWithData:imageData];
    }
    //UIImage* img = [UIImage imageWithData:[FlickrFetcher imageDataForPhotoWithURLString:[listOfPhotos objectAtIndex:indexPath.row]]];
    //if(cell.photoImageView.image !=img)
      //  [[cell photoImageView] setImage:img];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return listOfPhotos.count;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
