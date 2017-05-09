#FaceBook POP（POPAnimation）

本文简单介绍了FaceBook开原动画框架POP的内容及基本使用

推荐一份参考文献《iOS核心动画高级技巧》：[https://zsisme.gitbooks.io/ios-/content/chapter1/layers-and-trees.html](https://zsisme.gitbooks.io/ios-/content/chapter1/layers-and-trees.html)

##使用POP可以创建的 4 类动画：
* Spring	（弹性）动效可以赋予物体愉悦的弹性效果；
* Decay 	（衰减) 动效可以用来逐渐减慢物体的速度至停止；
* Basic 	（基本）传统动画，可以在给定时间的运动中插入数值调整运动节奏，支持默认、线性、淡入、淡出、淡入淡出动画；
* Custom	（自定义）自定义动画，让设计值创建自定义动效，只需简单处理CADisplayLink，并联系时间-运动关系，使用难度略大于前三者；

它们的继承关系为

```
NSObject   
|- POPAnimation   
	|- POPPropertyAnimation   
		|- POPBasicAnimation   
		|- POPDecayAnimation   
		|- POPSpringAnimation   
	|- POPCustomAnimation   
```

所有的动画属性分为两大类：作用于View与作用于Layer

```
View系：
	不透明度 	- kPOPViewAlpha
	颜色	- kPOPViewBackgroundColor
	大小	- kPOPViewBounds
	中心点	- kPOPViewCenter
	位置与尺寸	- kPOPViewFrame
	尺寸 - kPOPViewScaleXY
	尺寸（按比例变化） - kPOPViewSize

Layer系：
	颜色 - kPOPLayerBackgroundColor
	大小 - kPOPLayerBounds、kPOPLayerScaleXY、kPOPLayerSize
	不透明度 - kPOPLayerOpacity
	位置 - kPOPLayerPosition
	X 坐标 - kPOPLayerPositionX
	Y 坐标 - kPOPLayerPositionY
	旋转 - kPOPLayerRotation
```

##POP动画常用属性
> 这里简单介绍几个使用过程中常用的属性

* `beginTime` ：动画开始时间，一般用`animation.beginTime = CACurrentMediaTime() + 0.5;`动画延迟0.5秒后执行；
* `duration ` ：动画持续时长，多用于基础动画；
* `timingFunction` ：决定动画节奏；
* `fromValue` ：动画的起始状态；
* `toValue` ：动画的终止状态；
* `springBounciness` ：弹簧弹力(幅度) 取值范围为[0, 20]，默认值为4；
* `springSpeed` ：弹簧速度，速度越快，动画时间越短 [0, 20]，默认为12，和springBounciness一起决定着弹簧动画的效果；
* `velocity` ：速率，常用于衰减动画中，速率被用来计算运行的距离；
* `deceleration` ：负加速度，Default = 0.998，如果你开发给火星人用，那么这个值使用 0.376 会更合适。`减速效果增强（缩小动画幅度）<< 0.998 << 减速效果降低（加大动画幅度）`；
* `completionBlock` ：动画完成后的回调，completionBlock 提供了一个 Callback，动画的执行过程会不断调用这个 block，finished 这个布尔变量可以用来做动画完成与否的判断；

```
	附：
		· dynamicsTension 弹簧的张力，影响回弹力度及速度；
		· dynamicsFriction 弹簧摩擦力，开启后，动画会不断重复，并且幅度逐渐削弱，直到停止；
		· dynamicsMass 质量，细微地影响动画的回弹力度和速度；
		这三者可以从更细的粒度上替代springBounciness和springSpeed控制弹簧动画的效果。
```

##POP动画的介绍与使用
###1. POPBasicAnimation基础动画
> 基本动画，接口方面和CABasicAniamtion很相似，使用可以提供初始值fromValue，这个 终点值toValue，动画时长duration以及决定动画节奏的timingFunction。timingFunction直接使用的CAMediaTimingFunction,是使用一个横向纵向都为一个单位的拥有两个控制点的贝赛尔曲线来描述的，横坐标为时间，纵坐标为动画进度。

```
	POPBasicAnimation *basicAnimation = [POPBasicAnimation 	animationWithPropertyNamed:kPOPViewScaleXY];
	basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(3.0, 3.0)];
	basicAnimation.duration = 1;
	basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[self.ZView pop_addAnimation: basicAnimation forKey:@"basicAnimation"];
```
此处需要说明的：
`- (void)pop_addAnimation:(POPAnimation *)anim forKey:(NSString *)key`方法中Key的赋值，保证在动画载体中Key的唯一性即可；

###2. PopSpringAnimation
> 弹簧动画是Bezier曲线无法表述的，所以无法使用PopBasicAniamtion来实现。PopSpringAnimation便是专门用来实现弹簧动画的。

```
	POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    springAnimation.beginTime = CACurrentMediaTime() + 2;
    springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2.0, 2.0)];
    springAnimation.springBounciness = 5.f;
    springAnimation.springSpeed = 10;
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        POPSpringAnimation *resetAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        resetAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        resetAnimation.springBounciness = 20.f;
        resetAnimation.springSpeed = 10;
        [self.ZView.layer pop_addAnimation:scaleAnimation forKey:@"resetAnimation"];
    };
    [self.ZView.layer pop_addAnimation: springAnimation forKey:@"springAnimation"];
```
如果对PopSpringAnimation动画的velocity属性赋值，会发生“奇妙”的动画影响，因为我还没有找到规律😂有了解的朋友可以留言讨论一下。

###3. PopDecayAnimation
> 基于Bezier曲线的timingFuntion同样无法表述Decay Aniamtion，所以Pop就单独实现了一个 PopDecayAnimation，用于衰减动画。

```
	POPDecayAnimation *decay_1 = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerBounds];
    decay_1.velocity = [NSValue valueWithCGRect:CGRectMake(0, 0, 50.0, 50.0)];
    [_ZButton.layer pop_addAnimation:decay_1 forKey:@"lalalal"];
    
    POPDecayAnimation *decay_2 = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
    decay_2.velocity = [NSValue valueWithCGPoint:CGPointMake(100, 500)];
    [_Z2Button.layer pop_addAnimation:decay_2 forKey:@"lalalal"];
```
衰减动画没有 toValue 只有 fromValue，然后按照 velocity 来做衰减操作，如果不对fromValue赋值，那么动画会按照载体的当前状态执行。这里非常值得一提的是，velocity 也是必须和你操作的属性有相同的结构，如果你操作的是 bounds，想实现一个水滴滴到桌面的扩散效果，那么应该是 [NSValue valueWithCGRect:CGRectMake(0, 0,20.0, 20.0)]。


##动画委托
> POPAnimatorDelegate是可选的，拥有如下方法

```
- (void)pop_animationDidStart:(POPAnimation *)anim;
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished;
- (void)pop_animationDidReachToValue:(POPAnimation *)anim;
```

##值得说的几点

* 最后我们使用 `pop_addAnimation ` 来让动画开始生效，如果你想删除动画的话，那么你需要调用 `pop_removeAllAnimations`。 与 iOS 自带的动画不同，如果你在动画的执行过程中删除了物体的动画，那么物体会停在动画状态的最后一个瞬间，而不是闪回开始前的状态；
* Pop Animation应用于CALayer时，在动画运行的任何时刻，layer`和其presentationLayer的相关属性值始终保持一致，而Core Animation做不到
