import IconItem from '../viewmodel/IconItem';
import Common from '../common/constants/Const';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';

@Component
export struct IconAnimation {
  @Link mainFlag: boolean;
  @ObjectLink item: IconItem;
  @Link containerRotationAngle: number;
  @Link currentBreakpoint: string;
  @Consume adaptiveIconSize: number;

  build() {
    Column() {
      Image(this.item.image)
        .width(this.adaptiveIconSize)
        .height(this.adaptiveIconSize)
        .objectFit(ImageFit.Contain)
        .rotate({
          x: 0,
          y: 1,
          z: 0,
          angle: this.item.clicked ? Common.ROTATE_ANGLE_360 : 0
        })
        .scale(this.item.clicked ? {
          x: BreakpointConstants.getScaleRatio(this.currentBreakpoint),
          y: BreakpointConstants.getScaleRatio(this.currentBreakpoint)
        } : { x: 1, y: 1 })
        .opacity(this.item.clicked ? Common.OPACITY_06 : 1)
        .onClick(() => {
          this.item.clicked = !this.item.clicked;
        })
        .animation({
          delay: Common.DELAY_10,
          duration: Common.DURATION_1000,
          iterations: 1,
          curve: Curve.Smooth,
          playMode: PlayMode.Normal
        })
    }
    .translate(this.mainFlag ? { x: this.item.point.x, y: this.item.point.y } : { x: 0, y: 0 })
    .rotate({
      x: 0,
      y: 0,
      z: 1,
      angle: -this.containerRotationAngle
    })
  }
}
