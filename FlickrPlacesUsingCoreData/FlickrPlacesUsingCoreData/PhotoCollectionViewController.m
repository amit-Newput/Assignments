 //
//  PhotoCollectionViewController.m
//  FlickrPlacesUsingCoreData
//
//  Created by NewputMac04 on 06/12/12.
//  Copyright (c) 2012 sanghichetan@yahoo.com. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoCollectionReusableView.h"
#import "PhotoViewController.h"

#import "FlickrFetcher.h"
#import "AppDelegate.h"
#import "PhotoDescription.h"

@interface PhotoCollectionViewController () < UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
   // NSMutableArray * listOfPhotos;
    //NSMutableDictionary * urlCellDictionary;
    NSMutableDictionary* urlIndexPathDictionary;
    NSMutableDictionary* urlPhotoDictionary;
    NSMutableDictionary* photoDescriptionDictionary;
    
}
@property (nonatomic,strong) NSArray* sections;
@end

@implementation PhotoCollectionViewController
@synthesize city,sections;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) getPhotoDesriptionDictionary{
    
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("PhotoListDownloadQueue", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray* listOfPhotos = [self.city  getListOfPhotosWithBlock];
        
        dispatch_async(callerQueue, ^{
            NSDictionary* photoDictionary = [self.city createPhotoDictionary:listOfPhotos];
            photoDescriptionDictionary   = [[NSMutableDictionary alloc] init];
            for(id key in photoDictionary){
                NSMutableArray* photoDescriptionArray = [[NSMutableArray alloc] init];
                for(NSDictionary* flickrPhotoData in [photoDictionary objectForKey:key]){
                  PhotoDescription* thisPhotoDescription =  [PhotoDescription PhotoDescriptionWithFlickrData:flickrPhotoData withCity:self.city inManagedObjectContext:[(AppDelegate*)[[UIApplication sharedApplication] delegate]  managedObjectContext]];
                    
                    [photoDescriptionArray addObject:thisPhotoDescription];
                }
                [photoDescriptionDictionary  setObject:photoDescriptionArray  forKey:key];
            }
            [self.collectionView reloadData];
        });
        
    });
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self getPhotoDesriptionDictionary];
    urlIndexPathDictionary = [[NSMutableDictionary alloc] init];
    urlPhotoDictionary= [[NSMutableDictionary alloc] init];
    
    //Registring the PhotoCollectionViewCell as our cell class and setting the reuse identifier
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"CVCell1"];
  
    //Registering the photoCollectionReusableView as our section header and setting the reuse identifier for it.
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoCollectionHeader"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}
-(NSArray*)sections{
    if(!sections){
        
        //Using Blocks for Sorting
        sections = [[photoDescriptionDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                    {
                        int firstNumber = [ obj1 intValue];
                        int secondInt = [obj2 intValue];
                        if(firstNumber > secondInt)
                            return NSOrderedDescending;
                        else   if(firstNumber < secondInt)
                            return NSOrderedAscending;
            
                        else
                            return  NSOrderedSame;
            
                    }
            ];
    }
    return sections;
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)thisCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell* cell = (PhotoCollectionViewCell *)[thisCollectionView dequeueReusableCellWithReuseIdentifier:@"CVCell1" forIndexPath:indexPath];
    
    //NSString* imageURL = [listOfPhotos objectAtIndex:indexPath.row];
    PhotoDescription* thisPhotoDescription = [[photoDescriptionDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    NSString* imageURL = thisPhotoDescription.photoURL;
    NSData* imageData = [urlPhotoDictionary objectForKey:imageURL];
    if(imageData ==nil){
        
        //[urlCellDictionary setObject:cell forKey:imageURL];
        [urlIndexPathDictionary  setObject:indexPath forKey:imageURL];
        
        cell.thisPhotoImageView.backgroundColor  = [UIColor whiteColor];
        cell.thisPhotoImageView.image = nil;
        [cell.thisSpinner startAnimating];
        
        [self processImageDataWithURL:imageURL withBlock:^(NSString* url, NSData*   imageData){
            if(imageData != nil){
            [urlPhotoDictionary setObject:imageData forKey:url];
            }
            UIImage* img = [UIImage imageWithData:imageData];
            //PhotoCollectionViewCell * thisCell = [urlCellDictionary objectForKey:url];
            PhotoCollectionViewCell* thisCell = (PhotoCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[urlIndexPathDictionary objectForKey:url]];
            if(thisCell.thisPhotoImageView.image !=img)
                [[thisCell thisPhotoImageView] setImage:img];
            [thisCell.thisSpinner stopAnimating];
        }];
        
    }
    else{
        UIImage* img = [UIImage imageWithData:imageData];
        cell.thisPhotoImageView.image = img;
        [cell.thisSpinner stopAnimating ];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return self.sections.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionReusableView* photoCRV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoCollectionHeader" forIndexPath:indexPath];
    
    NSString* sectionTitle= [self.sections objectAtIndex:indexPath.section];
    
    if( [ [sectionTitle substringToIndex:1] isEqualToString:@"0"]){
        sectionTitle = @"Right Now";
    }
    photoCRV.sectionLabel.text = sectionTitle;

    photoCRV.backgroundColor = [UIColor blackColor];
    photoCRV.sectionLabel.textColor = [UIColor whiteColor];
    
    return photoCRV;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return listOfPhotos.count;
    return [[photoDescriptionDictionary objectForKey:[self.sections objectAtIndex:section]] count];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewController* pvc = [[PhotoViewController alloc] init];
    PhotoDescription* thisPhotoDescription = [[photoDescriptionDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    pvc.photoDescription    = thisPhotoDescription;
    
	[self.navigationController pushViewController:pvc animated:YES];
}

@end
