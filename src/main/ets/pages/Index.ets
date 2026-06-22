import { AnimationWidgets } from '../view/AnimationWidgets';
import { CountController } from '../view/CountController';
import Common from '../common/constants/Const';
import { IconsModel } from '../viewmodel/IconsModel';
import { BreakpointType, BreakpointConstants } from '../common/constants/BreakpointConstants';

@Entry
@Component
struct Index {
  @State quantity: number = Common.IMAGES_MIN;
  @State currentBreakpoint: string = BreakpointType.MD;
  @Provide iconModel: IconsModel = new IconsModel(this.quantity, BreakpointConstants.getOffsetRadius(BreakpointType.MD));

  aboutToAppear() {
    this.updateBreakpoint();
  }

  private updateBreakpoint(widthVp?: number) {
    if (widthVp === undefined) {
      const displayClass = display.getDefaultDisplaySync();
      widthVp = px2vp(displayClass.width);
    }
    let newBreakpoint: string;
    if (widthVp < 520) {
      newBreakpoint = BreakpointType.SM;
    } else if (widthVp < 840) {
      newBreakpoint = BreakpointType.MD;
    } else {
      newBreakpoint = BreakpointType.LG;
    }
    if (newBreakpoint !== this.currentBreakpoint) {
      this.currentBreakpoint = newBreakpoint;

    }
  }

  build() {
    Column() {
      AnimationWidgets({
        quantity: $quantity,
        currentBreakpoint: $currentBreakpoint
      })

      CountController({
        quantity: $quantity,
        currentBreakpoint: $currentBreakpoint
      })
    }
    .width(Common.DEFAULT_FULL_WIDTH)
    .height(Common.DEFAULT_FULL_HEIGHT)
    .backgroundColor($r('app.color.bgColor'))
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      const newWidth = newValue.width as number;
      if (newWidth) {
        this.updateBreakpoint(px2vp(newWidth));
      }
    })
  }
}
