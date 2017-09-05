//
//  ViewController.m
//  AspectsCount
//
//  Created by Mr.GCY on 2017/9/5.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)enterFirstVC:(UIButton *)sender {
    [self jumpVC:@"AOPFirstViewController"];
}
- (IBAction)enterSecondVC:(UIButton *)sender {
    [self jumpVC:@"AOPSecondViewController"];
}
- (IBAction)enterThirdVC:(UIButton *)sender {
    [self jumpVC:@"AOPThirdViewController"];
}
- (IBAction)enterFourthVC:(UIButton *)sender {
    [self jumpVC:@"AOPFourthViewController"];
}
-(void)jumpVC:(NSString *)className{
    Class cls = NSClassFromString(className);
    UIViewController * vc = [[cls alloc] init];
    vc.title = className;
    vc.view.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
