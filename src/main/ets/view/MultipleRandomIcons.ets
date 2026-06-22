import Common from '../common/constants/Const';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';

@Component
export struct MultipleRandomIcons {
  @State iconIndices: number[] = [];
  @State displayCount: number = 3;
  @State isRefreshing: boolean = false;
  @Link currentBreakpoint: string;

  aboutToAppear() {
    this.randomizeAllIcons();
  }

  private randomizeAllIcons() {
    const totalIcons = Common.IMAGE_RESOURCE.length;
    const count = Math.min(this.displayCount, totalIcons);

    const indices: number[] = [];
    for (let i = 0; i < totalIcons; i++) {
      indices.push(i);
    }

    for (let i = 0; i < count; i++) {
      const randomPos = i + Math.floor(Math.random() * (totalIcons - i));
      const temp = indices[i];
      indices[i] = indices[randomPos];
      indices[randomPos] = temp;
    }

    this.iconIndices = indices.slice(0, count);
  }

  private refreshAllIcons() {
    this.isRefreshing = true;
    setTimeout(() => {
      this.randomizeAllIcons();
      this.isRefreshing = false;
    }, 400);
  }

  build() {
    Column() {
      Flex({
        wrap: FlexWrap.Wrap,
        justifyContent: FlexAlign.SpaceEvenly
      }) {
        ForEach(this.iconIndices, (iconIndex: number, index: number) => {
          Column() {
            Image(Common.IMAGE_RESOURCE[iconIndex])
              .width(BreakpointConstants.getIconSize(this.currentBreakpoint))
              .height(BreakpointConstants.getIconSize(this.currentBreakpoint))
              .objectFit(ImageFit.Contain)
              .rotate({ angle: this.isRefreshing ? 360 : 0 })
              .scale({
                x: this.isRefreshing ? 0.3 : 1,
                y: this.isRefreshing ? 0.3 : 1
              })
              .opacity(this.isRefreshing ? 0.2 : 1)
              .animation({
                duration: 400,
                delay: index * 100,
                curve: Curve.EaseInOut
              })

            Text(`#${iconIndex + 1}`)
              .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) - 4)
              .fontColor('#999999')
              .margin({ top: 4 })
          }
          .width(BreakpointConstants.getIconSize(this.currentBreakpoint) + 20)
          .height(BreakpointConstants.getIconSize(this.currentBreakpoint) + 40)
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .height(BreakpointConstants.getIconSize(this.currentBreakpoint) + 60)

      Column() {
        Row() {
          Text('展示数量:')
            .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) - 2)

          Button('-')
            .width(BreakpointConstants.getFontSize(this.currentBreakpoint) * 3)
            .height(BreakpointConstants.getFontSize(this.currentBreakpoint) * 2)
            .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) + 2)
            .margin({ left: 10, right: 10 })
            .enabled(this.displayCount > 1)
            .onClick(() => {
              if (this.displayCount > 1) {
                this.displayCount--;
                this.randomizeAllIcons();
              }
            })

          Text(`${this.displayCount}`)
            .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint))
            .fontWeight(FontWeight.Bold)
            .width(30)
            .textAlign(TextAlign.Center)

          Button('+')
            .width(BreakpointConstants.getFontSize(this.currentBreakpoint) * 3)
            .height(BreakpointConstants.getFontSize(this.currentBreakpoint) * 2)
            .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint) + 2)
            .margin({ left: 10 })
            .enabled(this.displayCount < Common.IMAGE_RESOURCE.length)
            .onClick(() => {
              if (this.displayCount < Common.IMAGE_RESOURCE.length) {
                this.displayCount++;
                this.randomizeAllIcons();
              }
            })
        }
        .margin({ bottom: 15 })

        Button('随机刷新')
          .width(BreakpointConstants.getFontSize(this.currentBreakpoint) * 10)
          .height(BreakpointConstants.getFontSize(this.currentBreakpoint) * 3)
          .fontSize(BreakpointConstants.getFontSize(this.currentBreakpoint))
          .backgroundColor('#007DFF')
          .onClick(() => {
            this.refreshAllIcons();
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .padding({ top: 20 })
  }
}
