//
//  MyPickView.m
//  ZhouDao
//
//  Created by cqz on 16/3/5.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MyPickView.h"
#import "NSString+SPStr.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"

#define VIEWWITH   [UIScreen mainScreen].bounds.size.width/3.f

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
@interface MyPickView() <UIPickerViewDataSource, UIPickerViewDelegate> {
    
}
@property (strong, nonatomic)  UIPickerView *myPicker;
@property (strong, nonatomic)  UIView *pickerBgView;

//data
@property (strong, nonatomic) NSMutableArray *provinceModelArray;
@property (strong, nonatomic) ProvinceModel  *proModel;//省
@property (strong, nonatomic) NSMutableArray *cityModelArray;
@property (strong, nonatomic) NSMutableArray *areaModelArray;

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
    
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"provincescity.plist"];
    NSDictionary *bigDoctionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *proArrays = bigDoctionary[@"province"];

    [proArrays enumerateObjectsUsingBlock:^(NSDictionary *proDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ProvinceModel *proModel = [[ProvinceModel alloc] initWithDictionary:proDictionary];
        [weakSelf.provinceModelArray addObject:proModel];
        DLog(@"打印数组---- %ld",[proModel.city count]);
        if (idx == 0) {
            weakSelf.proModel = proModel;
            weakSelf.cityModelArray = proModel.city;
            if ([weakSelf.cityModelArray count] >0) {
                
                CityModel *cityModel = weakSelf.cityModelArray[0];
                weakSelf.areaModelArray = cityModel.area;
            }
        }
    }];

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
    
    if ([PublicFunction ShareInstance].m_user.data.address.length >0) {
        
        NSArray *addressArrays = [[PublicFunction ShareInstance].m_user.data.address componentsSeparatedByString:@"-"];
        NSString *provinceString = (addressArrays.count >0) ? addressArrays[0] : @"";
        NSString *cityString = (addressArrays.count >1) ?addressArrays[1] : @"";
        NSString *areaString = (addressArrays.count >2) ?addressArrays[2] : @"";
        
        //获取默认地区 选择到响应的pickview
        for (NSUInteger i = 0; i < [weakSelf.provinceModelArray count]; i++) {
            
            ProvinceModel *proModel = _provinceModelArray[i];
            if ([proModel.name isEqualToString:provinceString]) {
                _proModel = proModel;
                self.cityModelArray = proModel.city;
                kDISPATCH_MAIN_THREAD(^{
                    
                    [weakSelf.myPicker selectRow:i inComponent:0 animated:NO];
                });
                if ([_cityModelArray count] > 0) {
                    
                    for (NSUInteger ii = 0; ii < [_cityModelArray count]; ii++) {
                        
                        CityModel *cityModel = _cityModelArray[ii];
                        self.areaModelArray = cityModel.area;
                        
                        if ([cityModel.name isEqualToString:cityString]) {
                            
                            kDISPATCH_MAIN_THREAD(^{
                                
                                [weakSelf.myPicker selectRow:ii inComponent:1 animated:NO];
                            });
                            
                            if ([_areaModelArray count] > 0) {
                                
                                for (NSUInteger iii = 0; iii <[_areaModelArray count]; iii++) {
                                    
                                    AreaModel *areaModel = _areaModelArray[iii];
                                    if ([areaModel.name isEqualToString:areaString]) {
                                        
                                        kDISPATCH_MAIN_THREAD(^{
                                            
                                            [weakSelf.myPicker selectRow:iii inComponent:2 animated:NO];
                                        });
                                        break;
                                    }
                                }
                                
                            }
                            
                            break;
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
        
        return [_provinceModelArray count];
    } else if (component == 1) {
        
        return [_cityModelArray count];
    }
    return [_areaModelArray count];
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
        
        self.proModel = _provinceModelArray[row];
        if ([_proModel.city count] > 0) {
            
            self.cityModelArray = _proModel.city;
            if (_cityModelArray.count >0) {
                
                CityModel *cityModel = _cityModelArray[0];
                if ([cityModel.area count] > 0) {
                    
                    self.areaModelArray = cityModel.area;
                } else {
                    [self.areaModelArray removeAllObjects];
                }
            } else {
                [self.cityModelArray removeAllObjects];
            }
        } else {
            [self.cityModelArray removeAllObjects];
            [self.areaModelArray removeAllObjects];
        }
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    if (component == 1) {
        kDISPATCH_MAIN_THREAD(^{
            
            CityModel *cityModel = _cityModelArray[row];
            if ([cityModel.area count] > 0) {
                self.areaModelArray = cityModel.area;
            } else {
                [self.areaModelArray removeAllObjects];
            }
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        });
    }
}
/************************重头戏来了************************/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEWWITH, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        ProvinceModel *provinceModel = _provinceModelArray[row];
        myView.text = provinceModel.name;
        myView.text.length>7?[myView setFont:Font_12]:[myView setFont:Font_14];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else if (component == 1){
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEWWITH, 30)];
        
        CityModel *cityModel = _cityModelArray[row];
        myView.text = cityModel.name;
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text.length>7?[myView setFont:[UIFont systemFontOfSize:10]]:[myView setFont:Font_14];
        myView.backgroundColor = [UIColor clearColor];
        
    }else{
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEWWITH, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        AreaModel *areaModel = _areaModelArray[row];
        myView.text = areaModel.name;
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
    
    NSString *str1 = _proModel.name;
    CityModel *citymModel = _cityModelArray[[self.myPicker selectedRowInComponent:1]];
    NSString *str2 = citymModel.name;
    AreaModel *areaModel = _areaModelArray[[self.myPicker selectedRowInComponent:2]];
    NSString *str3 = areaModel.name;
    DLog(@"打印出code：%@-%@-%@",_proModel.id,citymModel.id,areaModel.id);
    if (self.pickBlock) {
        
        self.pickBlock(str1,str2,str3);
    }
    
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
- (NSMutableArray *)provinceModelArray {
    
    if (!_provinceModelArray) {
        
        _provinceModelArray = [NSMutableArray array];
    }
    return _provinceModelArray;
}
- (NSMutableArray *)cityModelArray {
    
    if (!_cityModelArray) {
        
        _cityModelArray = [NSMutableArray array];
    }
    return _cityModelArray;
}
- (NSMutableArray *)areaModelArray {
    
    if (!_areaModelArray) {
        
        _areaModelArray = [NSMutableArray array];
    }
    return _areaModelArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
