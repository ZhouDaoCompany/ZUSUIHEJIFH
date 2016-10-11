//
//  MyPickView.m
//  ZhouDao
//
//  Created by cqz on 16/3/5.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MyPickView.h"
//#import "UIImageView+LBBlurredImage.h"
//#import "QHCommonUtil.h"
#import "Provice.h"
#import "NSString+SPStr.h"

#define VIEWWITH   [UIScreen mainScreen].bounds.size.width/3.f

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
@interface MyPickView() <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIImageView *_mainBackgroundIV;
}
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic)  UIPickerView *myPicker;
@property (strong, nonatomic)  UIView *pickerBgView;

//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation MyPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self getPickerData];
        [self initView];
        //[self configureViewBlurWith:self.frame.size.width scale:0.4];


    }
    return self;
}

#pragma mark - init view
- (void)initView {
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3f;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    [self addSubview:self.maskView];
    
    
    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 255)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerBgView];
    
    self.myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 39.f, width, 216)];
    self.myPicker.showsSelectionIndicator=YES;//显示选中框
    self.myPicker.delegate = self;
    self.myPicker.dataSource = self;
    [self.pickerBgView addSubview:self.myPicker];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 39)];
    toolView.backgroundColor = [UIColor whiteColor];
    [self.pickerBgView addSubview:toolView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(toolView), kMainScreenWidth, .5f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.pickerBgView addSubview:lineView];

    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:0];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = Font_14;
    cancelBtn.frame = CGRectMake(0, 0, 50, 39);
    [self.pickerBgView addSubview:cancelBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitleColor:[UIColor blackColor] forState:0];
    [ensureBtn setTitle:@"确定" forState:0];
    [ensureBtn addTarget:self action:@selector(ensureEvent:) forControlEvents:UIControlEventTouchUpInside];
    ensureBtn.titleLabel.font = Font_14;
    ensureBtn.backgroundColor = [UIColor clearColor];
    ensureBtn.frame = CGRectMake(width-50, 0, 50, 39);
    [self.pickerBgView addSubview:ensureBtn];
    
    [UIView animateWithDuration:0.35f animations:^{
        self.pickerBgView.frame = CGRectMake(0, height - 255, width, 255);
    }];

}
#pragma mark - get data
- (void)getPickerData {
    
//    NSString *pathSource = [[NSBundle mainBundle] pathForResource:@"areas" ofType:@"txt"];
//    NSString *dataS = [NSString stringWithContentsOfFile:pathSource encoding:NSUTF8StringEncoding error:nil];
//    
//    //DLog(@"输出文件数据－－－－－%@",dataS);
//    NSData *data = [dataS dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *pathSource = [MYBUNDLE pathForResource:@"Areas" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];

    //DLog(@"解析是否成功－－－－－%@",dict);
    
//    NSData *weChatdatamsg = [self toJSONData:arraysf];
//    NSString *weChatPayMsg =[[NSString alloc] initWithData:weChatdatamsg
//                                                  encoding:NSUTF8StringEncoding];
//
//    DLog(@"列表－－－－－－%@",weChatPayMsg);
    
    self.pickerDic = [[NSMutableDictionary alloc] init];
    self.pickerDic = dict;
    self.provinceArray  = ProvinceArrays;
//    self.provinceArray = (NSMutableArray *)[self.pickerDic allKeys];
//
//    [self.provinceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        DLog(@"输出－－－－－%@",(NSString *)obj);
//    }];
    self.selectedArray = [self.pickerDic objectForKey:self.provinceArray[0]];
    
//        NSData *weChatdatamsg = [self toJSONData:self.selectedArray];
//        NSString *weChatPayMsg =[[NSString alloc] initWithData:weChatdatamsg
//                                                      encoding:NSUTF8StringEncoding];
//    DLog(@"河北省－－－－%@",weChatPayMsg);
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ( error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return kMainScreenWidth/3.f -10;
    } else if (component == 1) {
        return kMainScreenWidth/3.f +10;
    } else {
        return kMainScreenWidth/3.f;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}
/************************重头戏来了************************/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEWWITH, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text =[self.provinceArray objectAtIndex:row];
        myView.text.length>7?[myView setFont:Font_12]:[myView setFont:Font_14];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else if (component == 1){
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEWWITH, 30)];
        
        myView.text = [self.cityArray objectAtIndex:row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text.length>7?[myView setFont:[UIFont systemFontOfSize:10]]:[myView setFont:Font_14];
        myView.backgroundColor = [UIColor clearColor];
        
    }else{
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEWWITH, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text =[self.townArray objectAtIndex:row];
        
        myView.text.length>7?[myView setFont:Font_12]:[myView setFont:Font_14];
        
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
    
}
- (void)hideMyPicker{
    self.blurBlock();
    [UIView animateWithDuration:.35f animations:^{
        float width = self.frame.size.width;
        float height = self.frame.size.height;

        self.pickerBgView.frame = CGRectMake(0, height, width, 255);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - xib click
- (void)cancelEvent:(id)sender {
    [self hideMyPicker];
}
- (void)ensureEvent:(id)sender {
    
    NSString *str1 = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    NSString *str2 = [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    NSString *str3 = [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
    self.pickBlock(str1,str2,str3);
    
    [self hideMyPicker];
}
#pragma mark -来个3d效果
-(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
}

-(CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DTranslate(t2, 0, self.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}

//- (void)configureViewBlurWith:(float)nValue scale:(float)nScale
//{
//    if(_mainBackgroundIV == nil)
//    {
//        _mainBackgroundIV = [[UIImageView alloc] initWithFrame:self.bounds];
//        _mainBackgroundIV.userInteractionEnabled = YES;
//        
//        UIImage *image = [QHCommonUtil getImageFromView:self];
//        [_mainBackgroundIV setImageToBlur:image
//                               blurRadius:kLBBlurredImageDefaultBlurRadius
//                          completionBlock:^(){}];
//        
//        [self addSubview:_mainBackgroundIV];
//    }
//    [_mainBackgroundIV setAlpha:(nValue/self.frame.size.width) * nScale];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
