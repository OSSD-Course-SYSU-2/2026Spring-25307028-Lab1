/*
 * 断点系统工具类 - 用于实现一次开发多端部署
 * 支持设备：手机、平板、折叠屏、手表、智慧屏、车机
 */

import mediaQuery from '@ohos.mediaquery';

export class BreakpointSystem {
  private currentBreakpoint: string = 'sm'; // 默认小屏
  private listener: mediaQuery.MediaQueryListener | null = null;
  private smListener: mediaQuery.MediaQueryListener | null = null;
  private mdListener: mediaQuery.MediaQueryListener | null = null;
  private lgListener: mediaQuery.MediaQueryListener | null = null;

  // 断点范围说明：
  // xs: [0, 320vp)     - 智能手表
  // sm: [320, 600vp)   - 手机竖屏
  // md: [600, 840vp)   - 折叠屏、小平板、手机横屏
  // lg: [840, +∞vp)    - 平板、PC、智慧屏、车机

  register(callback?: (breakpoint: string) => void) {
    // 监听小屏断点 (320vp - 600vp)
    this.smListener = mediaQuery.matchMediaSync('(320vp <= width < 600vp)');
    this.smListener.on('change', (result: mediaQuery.MediaQueryResult) => {
      if (result.matches) {
        this.updateBreakpoint('sm', callback);
      }
    });

    // 监听中屏断点 (600vp - 840vp)
    this.mdListener = mediaQuery.matchMediaSync('(600vp <= width < 840vp)');
    this.mdListener.on('change', (result: mediaQuery.MediaQueryResult) => {
      if (result.matches) {
        this.updateBreakpoint('md', callback);
      }
    });

    // 监听大屏断点 (>= 840vp)
    this.lgListener = mediaQuery.matchMediaSync('(width >= 840vp)');
    this.lgListener.on('change', (result: mediaQuery.MediaQueryResult) => {
      if (result.matches) {
        this.updateBreakpoint('lg', callback);
      }
    });

    // 监听超小屏断点 (< 320vp) - 手表
    this.listener = mediaQuery.matchMediaSync('(width < 320vp)');
    this.listener.on('change', (result: mediaQuery.MediaQueryResult) => {
      if (result.matches) {
        this.updateBreakpoint('xs', callback);
      }
    });
  }

  private updateBreakpoint(breakpoint: string, callback?: (breakpoint: string) => void) {
    this.currentBreakpoint = breakpoint;
    // 保存到全局存储，供所有组件使用
    AppStorage.setOrCreate('currentBreakpoint', breakpoint);
    if (callback) {
      callback(breakpoint);
    }
  }

  unregister() {
    if (this.listener) {
      this.listener.off('change');
    }
    if (this.smListener) {
      this.smListener.off('change');
    }
    if (this.mdListener) {
      this.mdListener.off('change');
    }
    if (this.lgListener) {
      this.lgListener.off('change');
    }
  }

  getCurrentBreakpoint(): string {
    return this.currentBreakpoint;
  }
}

// 断点常量
export class BreakpointConstants {
  static readonly XS: string = 'xs';  // 手表
  static readonly SM: string = 'sm';  // 手机竖屏
  static readonly MD: string = 'md';  // 折叠屏、手机横屏
  static readonly LG: string = 'lg';  // 平板、智慧屏、车机
}

// 断点选项接口 - 用于 BreakpointType 构造函数参数
export interface BreakpointOptions<T> {
  xs?: T;
  sm?: T;
  md?: T;
  lg?: T;
}

// 根据断点返回不同值的工具方法
export class BreakpointType<T> {
  private xs?: T;
  private sm?: T;
  private md?: T;
  private lg?: T;

  constructor(options: BreakpointOptions<T>) {
    this.xs = options.xs;
    this.sm = options.sm;
    this.md = options.md;
    this.lg = options.lg;
  }

  getValue(breakpoint: string): T | undefined {
    switch (breakpoint) {
      case 'xs':
        return this.xs ?? this.sm; // 手表优先使用小屏配置
      case 'sm':
        return this.sm;
      case 'md':
        return this.md ?? this.sm; // 中屏降级到小屏
      case 'lg':
        return this.lg ?? this.md ?? this.sm; // 大屏降级策略
      default:
        return this.sm;
    }
  }
}
