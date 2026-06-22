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
import { BreakpointSystem, BreakpointConstants, BreakpointType } from '../common/utils/BreakpointSystem';

@Entry
@Component
struct RandomIconPage {
  @State currentMode: number = 0; // 0: 单个图标, 1: 多个图标
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.SM;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  aboutToAppear() {
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  build() {
    Column() {
      // 标题 - 根据断点调整大小
      Text('随机图标展示')
        .fontSize(new BreakpointType({ xs: 18, sm: 24, md: 28, lg: 32 }).getValue(this.currentBreakpoint) as number)
        .fontWeight(FontWeight.Bold)
        .margin({ 
          bottom: new BreakpointType({ sm: 20, md: 25, lg: 30 }).getValue(this.currentBreakpoint) as number 
        })

      // 模式切换按钮 - 根据断点调整布局
      if (this.currentBreakpoint !== BreakpointConstants.XS) {
        Row() {
          Button('单个图标')
            .width(new BreakpointType({ sm: 100, md: 120, lg: 150 }).getValue(this.currentBreakpoint) as number)
            .height(new BreakpointType({ sm: 35, md: 40, lg: 45 }).getValue(this.currentBreakpoint) as number)
            .fontSize(new BreakpointType({ sm: 14, md: 16, lg: 18 }).getValue(this.currentBreakpoint) as number)
            .backgroundColor(this.currentMode === 0 ? '#007DFF' : '#E0E0E0')
            .fontColor(this.currentMode === 0 ? '#FFFFFF' : '#333333')
            .onClick(() => {
              this.currentMode = 0;
            })
          
          Button('多个图标')
            .width(new BreakpointType({ sm: 100, md: 120, lg: 150 }).getValue(this.currentBreakpoint) as number)
            .height(new BreakpointType({ sm: 35, md: 40, lg: 45 }).getValue(this.currentBreakpoint) as number)
            .fontSize(new BreakpointType({ sm: 14, md: 16, lg: 18 }).getValue(this.currentBreakpoint) as number)
            .margin({ left: 20 })
            .backgroundColor(this.currentMode === 1 ? '#007DFF' : '#E0E0E0')
            .fontColor(this.currentMode === 1 ? '#FFFFFF' : '#333333')
            .onClick(() => {
              this.currentMode = 1;
            })
        }
        .margin({ bottom: 20 })
      } else {
        // 手表设备：垂直排列按钮
        Column() {
          Button('单个')
            .width(80)
            .height(30)
            .fontSize(12)
            .backgroundColor(this.currentMode === 0 ? '#007DFF' : '#E0E0E0')
            .onClick(() => { this.currentMode = 0; })
          
          Button('多个')
            .width(80)
            .height(30)
            .fontSize(12)
            .margin({ top: 10 })
            .backgroundColor(this.currentMode === 1 ? '#007DFF' : '#E0E0E0')
            .onClick(() => { this.currentMode = 1; })
        }
        .margin({ bottom: 15 })
      }

      // 根据模式显示不同组件
      if (this.currentMode === 0) {
        RandomIcon()
      } else {
        MultipleRandomIcons()
      }
      
      // 设备信息提示
      this.DeviceInfoHint()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 设备信息提示组件
  @Builder
  DeviceInfoHint() {
    Column() {
      Text(`当前设备: ${this.getDeviceName()}`)
        .fontSize(12)
        .fontColor('#999999')
        .margin({ top: 10 })
      
      Text(`断点: ${this.currentBreakpoint.toUpperCase()}`)
        .fontSize(12)
        .fontColor('#999999')
        .margin({ top: 5 })
    }
  }

  // 获取设备名称
  private getDeviceName(): string {
    return new BreakpointType({
      xs: '智能手表',
      sm: '手机',
      md: '折叠屏/小平板',
      lg: '平板/智慧屏/车机'
    }).getValue(this.currentBreakpoint) as string;
  }
}
