//
//  MeetingInfomationVC.m
//  HAYD
//
//  Created by 吴定如 on 16/9/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingInfomationVC.h"
#import "BGTopSilderBar.h"
#import "MyGlobal.h"
#import "MeetingMaterialVC.h"
#import "MeetingBaseVC.h"

@interface MeetingInfomationVC ()

@property(nonatomic,strong) BGTopSilderBar *silderBar;
@property(nonatomic,strong)MeetingBaseVC *baseVC;
@property(nonatomic,strong)MeetingMaterialVC *materialVC;

@end

@implementation MeetingInfomationVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化顶部BGTopSilderBar
    [self initSilderBar];
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)screenRotation
{
    _silderBar.frame= CGRectMake(0,0,MainR.size.width, MainR.size.height-64);
    [_silderBar screenRotation];
    [_baseVC screenRotation];
    [_materialVC screenRotation];
}
/**
 初始化BGTopSilderBar
 */
-(void)initSilderBar{
    
    _baseVC = [[MeetingBaseVC alloc] init];
    [_baseVC transFromMeetingId:_meetingId];
    _baseVC.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    _materialVC = [[MeetingMaterialVC alloc] init];
    [_materialVC transFromMeetingId:_meetingId];
    _materialVC.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    NSArray *viewsArray = @[_baseVC.view,_materialVC.view];
    NSArray *titlesArray = @[@"基本信息",@"会议材料"];
    
    BGTopSilderBar *silder = [[BGTopSilderBar alloc] initWithFrame:CGRectMake(0,0,MainR.size.width, MainR.size.height-64) WithControllerViewArray:viewsArray AndWithTitlesArray:titlesArray];
    silder.backgroundColor = [UIColor whiteColor];
    _silderBar = silder;
    [self.view addSubview:silder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
