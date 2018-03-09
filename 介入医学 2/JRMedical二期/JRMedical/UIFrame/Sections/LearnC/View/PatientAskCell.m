//
//  PatientAskCell.m
//  JRMedical
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "PatientAskCell.h"
#import "PatientAskModel.h"
#import "ZWVerticalAlignLabel.h"

@interface PatientAskCell ()

@property (weak, nonatomic) IBOutlet ZWVerticalAlignLabel *questionLabel;
@property (weak, nonatomic) IBOutlet ZWVerticalAlignLabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation PatientAskCell


- (void)setDataWithModel:(PatientAskModel *)model {
    
    _questionLabel.text = model.QuestionContent;
    _answerLabel.text = model.ReplyContent;
    _dateLabel.text = [NSString stringWithFormat:@"%@", model.ReplyTime];
    
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.questionLabel textAlign:^(ZWMaker *make) {
        make.addAlignType(textAlignType_top);
    }];
    
    [self.answerLabel textAlign:^(ZWMaker *make) {
        make.addAlignType(textAlignType_top);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
