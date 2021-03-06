//
//  WTRHUD.m
//  Created by wfz on 16/6/23.

#import "WTRHUD.h"
#import "SVIndefiniteAnimatedView2.h"
#import "SVStatusShowView.h"

#define WTRHUDW 84.0  //默认大小
#define WTRHUDH 80.0

#define WTRHUDScale (1/1.2f) //变小好看点

#define WTRHUDMinimumDismissTime 2  //最小显示时间
#define WTRHUDMaximumDismissTime 7 //最大显示时间

@implementation WTRHUD

+(UIView *)bacView:(UIView *)inbacView
{
    UIView *bacView=inbacView;
    if (!bacView) {
        bacView=[UIApplication sharedApplication].delegate.window;
        if (!bacView) {
            for (UIWindow *win in [UIApplication sharedApplication].windows) {
                if (win.isKeyWindow) {
                    bacView=win;
                    break;
                }
            }
            if (!bacView) {
                return nil;
            }
        }
    }
    return bacView;
}

//是否是黑色系的颜色
+(BOOL)isBlackFamilyColor:(UIColor *)incolor
{
    if (!incolor) {
        return NO;
    }
    CGFloat r1,g1,b1,a1;
    [incolor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    if (r1+g1+b1>1.5) {
        return NO;
    }
    return YES;
}

//自动根据bacView的背景颜色选取背景
+(void)showHUDInView:(nullable UIView *)bacView
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIView *inbacView=[self bacView:bacView];
        if ([self isBlackFamilyColor:inbacView.backgroundColor]) {
            [self showHUDWInView:inbacView];
        }else{
            [self showHUDBInView:inbacView];
        }
    }];
}
+(void)showHUDInView:(nullable UIView *)bacView animated:(BOOL)animated size:(CGSize)size
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIView *inbacView=[self bacView:bacView];
        
        if ([self isBlackFamilyColor:inbacView.backgroundColor]) {
            [self showHUDWInView:inbacView animated:animated size:size];
        }else{
            [self showHUDBInView:inbacView animated:animated size:size];
        }
    }];
}
+(void)showSuccessInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIView *inbacView=[self bacView:bacView];
        
        if ([self isBlackFamilyColor:inbacView.backgroundColor]) {
            [self showSuccessWInView:inbacView WithStatus:status];
        }else{
            [self showSuccessBInView:inbacView WithStatus:status];
        }
    }];
}
+(void)showErrorInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIView *inbacView=[self bacView:bacView];
        if ([self isBlackFamilyColor:inbacView.backgroundColor]) {
            [self showErrorWInView:inbacView WithStatus:status];
        }else{
            [self showErrorBInView:inbacView WithStatus:status];
        }
    }];
}
+(void)showInfoInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIView *inbacView=[self bacView:bacView];
        if ([self isBlackFamilyColor:inbacView.backgroundColor]) {
            [self showInfoWInView:inbacView WithStatus:status];
        }else{
            [self showInfoBInView:inbacView WithStatus:status];
        }
    }];
}
+(void)showInfo2InView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIView *inbacView=[self bacView:bacView];
        if ([self isBlackFamilyColor:inbacView.backgroundColor]) {
            [self showInfo2WInView:inbacView WithStatus:status];
        }else{
            [self showInfo2BInView:inbacView WithStatus:status];
        }
    }];
}

#pragma mark HUD部分
+(void)showHUDWInView:(nullable UIView *)bacView
{
    [self showHUDWInView:bacView animated:YES size:CGSizeMake(WTRHUDW, WTRHUDH)];
}
+(void)showHUDWInView:(nullable UIView *)bacView animated:(BOOL)animated size:(CGSize)size
{
    [self showHUDInView:bacView animated:animated IsWhite:YES size:size];
}

+(void)showHUDBInView:(nullable UIView *)bacView
{
    [self showHUDBInView:bacView animated:YES size:CGSizeMake(WTRHUDW, WTRHUDH)];
}
+(void)showHUDBInView:(nullable UIView *)bacView animated:(BOOL)animated size:(CGSize)size
{
    [self showHUDInView:bacView animated:animated IsWhite:NO size:size];
}
+(void)showHUDInView:(nullable UIView *)inbacView animated:(BOOL)animated IsWhite:(BOOL)isw size:(CGSize)size
{
    void (^block)(void)=^{
        UIView *bacView=[self bacView:inbacView];
        
        for (UIView *vv in bacView.subviews) {
            if ([vv isKindOfClass:[SVIndefiniteAnimatedView2 class]]||[vv isKindOfClass:[SVStatusShowView class]]) {
                [vv removeFromSuperview];
            }
        }
        
        SVIndefiniteAnimatedView2 * svv=[[SVIndefiniteAnimatedView2 alloc]initWithFrame:CGRectMake((bacView.bounds.size.width-size.width)/2.0,(bacView.bounds.size.height-size.height)/2.0, size.width, size.height)];
        svv.strokeThickness=2.0;
        svv.radius=24.0;
        svv.layer.cornerRadius=14.0;
        [bacView addSubview:svv];
        svv.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        if (isw) {
            svv.strokeColor=[UIColor blackColor];
            svv.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
        }else{
            svv.strokeColor=[UIColor whiteColor];
            svv.backgroundColor=[UIColor colorWithWhite:0 alpha:0.8];
        }
        
        if (ABS(size.width-WTRHUDW)>10) {
            svv.radius=24.0/WTRHUDW*size.width;
            svv.layer.cornerRadius=14.0/WTRHUDW*size.width;
        }
        
        //变小点 好看
        svv.transform = CGAffineTransformMakeScale(WTRHUDScale, WTRHUDScale);
        
        if (animated) {
            svv.alpha=0.0;
            [UIView animateWithDuration:0.15 animations:^{
                svv.alpha=1.0;
            }];
        }
    };
    
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else{
        [[NSOperationQueue mainQueue] addOperationWithBlock:block];
    }
}


#pragma mark Status部分
+ (void)showSuccessWInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:0 InView:bacView status:status IsWhite:YES];
}
+ (void)showErrorWInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:1 InView:bacView status:status IsWhite:YES];
}
+ (void)showInfoWInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:-1 InView:bacView status:status IsWhite:YES];
}
+ (void)showInfo2WInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:2 InView:bacView status:status IsWhite:YES];
}
+ (void)showSuccessBInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:0 InView:bacView status:status IsWhite:NO];
}
+ (void)showErrorBInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:1 InView:bacView status:status IsWhite:NO];
}
+ (void)showInfoBInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:-1 InView:bacView status:status IsWhite:NO];
}
+ (void)showInfo2BInView:(nullable UIView *)bacView WithStatus:(NSString*)status
{
    [self showType:2 InView:bacView status:status IsWhite:NO];
}
+ (void)showType:(int)type InView:(nullable UIView *)bacView status:(NSString*)status IsWhite:(BOOL)isw
{
    if (!status||![status isKindOfClass:[NSString class]]) {
        status=@"";
    }
    CGFloat minimum = MAX(status.length * 0.06 + 0.5,WTRHUDMinimumDismissTime);
    minimum=MIN(minimum, WTRHUDMaximumDismissTime);

    [self showType:type InView:bacView status:status duration:minimum animated:YES IsWhite:isw];
}
+ (void)showType:(int)type InView:(nullable UIView *)bacView status:(NSString*)status duration:(NSTimeInterval)duration animated:(BOOL)animated IsWhite:(BOOL)isw
{
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"WTR")];
    NSURL *url = [bundle URLForResource:@"WTRBundle" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];

    UIImage *image=nil;
    switch (type) {
        case 0:
        {
            image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"success" ofType:@"png"]];
        }
            break;
        case 1:
        {
            image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"error" ofType:@"png"]];
        }
            break;
        case 2:
        {
             image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"info" ofType:@"png"]];
        }
            break;
        default:
            image = nil;
            break;
    }

    [self showImage:image status:status duration:duration InView:bacView animated:animated IsWhite:isw];
}

+(void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration InView:(nullable UIView *)bacView animated:(BOOL)animated IsWhite:(BOOL)isw;
{
    [self showImage:image bgColor:(isw?[UIColor colorWithWhite:1 alpha:0.8]:[UIColor colorWithWhite:0 alpha:0.8]) status:status font:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] tintColor:(isw?[UIColor blackColor]:[UIColor whiteColor]) textImageSpace:8 boundingRectSize:CGSizeMake(200.0f, 300.0f) edge:UIEdgeInsetsMake(12, 12, 12, 12) cornerRadius:(image?14.0:5.0) duration:duration animated:animated InView:bacView];
}
+(void)showImage:(nullable UIImage*)image bgColor:(UIColor *)bgColor status:(nullable NSString*)status font:(UIFont *)font tintColor:(UIColor *)tintColor textImageSpace:(CGFloat)textImageSpace boundingRectSize:(CGSize)bsize edge:(UIEdgeInsets)edge cornerRadius:(CGFloat)cornerRadius duration:(NSTimeInterval)duration animated:(BOOL)animated InView:(nullable UIView *)inbacView
{
    void (^block)(void)=^{
        
        UIView *bacView=[self bacView:inbacView];
        
        for (UIView *vv in bacView.subviews) {
            if ([vv isKindOfClass:[SVIndefiniteAnimatedView2 class]]||[vv isKindOfClass:[SVStatusShowView class]]) {
                [vv removeFromSuperview];
            }
        }

        SVStatusShowView * svv=[[SVStatusShowView alloc]initWithImage:image bgColor:bgColor status:status font:font tintColor:tintColor textImageSpace:textImageSpace boundingRectSize:bsize edge:edge cornerRadius:cornerRadius];

        [bacView addSubview:svv];
        svv.center=CGPointMake(bacView.frame.size.width/2.0, bacView.frame.size.height/2.0);
        svv.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        //变小点 好看
        if (image) {
            svv.transform = CGAffineTransformMakeScale(WTRHUDScale, WTRHUDScale);
        }
        
        if (animated) {
            svv.alpha=0.0;
            [UIView animateWithDuration:0.15 animations:^{
                svv.alpha=1.0;
            } completion:^(BOOL finished) {
                [svv performSelector:@selector(dismissWithAnimated:) withObject:@(animated) afterDelay:duration];
            }];
        }else{
            [svv performSelector:@selector(dismissWithAnimated:) withObject:@(animated) afterDelay:duration];
        }
    };
    
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else{
        [[NSOperationQueue mainQueue] addOperationWithBlock:block];
    }
}

#pragma mark 取消
+(void)dismissInView:(nullable UIView *)bacView
{
    [self dismissInView:bacView animated:YES];
}
+(void)dismissInView:(nullable UIView *)inbacView animated:(BOOL)animated
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

        UIView *bacView=[self bacView:inbacView];
        
        UIView * svv=nil;
        for (UIView *vv in bacView.subviews) {
            if ([vv isKindOfClass:[SVIndefiniteAnimatedView2 class]]||[vv isKindOfClass:[SVStatusShowView class]]) {
                svv=vv;
                break;
            }
        }
        if (!svv) {
            return;
        }
        if (animated) {
            [UIView animateWithDuration:0.15 animations:^{
                svv.alpha=0.0;
            } completion:^(BOOL finished) {
                [svv removeFromSuperview];
            }];
        }
        else
            [svv removeFromSuperview];
    }];
}


@end
