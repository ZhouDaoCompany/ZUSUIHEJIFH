//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUrlArray:(NSArray *)urlArray
{
    _urlArray = urlArray;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    CGFloat btnWidth = self.bounds.size.height;

    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = CGRectMake(20, 0, self.bounds.size.width - 20, btnWidth);//self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
//        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textAlignment = NSTextAlignmentLeft;
        _indexLabel.font = Font_14;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    _saveImageBtn.frame = CGRectMake(self.bounds.size.width -20 - btnWidth, 0, btnWidth, btnWidth);
    [_saveImageBtn setTitle:@"保存" forState:0];
    [_saveImageBtn setTitleColor:[UIColor whiteColor] forState:0];
    _saveImageBtn.titleLabel.font = Font_14;

    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
}

- (void)saveImage
{
    //change by zmm
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    });
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [self.urlArray[_currentPhotoIndex] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *imgae = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(imgae, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [SVProgressHUD dismiss];

    if (error) {

        [JKPromptView showWithImageName:nil message:@"保存失败"];
    }else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
//        _saveImageBtn.enabled = NO; 隐藏 change by zmm
        [JKPromptView showWithImageName:nil message:@"成功保存到相册"];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    
//    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
    _saveImageBtn.enabled = YES;//隐藏上2行代码 change by zmm
    
}

@end
