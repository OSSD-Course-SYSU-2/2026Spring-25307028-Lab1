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

import { AnimationWidgets } from '../view/AnimationWidgets';
import { CountController } from '../view/CountController';
import Common from '../common/constants/Const';
import { IconsModel } from '../viewmodel/IconsModel';
import { BreakpointSystem, BreakpointConstants, BreakpointType } from '../common/utils/BreakpointSystem';

@Entry
@Component
struct Index {
  @State quantity: number = Common.IMAGES_MIN;
  @Provide iconModel: IconsModel = new IconsModel(this.quantity, Common.OFFSET_RADIUS);
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
      // 根据断点显示不同的标题样式
      Text(this.getPageTitle())
        .fontSize(this.getTitleFontSize())
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.fontGrayColor'))
        .margin({
          top: 20,
          bottom: new BreakpointType({ sm: 10, md: 15, lg: 20 }).getValue(this.currentBreakpoint) as number
        })
        .visibility(this.currentBreakpoint === BreakpointConstants.XS ? Visibility.None : Visibility.Visible)

      // 动画区域 - 根据断点调整布局权重
      AnimationWidgets({
        quantity: $quantity
      })
      .layoutWeight(this.getAnimationWeight())

      // 控制器区域
      CountController({
        quantity: $quantity
      })
      .margin({
        bottom: this.getControllerMarginBottom()
      })
      
      // 设备信息提示（仅开发调试用）
      this.DeviceInfoHint()
    }
    .width(Common.DEFAULT_FULL_WIDTH)
    .height(Common.DEFAULT_FULL_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.bgColor'))
  }

  // 根据断点获取页面标题
  private getPageTitle(): string {
    return new BreakpointType({
      xs: '手表模式',
      sm: '手机模式',
      md: '折叠屏模式',
      lg: '平板模式'
    }).getValue(this.currentBreakpoint) as string;
  }

  // 根据断点获取标题字体大小
  private getTitleFontSize(): number {
    return new BreakpointType({
      xs: 14,
      sm: 16,
      md: 20,
      lg: 24
    }).getValue(this.currentBreakpoint) as number;
  }

  // 设备信息提示组件
  @Builder
  DeviceInfoHint() {
    if (this.currentBreakpoint !== BreakpointConstants.XS) {
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
      .margin({ bottom: 10 })
    }
  }

  // 根据断点获取动画区域布局权重
  private getAnimationWeight(): number {
    return new BreakpointType({
      xs: 1,   // 手表：默认权重
      sm: 1,   // 手机竖屏：默认权重
      md: 2,   // 折叠屏、手机横屏：更大权重
      lg: 3    // 平板、智慧屏、车机：最大权重
    }).getValue(this.currentBreakpoint) as number;
  }

  // 根据断点获取控制器底部边距
  private getControllerMarginBottom(): number {
    return new BreakpointType({
      xs: 20,   // 手表：较小边距
      sm: 48,   // 手机竖屏：默认边距
      md: 100,  // 折叠屏、手机横屏：大幅增加边距，避免遮挡
      lg: 120   // 平板、智慧屏、车机：最大边距
    }).getValue(this.currentBreakpoint) as number;
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