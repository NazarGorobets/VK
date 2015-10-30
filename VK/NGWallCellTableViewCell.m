//
//  NGWallCellTableViewCell.m
//  VK
//
//  Created by Naz on 10/27/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGWallCellTableViewCell.h"

@implementation NGWallCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat) heightForTextWithPostModel:(NGGetWallObjectData*) wall andWidthTextCell:(CGFloat) widthCellText {
    
    
    CGFloat offset = 8.0;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    shadow = nil;
    
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    // - 2 * offset
    CGRect rect = [wall.text boundingRectWithSize:CGSizeMake(widthCellText - 2*offset , CGFLOAT_MAX)
                                          options:   NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attributes
                                          context:nil];
    
    return CGRectGetHeight(rect) - 2 * offset;
}

@end
