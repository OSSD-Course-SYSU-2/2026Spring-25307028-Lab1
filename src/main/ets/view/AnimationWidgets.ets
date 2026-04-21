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

@Component
export struct AnimationWidgets {
  @State mainFlag: boolean = false;
  @Link @Watch('onQuantityChange') quantity: number;
  @Consume iconModel: IconsModel;
  @State rotationAngle: number = 0; // 持续旋转角度
  private rotationTimer: number = -1; // 旋转定时器

  onQuantityChange() {
    this.iconModel.addImage(this.quantity);
  }

  aboutToAppear() {
    this.onQuantityChange();
  }

  aboutToDisappear() {
    // 组件销毁时清除定时器
    if (this.rotationTimer !== -1) {
      clearInterval(this.rotationTimer);
      this.rotationTimer = -1;
    }
  }

  // 开始持续旋转动画 - 优化：增加间隔减少重绘频率
  private startRotation() {
    if (this.rotationTimer !== -1) {
      clearInterval(this.rotationTimer);
    }
    // 每100毫秒旋转2度，实现流畅但性能更优的旋转效果
    this.rotationTimer = setInterval(() => {
      this.rotationAngle = (this.rotationAngle + 2) % 360;
    }, 100);
  }

  // 停止旋转动画
  private stopRotation() {
    if (this.rotationTimer !== -1) {
      clearInterval(this.rotationTimer);
      this.rotationTimer = -1;
    }
  }

  // 平滑重置旋转角度到0度（收起时使用）
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
        // 展开时开始旋转，收起时停止旋转
        if (this.mainFlag) {
          // 延迟启动旋转，等待展开动画完成
          setTimeout(() => {
            this.startRotation();
          }, Common.DURATION_500);
        } else {
          // 停止旋转定时器
          this.stopRotation();
          // 同时启动角度归零动画，与收起动画同步
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
            containerRotationAngle: $rotationAngle
          })
        }, (item: IconItem) => item.index.toString())
      }
      .width(Common.DEFAULT_FULL_WIDTH)
      .height(Common.DEFAULT_FULL_HEIGHT)
      .rotate({
        x: 0,
        y: 0,
        z: 1,
        angle: this.rotationAngle
      })

      Image(this.mainFlag ? $r('app.media.imgActive') : $r('app.media.imgInit'))
        .width($r('app.float.size_64'))
        .height($r('app.float.size_64'))
        .objectFit(ImageFit.Contain)
        .scale({
          x: this.mainFlag ? Common.INIT_SCALE : 1,
          y: this.mainFlag ? Common.INIT_SCALE : 1
        })
        .onClick(() => {
          // 收起时停止旋转
          if (this.mainFlag) {
            this.stopRotation();
          }
          // 每次展开时重新随机选择图标
          if (!this.mainFlag) {
            this.iconModel.refreshRandomIcons();
          }
          this.iconModel.reset();
          this.animate();
        })

      Text($r('app.string.please_click_button'))
        .fontSize($r('app.float.size_16'))
        .opacity(Common.OPACITY_06)
        .fontColor($r('app.color.fontGrayColor'))
        .fontWeight(Common.FONT_WEIGHT_500)
        .margin({
          top: $r('app.float.size_100')
        })
    }
    .width(Common.DEFAULT_FULL_WIDTH)
    .layoutWeight(1)
  }
}