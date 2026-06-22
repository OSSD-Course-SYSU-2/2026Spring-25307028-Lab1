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

import Common from '../common/constants/Const';

@Component
export struct RandomIcon {
  @State currentIconIndex: number = 0;
  @State isAnimating: boolean = false;

  aboutToAppear() {
    // 初始化时随机选择一个图标
    this.randomizeIcon();
  }

  // 随机选择图标
  private randomizeIcon() {
    const totalIcons = Common.IMAGE_RESOURCE.length;
    this.currentIconIndex = Math.floor(Math.random() * totalIcons);
  }

  // 刷新随机图标（带动画效果）
  private refreshRandomIcon() {
    this.isAnimating = true;
    setTimeout(() => {
      this.randomizeIcon();
      this.isAnimating = false;
    }, 300);
  }

  build() {
    Column() {
      // 随机图标展示区域
      Image(Common.IMAGE_RESOURCE[this.currentIconIndex])
        .width(80)
        .height(80)
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

      // 图标索引显示
      Text(`图标 ${this.currentIconIndex + 1} / ${Common.IMAGE_RESOURCE.length}`)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 12 })

      // 刷新按钮
      Button('随机切换')
        .width(120)
        .height(40)
        .fontSize(16)
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
