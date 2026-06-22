import Common from '../common/constants/Const';
import { BreakpointConstants, BreakpointType } from '../common/utils/BreakpointSystem';

@Extend(Text) function textStyle (fontSize?: number) {
  .fontSize(fontSize || $r('app.float.size_16'))
  .fontWeight(Common.FONT_WEIGHT_500)
}

@Component
export struct CountController {
  @Link quantity: number;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;

  private getControllerWidth(): string {
    return new BreakpointType({
      xs: '95%',
      sm: '100%',
      md: '60%',
      lg: '50%'
    }).getValue(this.currentBreakpoint) as string;
  }

  private getFontSize(): number {
    return new BreakpointType({
      xs: 14,
      sm: 16,
      md: 18,
      lg: 20
    }).getValue(this.currentBreakpoint) as number;
  }

  private getPadding(): Padding {
    const v = new BreakpointType({
      xs: 8,
      sm: 12,
      md: 20,
      lg: 24
    }).getValue(this.currentBreakpoint) as number;
    return { top: v, bottom: v, left: v, right: v };
  }

  private getTitleMargin(): Margin {
    const top = new BreakpointType({
      xs: 2,
      sm: 2,
      md: 8,
      lg: 10
    }).getValue(this.currentBreakpoint) as number;
    const bottom = new BreakpointType({
      xs: 4,
      sm: 8,
      md: 16,
      lg: 20
    }).getValue(this.currentBreakpoint) as number;
    return { top: top, bottom: bottom };
  }

  private getSliderTrackThickness(): number {
    return new BreakpointType({
      xs: 16,
      sm: 20,
      md: 24,
      lg: 28
    }).getValue(this.currentBreakpoint) as number;
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.count'))
          .textStyle(this.getFontSize())

        Text(this.quantity.toFixed(0))
          .textStyle(this.getFontSize())
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(Common.DEFAULT_FULL_WIDTH)
      .margin(this.getTitleMargin())

      Slider({
        value: this.quantity,
        min: Common.IMAGES_MIN,
        max: Common.IMAGES_TOTAL,
        step: 1,
        style: SliderStyle.InSet
      })
        .blockColor(Color.White)
        .selectedColor($r('app.color.SliderSelectColor'))
        .showSteps(true)
        .trackThickness(this.getSliderTrackThickness())
        .width(Common.DEFAULT_FULL_WIDTH)
        .onChange((value: number) => {
          this.quantity = value;
        })
    }
    .width(this.getControllerWidth())
    .padding(this.getPadding())
    .margin({
      bottom: $r('app.float.size_24')
    })
    .borderRadius($r('app.float.size_24'))
    .backgroundColor($r('app.color.white'))
  }
}
