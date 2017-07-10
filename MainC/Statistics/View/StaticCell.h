//
//  StaticCell.h
//  XAYD
//
//  Created by songdan Ye on 16/5/9.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFChart.h"
@interface StaticCell : UITableViewCell<ZFGenericChartDataSource,ZFLineChartDelegate>


//@property (nonatomic,weak) id<ZFGenericChartDataSource>dataSource;
//@property (nonatomic,weak) id <ZFLineChartDelegate>delegate;


@property (nonatomic,strong)ZFLineChart * lineChart;

@property (nonatomic,strong)NSArray *array0;
@property (nonatomic,strong)NSArray *array1;
@property (nonatomic,strong)NSArray *array2;
@property (nonatomic,strong)NSArray *timeArr;



- (void)configUI:(NSIndexPath *)indexPath;

@end
