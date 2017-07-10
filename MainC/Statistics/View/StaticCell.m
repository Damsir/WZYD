//
//  StaticCell.m
//  XAYD
//
//  Created by songdan Ye on 16/5/9.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "StaticCell.h"
//#import "ZFChart.h"

@interface StaticCell (){
    NSIndexPath *path;
}
@end

@implementation StaticCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)configUI:(NSIndexPath *)indexPath {
       path = indexPath;
    [self creat];

    
    
   }


- (void)creat{
    CGFloat w =0;
    if (MainR.size.width>414) {
        w =MainR.size.width  - 40;
    }
    else
    {
        w = MainR.size.width;
    }
    ZFLineChart * lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(10, 0, w, 300)];
    lineChart.dataSource = self;
    lineChart.delegate = self;

    lineChart.unit = @"件";
    lineChart.unitColor =  [UIColor blackColor];
    if(path.section == 0)
    {
    lineChart.topic = @"收件";
    }
    if(path.section == 1)
    {
        lineChart.topic = @"发件";
    }
    if (path.section == 2) {
        lineChart.topic = @"退件";
    }
    
    
    lineChart.topicColor = [UIColor darkGrayColor];
    //是否显示分割线
    lineChart.isShowSeparate = YES;
    
    //设置分割线颜色
    lineChart.separateColor = RGB(238, 238, 238);
    //显示是否需要动画
//        lineChart.isAnimated = NO;
    //重画最小值
    lineChart.isResetYLineMinValue = YES;
    //是否显示对应的值
//        lineChart.isShowXLineValue = NO;
    //是否添加边框阴影
        lineChart.isShadowForValueLabel = NO;
    //画线是否需要阴影
    lineChart.isShadow = NO;
    //值边框样式
        lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    //图表上valueLabel中心点到对应圆的中心点的距离
//        lineChart.valueCenterToCircleCenterPadding = 10;
    lineChart.unitColor = [UIColor lightGrayColor];
    lineChart.backgroundColor = [UIColor whiteColor];
    lineChart.axisColor = RGB(238, 238, 238);
    lineChart.xLineNameColor = [UIColor darkGrayColor];
    lineChart.yLineValueColor = [UIColor darkGrayColor];
    lineChart.xLineNameLabelToXAxisLinePadding = 15;
    
    _lineChart =lineChart;
    [self addSubview:_lineChart];
    [lineChart strokePath];


}


#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    
    if(path.section ==0)
    {
        return _array0;
    }
    else if(path.section==1)
    {
    
        return _array1;
    }
    else
    {
        return _array2;

    }

}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return _timeArr;
//  @[@"15-12", @"16-01", @"16-02", @"16-03", @"16-04", @"16-05"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    if(path.section ==0)
    {
        //绿
        return @[[UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]];
    }
    else if(path.section==1)
    {
        //蓝
        return @[[UIColor colorWithRed:82.0/255.0 green:116.0/255.0 blue:188.0/255.0 alpha:1.0f]];
    }
    else
    {
        //红
        return @[[UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f]];
        
    }
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    
    if(path.section ==0)
    {
        return [self getMaxwithArray:_array0];
    }
    else if(path.section==1)
    {
        
        return [self getMaxwithArray:_array1];
    }
    else
    {
        return [self getMaxwithArray:_array2];
        
    }

}


- (int)getMaxwithArray:(NSArray *)array
{
    int maxinter=0;
    int t;
    for (NSString *obj in array) {
       t=[obj intValue];
        if (maxinter <t) {
            maxinter = t;
        }
        
    }
    
    return maxinter+15;
}

- (int)getMinwithArray:(NSArray *)array
{
    int mininter=0;
    int t;
    for (NSString *obj in array) {
        t=[obj intValue];
        if (mininter >t) {
            mininter = t;
        }
        
    }
    
    return mininter-15;
}

- (CGFloat)yLineMinValueInGenericChart:(ZFGenericChart *)chart{
    if(path.section ==0)
    {
        return [self getMinwithArray:_array0];
    }
    else if(path.section==1)
    {
        
        return [self getMinwithArray:_array1];
    }
    else
    {
        return [self getMinwithArray:_array2];
        
    }}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 6;
}

#pragma mark - ZFLineChartDelegate
//组宽
- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
    
//    return (MainR.size.width-155)/9.0;
    return (MainR.size.width-20)/7.0;

}
//组间距
- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
    return 0.f;
}

//原点半径
- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
    return 3.f;
}

//线宽
- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
    return 1.f;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"+++%ld第%ld个", (long)lineIndex,(long)circleIndex);
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    NSLog(@"---%ld第%ld个" ,(long)lineIndex,(long)circleIndex);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineChart.frame =CGRectMake(0, 0, MainR.size.width, 300);

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
