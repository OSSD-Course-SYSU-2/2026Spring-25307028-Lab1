import Common from '../common/constants/Const';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';

@Component
export struct RandomIcon {
  @State currentIconIndex: number = 0;
  @State isAnimating: boolean = false;
  @Link currentBreakpoint: string;

  aboutToAppear() {
    this.randomizeIcon();
  }

  private randomizeIcon() {
    const totalIcons = Common.IMAGE_RESOURCE.length;
    this.currentIconIndex = Math.floor(Math.random() * totalIcons);
  }

  private refreshRandomIcon() {
    this.isAnimating = true;
    setTimeout(() => {
      this.randomizeIcon();
      this.isAnimating = false;
    }, 300);
  }

  build() {
    Column() {
      Image(Common.IMAGE_RESOURCE[this.currentIconIndex])
        .width(BreakpointConstants.getIconSize(this.currentBreakpoint))
        .height(BreakpointConstants.getIconSize(this.currentBreakpoint))
        .objectFit(ImageFit.Contain)
        .rotate({ angle: this.isAnimating ? 180 : 0 })
        .scale({
          x: this.isAnimating ? 0.5 : 1,
          y: this.isAnimating ? 0.5 : 1
        })
        .opacity(this.isAnimating ? 0.3 : 1)
        .animation({
          duration: 300,
          curve: Curve.EaseInOut,
          playMode: PlayMode.Normal
        })

      Text(`图标 ${this.currentIconIndex + 1} / ${Common.IMAGE_RESOURCE.length}`)
        .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) - 2)
        .fontColor('#666666')
        .margin({ top: 12 })

      Button('随机切换')
        .width(BreakpointConstants.getFontSize(this.currentBreakpoint) * 8)
        .height(BreakpointConstants.getFontSize(this.currentBreakpoint) * 2.5)
        .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint))
        .margin({ top: 20 })
        .onClick(() => {
          this.refreshRandomIcon();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
