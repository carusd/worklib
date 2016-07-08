//
//  GTBadgeView.m
//  Pods
//
//  Created by carusd on 16/6/14.
//
//

#import "GTBadgeView.h"

@interface GTBadgeView ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation GTBadgeView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
    self.backgroundColor = GTColor(255, 52, 45, 1);
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.contentLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[_contentLabel]-7-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentLabel]|" options:0 metrics:nil views:views]];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.contentLabel.text = text;
    [self setNeedsLayout];
}


@end
