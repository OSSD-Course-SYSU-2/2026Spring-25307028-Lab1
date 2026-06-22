import { RandomIcon } from '../view/RandomIcon';
import { MultipleRandomIcons } from '../view/MultipleRandomIcons';
import { BreakpointType, BreakpointConstants } from '../common/constants/BreakpointConstants';

@Entry
@Component
struct RandomIconPage {
  @State currentMode: number = 0;
  @State currentBreakpoint: string = BreakpointType.MD;

  aboutToAppear() {
    this.updateBreakpoint();
  }

  private updateBreakpoint() {
    const display = display.getDefaultDisplaySync();
    const widthVp = px2vp(display.width);
    if (widthVp < 520) {
      this.currentBreakpoint = BreakpointType.SM;
    } else if (widthVp < 840) {
      this.currentBreakpoint = BreakpointType.MD;
    } else {
      this.currentBreakpoint = BreakpointType.LG;
    }
  }

  build() {
    Column() {
      Text('随机图标展示')
        .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) + 8)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Row() {
        Button('单个图标')
          .width(BreakpointConstants.getFontSize(this.currentBreakpoint) * 7)
          .height(BreakpointConstants.getFontSize(this.currentBreakpoint) * 2.5)
          .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) - 2)
          .backgroundColor(this.currentMode === 0 ? '#007DFF' : '#E0E0E0')
          .fontColor(this.currentMode === 0 ? '#FFFFFF' : '#333333')
          .onClick(() => {
            this.currentMode = 0;
          })

        Button('多个图标')
          .width(BreakpointConstants.getFontSize(this.currentBreakpoint) * 7)
          .height(BreakpointConstants.getFontSize(this.currentBreakpoint) * 2.5)
          .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) - 2)
          .margin({ left: 20 })
          .backgroundColor(this.currentMode === 1 ? '#007DFF' : '#E0E0E0')
          .fontColor(this.currentMode === 1 ? '#FFFFFF' : '#333333')
          .onClick(() => {
            this.currentMode = 1;
          })
      }
      .margin({ bottom: 20 })

      if (this.currentMode === 0) {
        RandomIcon({ currentBreakpoint: $currentBreakpoint })
      } else {
        MultipleRandomIcons({ currentBreakpoint: $currentBreakpoint })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
