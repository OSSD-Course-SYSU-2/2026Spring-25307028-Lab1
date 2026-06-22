export enum BreakpointType {
  SM = 'sm',
  MD = 'md',
  LG = 'lg'
}

export class BreakpointConstants {
  static readonly RANGE_SM: string = '0-520vp';
  static readonly RANGE_MD: string = '520-840vp';
  static readonly RANGE_LG: string = '840vp+';

  static getIconSize(currentBreakpoint: string): number {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return 48;
      case BreakpointType.MD:
        return 58;
      case BreakpointType.LG:
        return 72;
      default:
        return 58;
    }
  }

  static getOffsetRadius(currentBreakpoint: string): number {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return 100;
      case BreakpointType.MD:
        return 145;
      case BreakpointType.LG:
        return 200;
      default:
        return 145;
    }
  }

  static getButtonSize(currentBreakpoint: string): number {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return 48;
      case BreakpointType.MD:
        return 64;
      case BreakpointType.LG:
        return 80;
      default:
        return 64;
    }
  }

  static getControllerWidth(currentBreakpoint: string): string {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return '280vp';
      case BreakpointType.MD:
        return '336vp';
      case BreakpointType.LG:
        return '400vp';
      default:
        return '336vp';
    }
  }

  static getControllerHeight(currentBreakpoint: string): string {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return '90vp';
      case BreakpointType.MD:
        return '97vp';
      case BreakpointType.LG:
        return '120vp';
      default:
        return '97vp';
    }
  }

  static getFontSize(currentBreakpoint: string): number {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return 12;
      case BreakpointType.MD:
        return 16;
      case BreakpointType.LG:
        return 20;
      default:
        return 16;
    }
  }

  static getScaleRatio(currentBreakpoint: string): number {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return 1.15;
      case BreakpointType.MD:
        return 1.25;
      case BreakpointType.LG:
        return 1.35;
      default:
        return 1.25;
    }
  }

  static getInitScale(currentBreakpoint: string): number {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return 0.8;
      case BreakpointType.MD:
        return 0.75;
      case BreakpointType.LG:
        return 0.7;
      default:
        return 0.75;
    }
  }

  static getRotationSpeed(currentBreakpoint: string): number {
    switch (currentBreakpoint) {
      case BreakpointType.SM:
        return 1;
      case BreakpointType.MD:
        return 2;
      case BreakpointType.LG:
        return 3;
      default:
        return 2;
    }
  }
}