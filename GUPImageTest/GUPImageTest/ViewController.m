//
//  ViewController.m
//  GUPImageTest
//
//  Created by user on 2018/5/14.
//  Copyright © 2018年 Dnake. All rights reserved.
//

#import "ViewController.h"

#import "TableViewCell.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *listArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listArray = @[@{@"title":@"定一个三角形",@"type":@"1"},
                   @{@"title":@"封装OpenGL定一个三角形",@"type":@"2"},
                   @{@"title":@"纹理贴图",@"type":@"3"}];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _listArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"gotoGLKViewController" sender:nil];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"gotoOpenGL_ch2_3" sender:nil];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"gotoSIBIANXING" sender:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
