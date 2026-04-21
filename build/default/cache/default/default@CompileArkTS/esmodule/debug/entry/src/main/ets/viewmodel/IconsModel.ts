import Common from "@bundle:com.example.animation/entry/ets/common/constants/Const";
import IconItem from "@bundle:com.example.animation/entry/ets/viewmodel/IconItem";
import Point from "@bundle:com.example.animation/entry/ets/viewmodel/Point";
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
        }
        else {
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
        const angle = TWO_PI * index / this.num;
        const x = this.radius * Math.cos(angle);
        const y = this.radius * Math.sin(angle);
        const point = new Point(x, y);
        // 缓存结果
        this.angleCache.set(cacheKey, point);
        return point;
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
}
