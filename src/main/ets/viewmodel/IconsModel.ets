import Common from '../common/constants/Const';
import IconItem from './IconItem';
import Point from './Point';

const TWO_PI: number = 2 * Math.PI;

@Observed
export class IconsModel {
  public imagerArr: Array<IconItem> = [];
  private num: number = Common.IMAGES_MIN;
  private radius: number;
  private selectedIconIndices: number[] = [];

  constructor(num: number, radius: number) {
    this.radius = radius;
    this.addImage(num);
  }

  public updateRadius(newRadius: number) {
    if (this.radius === newRadius) {
      return;
    }
    this.radius = newRadius;
    this.angleCache.clear();
    this.refreshPoint(this.num);
  }

  private randomizeIconIndices(count: number) {
    const totalIcons = Common.IMAGE_RESOURCE.length;
    const selectCount = Math.min(count, totalIcons);

    const indices: number[] = [];
    for (let i = 0; i < totalIcons; i++) {
      indices.push(i);
    }

    for (let i = 0; i < selectCount; i++) {
      const randomPos = i + Math.floor(Math.random() * (totalIcons - i));
      const temp = indices[i];
      indices[i] = indices[randomPos];
      indices[randomPos] = temp;
    }

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
      this.randomizeIconIndices(num);

      for (let i = this.imagerArr.length; i < num; i++) {
        const point = this.genPointByIndex(i);
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

  private angleCache: Map<number, Point> = new Map();

  public genPointByIndex(index: number): Point {
    const cacheKey = index * 1000 + this.num;
    const cached = this.angleCache.get(cacheKey);
    if (cached) {
      return cached;
    }

    const angle = TWO_PI * index / this.num;
    const x = this.radius * Math.cos(angle);
    const y = this.radius * Math.sin(angle);
    const point = new Point(x, y);

    this.angleCache.set(cacheKey, point);
    return point;
  }

  public reset() {
    for (let i = 0; i < this.num; i++) {
      this.imagerArr[i].clicked = false;
    }
  }

  public refreshRandomIcons() {
    this.randomizeIconIndices(this.num);
    const resources = Common.IMAGE_RESOURCE;
    for (let i = 0; i < this.num; i++) {
      this.imagerArr[i].image = resources[this.selectedIconIndices[i]];
    }
  }
}
