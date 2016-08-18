//
//  CustomTableViewCell.m
//  TestNestedTableView
//
//  Created by liujing on 8/16/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize titleLabel;

- (void)awakeFromNib {
     NSLog(@"awakeFromNib1");
    [super awakeFromNib];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
    self.titleLabel.text = @"默认";
    self.titleLabel.textColor = [UIColor orangeColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.titleLabel];
    
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSLog(@"initWithStyle1");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 30)];
    self.titleLabel.text = @"默认";
    self.titleLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.titleLabel];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
