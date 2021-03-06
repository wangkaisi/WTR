//
//  ViewController.m
//  WTRGitCs
//
//  Created by wfz on 2017/5/23.
//  Copyright © 2017年 wfz. All rights reserved.
//

#import "ViewController.h"
#import "WTRDefine.h"
#import "NSObject+WTRExtension.h"
#import "UIImage+WTRManager.h"

@interface ONECS : NSObject

@property(nonatomic,copy)NSString *onen;

@property(nonatomic,copy)NSString *onew;

@property(nonatomic,strong)NSArray *arr1;
@property(nonatomic,strong)NSMutableArray *arr2;

@end

@implementation ONECS

+(NSDictionary *)WTR_objectClassInArray
{
    return @{@"arr1":@"ONECS",@"arr2":@"ONECS"};
}

@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController
{
    UIImageView *imv;
    NSArray *nameArray;

    UILabel *showla;
}
-(void)testhud
{
//    UIImage *im=[UIImage QRCodeImageWithStr:@"https://apps.apple.com/cn/app/id1483002652" size:CGSizeMake(500, 500)];
//    
//    NSString *impath=[[WTRFilePath getDocumentPath] stringByAppendingPathComponent:@"zwwh.png"];
//    [[NSFileManager defaultManager] removeItemAtPath:impath error:nil];
//    [UIImagePNGRepresentation(im) writeToFile:impath atomically:YES];
//    NSLog(@"%@",impath);
    
    self.view.backgroundColor=RANDCOLOR;
    
    [WTRHUD showHUDInView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WTRHUD showSuccessInView:self.view WithStatus:@"登录成功"];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self testhud];

//    imv=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Users/wfz/Desktop/asd.png"]];
//    [self.view addSubview:imv];

    
//    if (ISIPhoneX) {
//        NSLog(@"呵呵呵");
//    }
//    nameArray=@[@"图片选取剪切"];
//
//    UITableView *tablev=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tablev.dataSource=self;
//    tablev.delegate=self;
//    [self.view addSubview:tablev];
//
//    tablev.contentInset=UIEdgeInsetsMake(ISIPhoneX?44:20, 0, ISIPhoneX?40:20, 0);
//
//    [tablev registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];


//    UIImage *img=[UIImage imageWithColor:RANDCOLOR size:CGSizeMake(100, 100)];
//    img=[img WTR_imageWithTintColor:[UIColor redColor]];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:img];
//
//    showla=[[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    showla.textColor=[UIColor redColor];
//    [self.view addSubview:showla];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self testhud];
    
//    [WTRHUD showInfoBInView:self.view WithStatus:@"提示信息哈"];
//    [WTR clearAllCaches];
    
//    [WTRHUD showErrorBInView:self.view WithStatus:@"asda"];
    
//    imv.center=CGPointMake(arc4random()%100/100.0*self.view.frame.size.width, arc4random()%100/100.0*self.view.frame.size.height);

//    [WTRHUD showHUDWInView:self.view];

//    if (arc4random()%2) {
//        [WTRHUD showSuccessWInView:self.view WithStatus:@"呵呵呵提示信息哈"];
//    }else{
//        [WTRHUD showErrorBInView:self.view WithStatus:@"错误提示"];
//    }

//    40

    //44
//    NSLog(@"%.2f",[UIApplication sharedApplication].keyWindow.safeAreaInsets.top);


//    showla.text=[NSString stringWithFormat:@"%.2f",[UIApplication sharedApplication].keyWindow.safeAreaInsets.top];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text=nameArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            {

            }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
