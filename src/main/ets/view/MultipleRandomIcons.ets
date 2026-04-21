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
export struct MultipleRandomIcons {
  @State iconIndices: number[] = [];
  @State displayCount: number = 3; // 默认展示3个图标
  @State isRefreshing: boolean = false;

  aboutToAppear() {
    // 初始化随机图标
    this.randomizeAllIcons();
  }

  // 随机生成指定数量的不重复图标索引 - 使用Fisher-Yates洗牌算法
  private randomizeAllIcons() {
    const totalIcons = Common.IMAGE_RESOURCE.length;
    const count = Math.min(this.displayCount, totalIcons);
    
    // 创建索引数组
    const indices: number[] = [];
    for (let i = 0; i < totalIcons; i++) {
      indices.push(i);
    }
    
    // Fisher-Yates部分洗牌
    for (let i = 0; i < count; i++) {
      const randomPos = i + Math.floor(Math.random() * (totalIcons - i));
      // 交换位置（不使用解构赋值）
      const temp = indices[i];
      indices[i] = indices[randomPos];
      indices[randomPos] = temp;
    }
    
    this.iconIndices = indices.slice(0, count);
  }

  // 刷新所有图标
  private refreshAllIcons() {
    this.isRefreshing = true;
    setTimeout(() => {
      this.randomizeAllIcons();
      this.isRefreshing = false;
    }, 400);
  }

  build() {
    Column() {
      // 图标展示区域
      Flex({ 
        wrap: FlexWrap.Wrap, 
        justifyContent: FlexAlign.SpaceEvenly 
      }) {
        ForEach(this.iconIndices, (iconIndex: number, index: number) => {
          Column() {
            Image(Common.IMAGE_RESOURCE[iconIndex])
              .width(60)
              .height(60)
              .objectFit(ImageFit.Contain)
              .rotate({ angle: this.isRefreshing ? 360 : 0 })
              .scale({ 
                x: this.isRefreshing ? 0.3 : 1, 
                y: this.isRefreshing ? 0.3 : 1 
              })
              .opacity(this.isRefreshing ? 0.2 : 1)
              .animation({
                duration: 400,
                delay: index * 100, // 错开动画时间
                curve: Curve.EaseInOut
              })
            
            Text(`#${iconIndex + 1}`)
              .fontSize(12)
              .fontColor('#999999')
              .margin({ top: 4 })
          }
          .width(80)
          .height(100)
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .height(200)

      // 控制区域
      Column() {
        // 数量调节
        Row() {
          Text('展示数量:')
            .fontSize(14)
          
          Button('-')
            .width(40)
            .height(30)
            .fontSize(18)
            .margin({ left: 10, right: 10 })
            .enabled(this.displayCount > 1)
            .onClick(() => {
              if (this.displayCount > 1) {
                this.displayCount--;
                this.randomizeAllIcons();
              }
            })
          
          Text(`${this.displayCount}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width(30)
            .textAlign(TextAlign.Center)
          
          Button('+')
            .width(40)
            .height(30)
            .fontSize(18)
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

        // 刷新按钮
        Button('随机刷新')
          .width(150)
          .height(45)
          .fontSize(16)
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
