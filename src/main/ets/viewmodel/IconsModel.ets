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
import IconItem from './IconItem';
import Point from './Point';

const TWO_PI: number = 2 * Math.PI;

@Observed
export class IconsModel {
  public imagerArr: Array<IconItem> = [];
  private num: number = Common.IMAGES_MIN;
  private radius: number;
  private selectedIconIndices: number[] = []; // 存储随机选择的图标索引

  constructor(num: number, radius: number) {
    this.radius = radius;
    this.addImage(num);
  }

  // 随机选择不重复的图标索引 - 使用Fisher-Yates洗牌算法优化
  private randomizeIconIndices(count: number) {
    const totalIcons = Common.IMAGE_RESOURCE.length;
    const selectCount = Math.min(count, totalIcons);
    
    // 创建索引数组
    const indices: number[] = [];
    for (let i = 0; i < totalIcons; i++) {
      indices.push(i);
    }
    
    // Fisher-Yates部分洗牌，只洗前selectCount个
    for (let i = 0; i < selectCount; i++) {
      const randomPos = i + Math.floor(Math.random() * (totalIcons - i));
      // 交换位置（不使用解构赋值）
      const temp = indices[i];
      indices[i] = indices[randomPos];
      indices[randomPos] = temp;
    }
    
    // 取前selectCount个作为结果
    this.selectedIconIndices = indices.slice(0, selectCount);
  }

  public addImage(num: number) {
    this.num = num;
    if (this.imagerArr.length === num) {
      return;
    }
    if (this.imagerArr.length > num) {
      this.imagerArr.splice(num, this.imagerArr.length - num);
    } else {
      // 随机选择图标索引
      this.randomizeIconIndices(num);
      
      for (let i = this.imagerArr.length; i < num; i++) {
        const point = this.genPointByIndex(i);
        // 使用随机选择的图标索引
        const iconIndex = this.selectedIconIndices[i];
        this.imagerArr.push(new IconItem(i, Common.IMAGE_RESOURCE[iconIndex], false, point));
      }
    }

    this.refreshPoint(num);
  }

  public refreshPoint(num: number) {
    for (let i = 0; i < num; i++) {
      this.imagerArr[i].point = this.genPointByIndex(i);
    }
  }

  // 缓存角度计算结果
  private angleCache: Map<number, Point> = new Map();
  
  public genPointByIndex(index: number): Point {
    // 使用缓存避免重复计算
    const cacheKey = index * 1000 + this.num; // 组合键
    const cached = this.angleCache.get(cacheKey);
    if (cached) {
      return cached;
    }
    
    // 根据图标数量动态调整半径，确保图标不重叠
    // 图标尺寸为58x58，最小间距为20px
    const iconSize = 58; // 图标尺寸
    const minSpacing = 20; // 最小间距
    const effectiveRadius = this.calculateEffectiveRadius(iconSize, minSpacing);
    
    const angle = TWO_PI * index / this.num;
    const x = effectiveRadius * Math.cos(angle);
    const y = effectiveRadius * Math.sin(angle);
    const point = new Point(x, y);
    
    // 缓存结果
    this.angleCache.set(cacheKey, point);
    return point;
  }
  
  // 计算有效半径，考虑图标数量和尺寸
  private calculateEffectiveRadius(iconSize: number, minSpacing: number): number {
    if (this.num <= 1) {
      return this.radius;
    }
    
    // 计算最小需要的半径，确保图标不重叠
    const minRequiredRadius = (iconSize + minSpacing) / (2 * Math.sin(Math.PI / this.num));
    
    // 使用较大的半径：传入的半径和计算的最小半径中的较大值
    return Math.max(this.radius, minRequiredRadius);
  }

  public reset() {
    // 直接遍历设置，减少条件判断
    for (let i = 0; i < this.num; i++) {
      this.imagerArr[i].clicked = false;
    }
  }

  // 重新随机选择图标（每次展开时调用）
  public refreshRandomIcons() {
    this.randomizeIconIndices(this.num);
    const resources = Common.IMAGE_RESOURCE;
    for (let i = 0; i < this.num; i++) {
      this.imagerArr[i].image = resources[this.selectedIconIndices[i]];
    }
  }

  // 更新展开半径
  public updateRadius(newRadius: number) {
    this.radius = newRadius;
    this.angleCache.clear(); // 清除缓存，因为半径改变会影响坐标计算
    this.refreshPoint(this.num);
  }
}