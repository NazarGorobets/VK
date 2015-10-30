//
//  NGImageViewGallery.h
//  VK
//
//  Created by Naz on 10/27/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGImageViewGallery : UIView
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *framesArray;

- (instancetype) initWithImageArray:(NSArray *)imageArray startPoint:(CGPoint)point withSizeView:(CGSize) sizeView;

@end
