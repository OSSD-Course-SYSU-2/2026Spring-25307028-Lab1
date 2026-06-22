import { IconsModel } from '../viewmodel/IconsModel';
import { IconAnimation } from './IconAnimation';
import Common from '../common/constants/Const';
import IconItem from '../viewmodel/IconItem';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';

@Component
export struct AnimationWidgets {
  @State mainFlag: boolean = false;
  @Link @Watch('onQuantityChange') quantity: number;
  @Consume iconModel: IconsModel;
  @State rotationAngle: number = 0;
  @Link currentBreakpoint: string;
  @Provide adaptiveIconSize: number = 0;
  private rotationTimer: number = -1;
  private containerWidth: number = 0;
  private containerHeight: number = 0;

  onQuantityChange() {
    this.iconModel.addImage(this.quantity);
  }

  aboutToAppear() {
    this.adaptiveIconSize = BreakpointConstants.getIconSize(this.currentBreakpoint);
    this.onQuantityChange();
  }

  aboutToDisappear() {
    if (this.rotationTimer !== -1) {
      clearInterval(this.rotationTimer);
      this.rotationTimer = -1;
    }
  }

  private calculateDynamicRadius(): number {
    const defaultIconSize = BreakpointConstants.getIconSize(this.currentBreakpoint);
    const halfW = this.containerWidth / 2;
    const halfH = this.containerHeight / 2;
    const minDim = Math.min(halfW, halfH);
    const minIconSize = 24;
    const padding = 8;

    let iconSize = defaultIconSize;
    let maxRadius = minDim - iconSize / 2 - padding;
    if (maxRadius < minIconSize) {
      iconSize = Math.max(minIconSize, Math.floor((minDim - padding) * 2 / 3));
      maxRadius = minDim - iconSize / 2 - padding;
    }
    const radius = Math.max(iconSize / 2, maxRadius);
    this.adaptiveIconSize = iconSize;
    return radius;
  }

  private updateDynamicRadius() {
    if (this.containerWidth > 0 && this.containerHeight > 0) {
      this.iconModel.updateRadius(this.calculateDynamicRadius());
    }
  }

  private startRotation() {
    if (this.rotationTimer !== -1) {
      clearInterval(this.rotationTimer);
    }
    const speed = BreakpointConstants.getRotationSpeed(this.currentBreakpoint);
    this.rotationTimer = setInterval(() => {
      this.rotationAngle = (this.rotationAngle + speed) % 360;
    }, 100);
  }

  private stopRotation() {
    if (this.rotationTimer !== -1) {
      clearInterval(this.rotationTimer);
      this.rotationTimer = -1;
    }
  }

  private smoothResetAngle() {
    this.getUIContext().animateTo(
      {
        duration: Common.DURATION_500,
        curve: Curve.Smooth,
        playMode: PlayMode.Normal
      }, () => {
        this.rotationAngle = 0;
      }
    );
  }

  animate() {
    this.getUIContext().animateTo(
      {
        delay: Common.DELAY_10,
        tempo: Common.TEMPO,
        iterations: 1,
        duration: Common.DURATION_500,
        curve: Curve.Smooth,
        playMode: PlayMode.Normal
      }, () => {
        this.mainFlag = !this.mainFlag;
        if (this.mainFlag) {
          setTimeout(() => {
            this.startRotation();
          }, Common.DURATION_500);
        } else {
          this.stopRotation();
          this.smoothResetAngle();
        }
    })
  }

  build() {
    Stack() {
      Stack() {
        ForEach(this.iconModel.imagerArr, (item: IconItem) => {
          IconAnimation({
            item: item,
            mainFlag: $mainFlag,
            containerRotationAngle: $rotationAngle,
            currentBreakpoint: $currentBreakpoint
          })
        }, (item: IconItem) => item.index.toString())
      }
      .width(Common.DEFAULT_FULL_WIDTH)
      .height(Common.DEFAULT_FULL_HEIGHT)
      .clip(true)
      .rotate({
        x: 0,
        y: 0,
        z: 1,
        angle: this.rotationAngle
      })

      Image(this.mainFlag ? $r('app.media.imgActive') : $r('app.media.imgInit'))
        .width(BreakpointConstants.getButtonSize(this.currentBreakpoint))
        .height(BreakpointConstants.getButtonSize(this.currentBreakpoint))
        .objectFit(ImageFit.Contain)
        .scale({
          x: this.mainFlag ? BreakpointConstants.getInitScale(this.currentBreakpoint) : 1,
          y: this.mainFlag ? BreakpointConstants.getInitScale(this.currentBreakpoint) : 1
        })
        .onClick(() => {
          if (this.mainFlag) {
            this.stopRotation();
          }
          if (!this.mainFlag) {
            this.iconModel.refreshRandomIcons();
          }
          this.iconModel.reset();
          this.animate();
        })

      Text($r('app.string.please_click_button'))
        .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint))
        .opacity(Common.OPACITY_06)
        .fontColor($r('app.color.fontGrayColor'))
        .fontWeight(Common.FONT_WEIGHT_500)
        .margin({
          top: BreakpointConstants.getButtonSize(this.currentBreakpoint) + 36
        })
    }
    .width(Common.DEFAULT_FULL_WIDTH)
    .layoutWeight(1)
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      const newW = newValue.width as number;
      const newH = newValue.height as number;
      if (newW && newH) {
        this.containerWidth = px2vp(newW);
        this.containerHeight = px2vp(newH);
        this.updateDynamicRadius();
      }
    })
  }
}
