//
//  SGMAlbumViewController.h
//  WeiXinPhoto
//
//  Created by 苏贵明 on 15/9/4.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGMPhotosViewController.h"
typedef enum {
    
    SGMAlbumStyleAlbum    = 0,//相册
    SGMAlbumStyleCamera    = 1,//照相机
}SGMAlbumStyle;


@protocol SGMAlbumViewControllerDelegate <NSObject>

- (void)sendImageWithcameraImage:(UIImage *)cameraImage withStyle:(SGMAlbumStyle)style withAssetArrays:(NSArray *)assetArrays;

@end

@interface SGMAlbumViewController : UIViewController <SGMPhotosViewControllerDelegate>

@property int limitNum;//限制选择张数，不设置(<1)即不限制
@property (nonatomic,weak) id<SGMAlbumViewControllerDelegate> delegate;
@property (nonatomic, assign) SGMAlbumStyle style;

@end
