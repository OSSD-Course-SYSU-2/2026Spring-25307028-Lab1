import Common from '../common/constants/Const';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';

@Extend(Text) function textStyle(fontSize: number) {
  .fontSize(fontSize)
  .fontWeight(Common.FONT_WEIGHT_500)
}

@Component
export struct CountController {
  @Link quantity: number;
  @Link currentBreakpoint: string;

  build() {
    Column() {
      Row() {
        Text($r('app.string.count'))
          .textStyle(BreakpointConstants.getFontSize(this.currentBreakpoint))

        Text(this.quantity.toFixed(0))
          .textStyle(BreakpointConstants.getFontSize(this.currentBreakpoint))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(Common.DEFAULT_FULL_WIDTH)
      .margin({
        top: 4
      })

      Slider({
        value: this.quantity,
        min: Common.IMAGES_MIN,
        max: Common.IMAGES_TOTAL,
        step: 1,
        style: SliderStyle.InSet
      })
        .blockColor(Color.White)
        .selectedColor($r('app.color.SliderSelectColor'))
        .margin({
          top: 5
        })
        .showSteps(true)
        .trackThickness(20)
        .onChange((value: number) => {
          this.quantity = value;
        })
    }
    .height(BreakpointConstants.getControllerHeight(this.currentBreakpoint))
    .padding({
      top: 12,
      bottom: 12,
      left: 16,
      right: 16
    })
    .margin({
      bottom: 48
    })
    .width(BreakpointConstants.getControllerWidth(this.currentBreakpoint))
    .borderRadius(24)
    .backgroundColor($r('app.color.white'))
  }
}
