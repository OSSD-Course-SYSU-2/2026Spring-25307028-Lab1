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

import { RandomIcon } from '../view/RandomIcon';
import { MultipleRandomIcons } from '../view/MultipleRandomIcons';

@Entry
@Component
struct RandomIconPage {
  @State currentMode: number = 0; // 0: 单个图标, 1: 多个图标

  build() {
    Column() {
      // 标题
      Text('随机图标展示')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 模式切换按钮
      Row() {
        Button('单个图标')
          .width(100)
          .height(35)
          .fontSize(14)
          .backgroundColor(this.currentMode === 0 ? '#007DFF' : '#E0E0E0')
          .fontColor(this.currentMode === 0 ? '#FFFFFF' : '#333333')
          .onClick(() => {
            this.currentMode = 0;
          })
        
        Button('多个图标')
          .width(100)
          .height(35)
          .fontSize(14)
          .margin({ left: 20 })
          .backgroundColor(this.currentMode === 1 ? '#007DFF' : '#E0E0E0')
          .fontColor(this.currentMode === 1 ? '#FFFFFF' : '#333333')
          .onClick(() => {
            this.currentMode = 1;
          })
      }
      .margin({ bottom: 20 })

      // 根据模式显示不同组件
      if (this.currentMode === 0) {
        RandomIcon()
      } else {
        MultipleRandomIcons()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
