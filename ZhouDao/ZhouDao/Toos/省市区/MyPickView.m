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
@interface MyPickView() <UIPickerViewDataSource, UIPickerViewDelegate> {
    
}
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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        [self initView];
    }
    return self;
}

#pragma mark - init view
- (void)initView { WEAKSELF;
    
    NSString *pathSource = [MYBUNDLE pathForResource:@"Areas" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];
    self.pickerDic = [[NSMutableDictionary alloc] init];
    self.pickerDic = dict;
    self.provinceArray  = ProvinceArrays;
    self.selectedArray = [self.pickerDic objectForKey:self.provinceArray[0]];
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;

    [self addSubview:self.pickerBgView];
    [self whenCancelTapped:^{
        
        [weakSelf hideMyPicker];
    }];
    [_pickerBgView whenCancelTapped:^{
       
    }];
    
    [self.pickerBgView addSubview:self.myPicker];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kMainScreenWidth, .6f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.pickerBgView addSubview:lineView];

    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:0];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = Font_14;
    cancelBtn.frame = CGRectMake(0, 0, 50, 39);
    [_pickerBgView addSubview:cancelBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitleColor:[UIColor blackColor] forState:0];
    [ensureBtn setTitle:@"确定" forState:0];
    [ensureBtn addTarget:self action:@selector(ensureEvent:) forControlEvents:UIControlEventTouchUpInside];
    ensureBtn.titleLabel.font = Font_14;
    ensureBtn.backgroundColor = [UIColor clearColor];
    ensureBtn.frame = CGRectMake(width-50, 0, 50, 39);
    [_pickerBgView addSubview:ensureBtn];
    
    if ([PublicFunction ShareInstance].m_bLogin == YES) {
        
        if ([PublicFunction ShareInstance].m_user.data.address.length >0) {
            
            NSArray *addressArrays = [[PublicFunction ShareInstance].m_user.data.address componentsSeparatedByString:@"-"];
            NSString *provinceString = (addressArrays.count >0) ? addressArrays[0] : @"";
            NSString *cityString = (addressArrays.count >1) ?addressArrays[1] : @"";
            NSString *areaString = (addressArrays.count >2) ?addressArrays[2] : @"";

            //获取默认地区 选择到响应的pickview
            for (NSUInteger i = 0; i<_provinceArray.count; i++) {
                
                NSString *provinceObj = _provinceArray[i];
                if ([provinceObj isEqualToString:provinceString]) {
                    kDISPATCH_MAIN_THREAD(^{
                        
                        [weakSelf.myPicker selectRow:i inComponent:0 animated:NO];
                    });
                    self.selectedArray = [self.pickerDic objectForKey:_provinceArray[i]];
                    if (_selectedArray.count > 0) {
                        if (self.selectedArray.count > 0) {
                            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
                        }
                        
                        for (NSUInteger ii = 0; ii<_cityArray.count; ii++) {
                            
                            NSString  *cityObj = _cityArray[ii];
                            if (self.cityArray.count > 0) {
                                self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:ii]];
                            }
                            
                            if ([cityObj isEqualToString:cityString]) {
                                
                                [self.myPicker selectRow:ii inComponent:1 animated:NO];
                                for (NSUInteger iii = 0; iii <_townArray.count; iii++) {
                                    
                                    NSString *areaObj = _townArray[iii];
                                    if ([areaObj isEqualToString:areaString]) {
                                        
                                        kDISPATCH_MAIN_THREAD(^{
                                            
                                            [weakSelf.myPicker selectRow:iii inComponent:2 animated:NO];
                                        });
                                        break;
                                    }
                                }
                                
                                break;
                            }
                        }
                    }
                }
            }

        }
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.pickerBgView.frame = CGRectMake(0, height - 255, width, 255);
    }];

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
    }
    return self.townArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return kMainScreenWidth/3.f -10;
    } else if (component == 1) {
        return kMainScreenWidth/3.f +10;
    }
     return kMainScreenWidth/3.f;
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
- (void)hideMyPicker{ WEAKSELF;

    [UIView animateWithDuration:.35f animations:^{
        float width = self.frame.size.width;
        float height = self.frame.size.height;

        weakSelf.pickerBgView.frame = CGRectMake(0, height, width, 255);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
#pragma mark - Button Click
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

#pragma mark - setter and getter 
- (UIView *)pickerBgView {
    
    if (!_pickerBgView) {
        
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        _pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 255)];
        _pickerBgView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerBgView;
}
- (UIPickerView *)myPicker {
    
    if (!_myPicker) {
        float width = self.frame.size.width;
        _myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 39.f, width, 216)];
        _myPicker.showsSelectionIndicator=YES;//显示选中框
        _myPicker.delegate = self;
        _myPicker.dataSource = self;
    }
    return _myPicker;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
