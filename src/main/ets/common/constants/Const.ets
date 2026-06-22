const IMAGE_ARR = [
  $r('app.media.badge1'),
  $r('app.media.badge2'),
  $r('app.media.badge3'),
  $r('app.media.badge4'),
  $r('app.media.badge5'),
  $r('app.media.badge6')
];

export default class Common {
  static readonly IMAGE_RESOURCE: Resource[] = IMAGE_ARR;
  static readonly IMAGES_TOTAL: number = IMAGE_ARR.length;
  static readonly IMAGES_MIN: number = 3;
  static readonly ROTATE_ANGLE_360: number = 360;
  static readonly DELAY_10: number = 10;
  static readonly DEFAULT_FULL_WIDTH: string = '100%';
  static readonly DEFAULT_FULL_HEIGHT: string = '100%';

  static readonly FONT_WEIGHT_500: number = 500;
  static readonly OPACITY_06: number = 0.6;

  static readonly DURATION_500: number = 500;
  static readonly TEMPO: number = 0.68;
  static readonly DURATION_1000: number = 1000;
}
