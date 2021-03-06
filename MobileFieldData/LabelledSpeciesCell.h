//
//  LabelledSpeciesCell.h
//  MobileFieldData
//
//  Created by Chris Godwin on 29/01/13.
//
//

#import <UIKit/UIKit.h>
#import "SurveyInputCell.h"

@class Species;

@interface LabelledSpeciesCell : SurveyInputCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) Species* species;

@end
