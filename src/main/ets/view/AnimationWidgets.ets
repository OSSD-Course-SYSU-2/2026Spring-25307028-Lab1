/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IconsModel } from '../viewmodel/IconsModel';
import { IconAnimation } from './IconAnimation';
import Common from '../common/constants/Const';
import IconItem from '../viewmodel/IconItem';
import { BreakpointConstants, BreakpointType } from '../common/utils/BreakpointSystem';

@Component
export struct AnimationWidgets {
  @State mainFlag: boolean = false;
  @Link @Watch('onQuantityChange') quantity: number;
  @Consume iconModel: IconsModel;
  @StorageProp('currentBreakpoint') @Watch('onBreakpointChange') currentBreakpoint: string = BreakpointConstants.SM;

  onQuantityChange() {
    this.iconModel.addImage(this.quantity);
  }

  onBreakpointChange() {
    const radius = new BreakpointType({
      xs: 100,
      sm: 160,
      md: 200,
      lg: 250
    }).getValue(this.currentBreakpoint) as number;
    this.iconModel.updateRadius(radius);
  }

  aboutToAppear() {
    this.onQuantityChange();
    this.onBreakpointChange();
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
    })
  }

  build() {
    Stack() {
      Stack() {
        ForEach(this.iconModel.imagerArr, (item: IconItem) => {
          IconAnimation({
            item: item,
            mainFlag: $mainFlag,

          })
        }, (item: IconItem) => item.index.toString())
      }
      .width(Common.DEFAULT_FULL_WIDTH)
      .height(Common.DEFAULT_FULL_HEIGHT)


      Image(this.mainFlag ? $r('app.media.imgActive') : $r('app.media.imgInit'))
        .width($r('app.float.size_64'))
        .height($r('app.float.size_64'))
        .objectFit(ImageFit.Contain)
        .scale({
          x: this.mainFlag ? Common.INIT_SCALE : 1,
          y: this.mainFlag ? Common.INIT_SCALE : 1
        })
        .onClick(() => {
          // 展开时刷新随机图标
          if (!this.mainFlag) {
            this.iconModel.refreshRandomIcons();
          }
          this.iconModel.reset();
          this.animate();
        })

      if (!this.mainFlag) {
        Text($r('app.string.please_click_button'))
          .fontSize($r('app.float.size_16'))
          .opacity(Common.OPACITY_06)
          .fontColor($r('app.color.fontGrayColor'))
          .fontWeight(Common.FONT_WEIGHT_500)
          .margin({
            top: new BreakpointType({
              xs: 60,
              sm: 80,
              md: 90,
              lg: 100
            }).getValue(this.currentBreakpoint) as number
          })
      }
    }
    .width(Common.DEFAULT_FULL_WIDTH)
    .layoutWeight(1)
  }
}