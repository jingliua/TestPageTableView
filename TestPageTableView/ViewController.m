//
//  ViewController.m
//  TestPageTableView
//
//  Created by liujing on 8/18/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#define pullRefreshLabelHeight 50


@interface ViewController ()
{
    NSMutableArray  *dataAry;           //数据源cell显示之用
    BOOL            isRequest;          //是否正在请求
    int             dataCount;          //数据的总条数,此例子中为20,分4页返回
    NSInteger       indexPage;          //页数
    
    
    //上下拉刷新
    UIView                      *refreshView;//push的refreshView
    UIActivityIndicatorView     *activityView;//push的activityView
    UILabel                     *labRefreshText;//push的refresh label

    UIActivityIndicatorView     *headerActivityView;//pull的activityView
    UILabel                     *labHeader;//pull的refresh label
    
    BOOL        isRefresh;//正在刷新

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor greenColor];
    
    dataAry = [NSMutableArray array];
    isRequest=NO;
    
    UIView *refreshViewHeader =[self RefreshViewHeader];
    [self.tableView addSubview:refreshViewHeader];
}

#pragma mark - 给tableView添加下拉刷新的头(包括一个label和一个UIActivityIndicatorView)
-(UIView *)RefreshViewHeader{

    UIView* refreshViewHeader = [[UIView alloc]init];
    refreshViewHeader.backgroundColor = [UIColor clearColor];
    refreshViewHeader.frame = CGRectMake(0,-pullRefreshLabelHeight,self.view.frame.size.width,pullRefreshLabelHeight);
    refreshViewHeader.backgroundColor = [UIColor orangeColor];

    headerActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    headerActivityView.frame = CGRectMake(40,(pullRefreshLabelHeight-30)/2,30,30);
    [headerActivityView stopAnimating];
    headerActivityView.hidden = YES;
    [refreshViewHeader addSubview:headerActivityView];
    
    labHeader = [[UILabel alloc]init];
    labHeader.backgroundColor = [UIColor clearColor];
    labHeader.frame = CGRectMake(0,0,refreshViewHeader.frame.size.width,refreshViewHeader.frame.size.height);
    labHeader.font = [UIFont systemFontOfSize:12];
    labHeader.textColor = [UIColor redColor];
    labHeader.textAlignment = NSTextAlignmentCenter;
    [refreshViewHeader addSubview:labHeader];
    
    return refreshViewHeader;
    
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell =(CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCellid" forIndexPath:indexPath];
    NSDictionary *dic = dataAry[indexPath.row];
    cell.titleLabel.text = dic[@"title"];
//    cell.contentView.backgroundColor = [UIColor brownColor];
    return cell;
}

#pragma mark - 发送请求
- (void)serverRequest:(BOOL)isPull{//pull的话indexPage=0 第一页
    //这边应该加上如果没有网络，提示检查网络放在tableview的footerview那里提示
    if (!isPull) {
        self.tableView.tableFooterView = [self startActivity:YES message:@"数据读取中,请稍等..."];
    }
    if (isRequest) {
        return;
    }
    isRequest = YES;
    //正常下面应该是发服务（这里为了简单测试直接调用），成功调用requestComplete，失败调用requestFailed
    [self performSelector:@selector(requestComplete) withObject:nil afterDelay:2 ];
    
}

#pragma mark - 请求成功或者失败
-(void)requestComplete
{
    isRefresh = NO;
    [headerActivityView stopAnimating];
    
    NSString *titleValue = [NSString stringWithFormat:@"title%li",5*indexPage];
    NSString *titleValue1 = [NSString stringWithFormat:@"title%li",5*indexPage+1];
    NSString *titleValue2 = [NSString stringWithFormat:@"title%li",5*indexPage+2];
    NSString *titleValue3 = [NSString stringWithFormat:@"title%li",5*indexPage+3];
    NSString *titleValue4 = [NSString stringWithFormat:@"title%li",5*indexPage+4];
    
    NSDictionary *dic =@{@"title":titleValue};
    NSDictionary *dic1 =@{@"title":titleValue1};
    NSDictionary *dic2 =@{@"title":titleValue2};
    NSDictionary *dic3 =@{@"title":titleValue3};
    NSDictionary *dic4 =@{@"title":titleValue4};
    NSArray *arr = @[dic,dic1,dic2,dic3,dic4];
    
    dataCount = 20;//正常这里应该赋值为服务端返回的字段，服务端需要一个字段告诉客户端总共多少条数据
    if (indexPage == 0&&dataAry.count > 0) {
        [dataAry removeAllObjects];
    }
    [dataAry addObjectsFromArray:arr];
    [self.tableView reloadData];
    indexPage++;
    
    if (dataAry.count >= dataCount) {//当所有数据已经分几页拉完了
        self.tableView.tableFooterView = [self startActivity:NO message:@"没有更多数据了"];
    }else if (dataCount == 0){
        self.tableView.tableFooterView = [self startActivity:NO message:@"目前没有数据"];
    }else{
        self.tableView.tableFooterView = nil;
    }
    isRequest = NO;
    [self closePull];
}


-(void)requestFailed
{
    isRefresh = NO;
    [headerActivityView stopAnimating];

    self.tableView.tableFooterView = nil;
    
    isRequest = NO;
    [self closePull];
}

#pragma mark - 给tableView添加上拉刷新的footer
- (UIView *)startActivity:(BOOL)isAnimating message:(NSString *)message{
    if (!refreshView) {
        refreshView = [[UIView alloc]init];
        refreshView.backgroundColor = [UIColor clearColor];
        refreshView.frame = CGRectMake(0,0,self.view.frame.size.width,pullRefreshLabelHeight);
        refreshView.backgroundColor = [UIColor orangeColor];
    }
    if (!activityView) {
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(40,(pullRefreshLabelHeight-30)/2,30,30);
        [activityView startAnimating];
        activityView.hidden = YES;
        [refreshView addSubview:activityView];
    }
    if (!labRefreshText) {
        labRefreshText = [[UILabel alloc]init];
        labRefreshText.backgroundColor = [UIColor clearColor];
        labRefreshText.frame = CGRectMake(0,0,self.view.frame.size.width,pullRefreshLabelHeight);
        labRefreshText.font = [UIFont systemFontOfSize:12];
        labRefreshText.textColor = [UIColor redColor];
        labRefreshText.textAlignment = NSTextAlignmentCenter;
        [refreshView addSubview:labRefreshText];
    }
    
    if (isAnimating) {
        activityView.hidden = NO;
        [activityView startAnimating];
    }else{
        activityView.hidden = YES;
        [activityView stopAnimating];
    }
    
    labRefreshText.text = message;
    return refreshView;
}


- (void)closePull{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }];
}

#pragma  mark -  UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = [scrollView contentOffset];
    NSLog(@"scrollViewDidScroll point is %@",NSStringFromCGPoint(point));
    //下拉刷新
    {
        if (point.y < -pullRefreshLabelHeight) {
            if (scrollView.isDragging) {
                if (!isRequest) {
                    [headerActivityView stopAnimating];
                    headerActivityView.hidden = YES;
                    labHeader.text = @"释放立即刷新";
                }
            }
            
        }else if (point.y < 0 && point.y >= -pullRefreshLabelHeight){
//            if (!isRequest || dataAry.count == 0) {//这句话使得第一次下拉时正在刷新不停留显示
            if (!isRequest) {
                [headerActivityView stopAnimating];
                headerActivityView.hidden = YES;
                labHeader.text = @"下拉刷新";
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
            }else{
                scrollView.contentInset = UIEdgeInsetsMake(pullRefreshLabelHeight, 0.0f, 0.0f, 0.0f);
            }
        }else{
            [self closePull];
        }
    }
    
    //上拉刷新
    {
        
        if (point.y > 0) {
            float tabHeight = scrollView.contentSize.height;
            if (!isRequest && tabHeight - scrollView.contentOffset.y < scrollView.frame.size.height) {
                if (dataCount > dataAry.count) {
                    [self serverRequest:NO];
                }else if (dataCount>0){
                    self.tableView.tableFooterView = [self startActivity:NO message:@"没有更多数据了"];
                }
            }
        }
    }
}

//下拉依次为：下拉刷新（下拉view没完全暴露时）－释放立即刷新（下拉view已经完全暴露）-不再拉的时候DidEndDragging时开始请求第一页数据serverRequest后面传YES,indexPage=0
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    CGPoint point = [scrollView contentOffset];
    NSLog(@"scrollViewDidEndDragging point is %@",NSStringFromCGPoint(point));
    if (point.y <= -pullRefreshLabelHeight && !isRequest) {
        indexPage = 0;
        isRefresh = YES;
        [headerActivityView startAnimating];
        headerActivityView.hidden = NO;
        labHeader.text = @"更新数据中,请稍等...";
        [self serverRequest:YES];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
