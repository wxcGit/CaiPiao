//
//  FANetworkErrorView.m
//  FunApp
//
//  Created by wxc on 3/7/17.
//  Copyright © 2017年 Wandu. All rights reserved.
//

#import "FANetworkErrorView.h"

@interface FANetworkErrorView ()

@property (nonatomic, strong) UIImageView *errorImgView;

@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) UILabel *errorTryLabel;

@end

@implementation FANetworkErrorView

- (instancetype)init
{
    return [self initWithFrame:[UIScreen mainScreen].bounds];;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.errorImgView];
    [self addSubview:self.errorLabel];
    [self addSubview:self.errorTryLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark UI

- (UIImageView*)errorImgView
{
    if (!_errorImgView) {
        _errorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_load_fail"]];
    }
    
    return _errorImgView;
}

- (UILabel*)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc]init];
        _errorLabel.text = @"加载失败";
        _errorLabel.font = SYS_FONT(18);
    }
    
    return _errorLabel;
}

- (UILabel*)errorTryLabel
{
    if (!_errorTryLabel) {
        _errorTryLabel = [[UILabel alloc]init];
        _errorTryLabel.text = @"点击重试";
        _errorTryLabel.font = SYS_FONT(16);
    }
    
    return _errorTryLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _errorImgView.centerX = self.width / 2;
    _errorImgView.centerY = self.height / 2;
    
    [_errorLabel sizeToFit];
    _errorLabel.centerX = self.width / 2;
    _errorLabel.top = _errorImgView.bottom + 20;
    
    [_errorTryLabel sizeToFit];
    _errorTryLabel.centerX = self.width / 2;
    _errorTryLabel.top = _errorLabel.bottom + 20;
}

- (void)tapAction
{
    if (_tryAgainBlock) {
        _tryAgainBlock();
    }
}

@end
