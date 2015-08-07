//
//  SurveyInputCell.m
//  MobileFieldData
//
//  Created by Birks, Matthew (CSIRO IM&T, Yarralumla) on 21/09/12.
//
//

#import "SurveyInputCell.h"
#import "MarginLabel.h"

@implementation SurveyInputCell

@synthesize label, value;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.value = @"";
        label = [[MarginLabel alloc] initWithFrame:CGRectMake(5, 2, self.bounds.size.width-10, 28)];
        label.font = [UIFont boldSystemFontOfSize:9.0];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
}

/*
- (void)setValue:(NSString*)val {
    value = val;
}*/

@end
