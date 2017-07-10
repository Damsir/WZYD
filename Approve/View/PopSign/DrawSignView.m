//
//  DrawSignView.m
//  popSign
//
//  Created by 吴定如 on 16/7/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DrawSignView.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SYSTEMFONT(x) [UIFont systemFontOfSize:(x)]

@interface DrawSignView ()

@property (strong,nonatomic)  MyView *drawView;
@property (assign,nonatomic)  BOOL buttonHidden;
@property (assign,nonatomic)  BOOL widthHidden;

@end


//保存线条颜色
static NSMutableArray *colors;


@implementation DrawSignView{
    
    UILabel *contentLbl;
    UIButton *redoBtn;//撤销
    UIButton *undoBtn;//恢复
    UIButton *clearBtn;//清空
    UIButton *colorBtn;//颜色
    UIButton *screenBtn;//截屏
    UIButton *widthBtn;//高度
    UIButton *okBtn;//确定并截图返回
    UIButton *cancelBtn;//取消
    
    UISlider *penBoldSlider;
    
    //    MyView *drawView;//画图的界面，宽高3:1
    
}

@synthesize signCallBackBlock,cancelBlock;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)createView
{
    CGFloat backView_w = MainR.size.width - 20;
    CGFloat backView_h = 0.33 * backView_w + 140;
    CGFloat btn_x = 10;
    CGFloat btn_y = 100;
    CGFloat btn_w = (MainR.size.width - 60)/3;
    CGFloat btn_h = 40;
    //CGFloat btn_mid = 5;
    
    
   
    //self
    self.frame = CGRectMake(0, 0, backView_w , backView_h);
    //self.backgroundColor = [UIColor colorWithRed:59./255. green:73./255. blue:82./255. alpha:1];
    [self setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    //[self setBackgroundColor:RGBCOLOR(110, 220, 220)];
    //self.backgroundColor = [UIColor orangeColor];
    CALayer *layer = self.layer;
    [layer setCornerRadius:15.0];
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.borderWidth = 1;
    
    //contentLbl
    contentLbl = [[UILabel alloc]init];
    contentLbl.text = @"请在白色区域内签字";
    contentLbl.textAlignment = NSTextAlignmentCenter;
    contentLbl.textColor = [UIColor blackColor];
    contentLbl.frame = CGRectMake(0, 10, backView_w, 40);
    contentLbl.font = [UIFont systemFontOfSize:22.0];
    contentLbl.backgroundColor = [UIColor clearColor];
    [self addSubview:contentLbl];
    
    
    //btns
    //okBtn
    okBtn = [[UIButton alloc]init];
    [self renderBtn:okBtn];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [okBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    //cancelBtn
    cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self renderBtn:cancelBtn];
    //    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    //clearBtn
    clearBtn = [[UIButton alloc]init];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        clearBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [self renderBtn:clearBtn];
    [clearBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
    
    okBtn.frame = CGRectMake(10, backView_h - 60, btn_w, btn_h);
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(okBtn.frame)+10, okBtn.frame.origin.y, btn_w, btn_h);
    clearBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame)+10, okBtn.frame.origin.y, btn_w, btn_h);
    //
    colors=[[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor whiteColor], nil];
    self.buttonHidden=YES;
    self.widthHidden=YES;
    //画板
    self.drawView=[[MyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLbl.frame)+10, backView_w , backView_h - 140)];
    //[self.drawView setBackgroundColor:RGBCOLOR(101, 129, 90)];
    self.drawView.backgroundColor = [UIColor whiteColor];
    [self addSubview: self.drawView];
    [self sendSubviewToBack:self.drawView];
    
//    redoBtn = [[UIButton alloc]init];
//    [self renderBtn:redoBtn];
//    [redoBtn setTitle:@"撤销" forState:UIControlStateNormal];
//    redoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
//    [self addSubview:redoBtn];
//    [redoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    //undoBtn
//    undoBtn = [[UIButton alloc]init];
//    [self renderBtn:undoBtn];
//    [undoBtn setTitle:@"恢复" forState:UIControlStateNormal];
//    undoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
//     [self addSubview:undoBtn];
//    [undoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];


    
    
    
    //    NSMutableArray *btnLArr = [[NSMutableArray alloc]init];
    //    NSMutableArray *btnRArr = [[NSMutableArray alloc]init];
    //    //统一设坐标
    //    [btnLArr addObject:redoBtn];
    //    [btnLArr addObject:undoBtn];
    //    [btnLArr addObject:clearBtn];
    //    [btnRArr addObject:okBtn];
    //    [btnRArr addObject:cancelBtn];
    
    //    int i = 0;
    //    for (UIButton *btn in btnLArr) {
    //        btn.frame = CGRectMake(10, btn_y+ i * (btn_h+btn_mid), btn_w, btn_h);
    //        i++;
    //    }
    //    i = 0;
    //    for (UIButton *btn in btnRArr) {
    //        btn.frame = CGRectMake(210, btn_y+ i * (btn_h+btn_mid), btn_w, btn_h);
    //        i++;
    //    }
    //

    
    
    //sliderLbl
//    UILabel *sliderLbl = [[UILabel alloc]init];
//    sliderLbl.text = @"笔触粗细:";
//    sliderLbl.textAlignment = NSTextAlignmentRight;
//    sliderLbl.textColor = [UIColor whiteColor];
//    sliderLbl.frame = CGRectMake(100, 200, 100, 20);
//    sliderLbl.font = [UIFont systemFontOfSize:18.0];
//    sliderLbl.backgroundColor = [UIColor clearColor];
//    [self addSubview:sliderLbl];
    
    //penBoldSlider
//    penBoldSlider = [[UISlider alloc]init];
//    penBoldSlider.frame = CGRectMake(200+10, 200, 200, 20);
//    penBoldSlider.minimumValue = 0;
//    penBoldSlider.maximumValue = 9;
//    penBoldSlider.value = 0;
//    [penBoldSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
//    [self addSubview:penBoldSlider];
    
    
}
//横竖屏
-(void)screenRotationChangeFrame
{
    CGFloat backView_w = MainR.size.width - 20;
    CGFloat backView_h = 0.33 * backView_w + 140;
    CGFloat btn_w = (MainR.size.width - 60)/3;
    CGFloat btn_h = 40;
    contentLbl.frame = CGRectMake(0, 10, backView_w, 40);
    okBtn.frame = CGRectMake(10, backView_h - 60, btn_w, btn_h);
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(okBtn.frame)+10, okBtn.frame.origin.y, btn_w, btn_h);
    clearBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame)+10, okBtn.frame.origin.y, btn_w, btn_h);
    self.drawView.frame = CGRectMake(0, CGRectGetMaxY(contentLbl.frame)+10, backView_w , backView_h - 140);
}


-(void)changeColors:(id)sender{
    
    if (self.buttonHidden==YES) {
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.buttonHidden=NO;
        }
    }else{
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
    }
}

-(void)changeWidth:(id)sender{
    
    if (self.widthHidden==YES) {
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=NO;
            self.widthHidden=NO;
        }
    }else{
        for (int i=11; i<15; i++) {
            UIButton *button=(UIButton *)[self viewWithTag:i];
            button.hidden=YES;
            self.widthHidden=YES;
        }
        
    }
    
}
- (void)widthSet:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    [self.drawView setlineWidth:button.tag-10];
}

- (UIImage *)saveScreen{
    
    UIView *screenView = self.drawView;
    
    for (int i=1; i<16;i++) {
        UIView *view=[self viewWithTag:i];
        if ((i>=1&&i<=5)||(i>=10&&i<=15)) {
            if (view.hidden==YES) {
                continue;
            }
        }
        view.hidden=YES;
        if(i>=1&&i<=5){
            self.buttonHidden=YES;
        }
        if(i>=10&&i<=15){
            self.widthHidden=YES;
        }
    }
    UIGraphicsBeginImageContext(screenView.bounds.size);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    UIImageWriteToSavedPhotosAlbum(image, screenView, nil, nil);
    //    for (int i=1;i<16;i++) {
    //        if ((i>=1&&i<=5)||(i>=11&&i<=14)) {
    //            continue;
    //        }
    //        UIView *view=[self viewWithTag:i];
    //        view.hidden=NO;
    //    }
    NSLog(@"截屏成功");
    image = [DrawSignView imageToTransparent:image];
    return image;
}

- (void)colorSet:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    [self.drawView setLineColor:button.tag-1];
    colorBtn.backgroundColor=[colors objectAtIndex:button.tag-1];
}

/** 封装的按钮事件 */
-(void)btnAction:(id)sender{
    if (sender == cancelBtn) {
        cancelBlock();
        [self.drawView clear];
    }else if (sender == okBtn){
        signCallBackBlock([self saveScreen]);
        [self.drawView clear];
    }else if (sender == redoBtn){
        [ self.drawView revocation];
    }else if(sender == undoBtn){
        [ self.drawView refrom];
    }else if(sender == clearBtn){
        [self.drawView clear];
    }
}


/** 笔触粗细 */
-(void)updateValue:(id)sender{
    if (sender == penBoldSlider) {
        CGFloat f = penBoldSlider.value;
        NSLog(@"%f",f);
        NSInteger w = (int)ceilf(f);
        [self.drawView setlineWidth:w];
    }
}

/** 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

//颜色替换
+ (UIImage *)imageToTransparent:(UIImage*)image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t    bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        
        //把绿色变成黑色，把背景色变成透明
        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        else if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}


-(void)renderBtn:(UIButton *)btn{
    //[UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0]
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(34,152,239)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageFromColor:RGBCOLOR(169,183,192)]
                   forState:UIControlStateHighlighted];
    //double dRadius = 5.0f;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //CornerRadius/Border
    //[btn.layer setCornerRadius:dRadius];
    //[btn.layer setBorderWidth:1.0f];
    //btn.clipsToBounds = YES;
   // [btn.layer setBorderColor:RGBCOLOR(255, 255, 255).CGColor];
   // [btn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    
}

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
