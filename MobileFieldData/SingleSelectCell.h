//
//  MultiSelectCell.h
//  MobileFieldData
//
//  Created by Birks, Matthew (CSIRO IM&T, Yarralumla) on 25/09/12.
//
//

#import <UIKit/UIKit.h>
#import "SurveyInputCell.h"

@interface SingleSelectCell : SurveyInputCell <UIPickerViewDelegate, UIPickerViewDataSource> {
       
}

@property (nonatomic, retain) UIPickerView* picker;
@property (nonatomic, retain) NSArray* options;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier options:(NSArray*)o;
- (void)setSelectedValue:(NSString*)value;

@end
