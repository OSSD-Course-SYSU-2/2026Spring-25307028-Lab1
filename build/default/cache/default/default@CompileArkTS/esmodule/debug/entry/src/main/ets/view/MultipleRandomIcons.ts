if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MultipleRandomIcons_Params {
    iconIndices?: number[];
    displayCount?: number;
    isRefreshing?: boolean;
}
import Common from "@bundle:com.example.animation/entry/ets/common/constants/Const";
export class MultipleRandomIcons extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__iconIndices = new ObservedPropertyObjectPU([], this, "iconIndices");
        this.__displayCount = new ObservedPropertySimplePU(3, this, "displayCount");
        this.__isRefreshing = new ObservedPropertySimplePU(false, this, "isRefreshing");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MultipleRandomIcons_Params) {
        if (params.iconIndices !== undefined) {
            this.iconIndices = params.iconIndices;
        }
        if (params.displayCount !== undefined) {
            this.displayCount = params.displayCount;
        }
        if (params.isRefreshing !== undefined) {
            this.isRefreshing = params.isRefreshing;
        }
    }
    updateStateVars(params: MultipleRandomIcons_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__iconIndices.purgeDependencyOnElmtId(rmElmtId);
        this.__displayCount.purgeDependencyOnElmtId(rmElmtId);
        this.__isRefreshing.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__iconIndices.aboutToBeDeleted();
        this.__displayCount.aboutToBeDeleted();
        this.__isRefreshing.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __iconIndices: ObservedPropertyObjectPU<number[]>;
    get iconIndices() {
        return this.__iconIndices.get();
    }
    set iconIndices(newValue: number[]) {
        this.__iconIndices.set(newValue);
    }
    private __displayCount: ObservedPropertySimplePU<number>; // 默认展示3个图标
    get displayCount() {
        return this.__displayCount.get();
    }
    set displayCount(newValue: number) {
        this.__displayCount.set(newValue);
    }
    private __isRefreshing: ObservedPropertySimplePU<boolean>;
    get isRefreshing() {
        return this.__isRefreshing.get();
    }
    set isRefreshing(newValue: boolean) {
        this.__isRefreshing.set(newValue);
    }
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.justifyContent(FlexAlign.Start);
            Column.padding({ top: 20 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 图标展示区域
            Flex.create({
                wrap: FlexWrap.Wrap,
                justifyContent: FlexAlign.SpaceEvenly
            });
            // 图标展示区域
            Flex.width('100%');
            // 图标展示区域
            Flex.height(200);
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const iconIndex = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.width(80);
                    Column.height(100);
                    Column.justifyContent(FlexAlign.Center);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create(Common.IMAGE_RESOURCE[iconIndex]);
                    Context.animation({
                        duration: 400,
                        delay: index * 100,
                        curve: Curve.EaseInOut
                    });
                    Image.width(60);
                    Image.height(60);
                    Image.objectFit(ImageFit.Contain);
                    Image.rotate({ angle: this.isRefreshing ? 360 : 0 });
                    Image.scale({
                        x: this.isRefreshing ? 0.3 : 1,
                        y: this.isRefreshing ? 0.3 : 1
                    });
                    Image.opacity(this.isRefreshing ? 0.2 : 1);
                    Context.animation(null);
                }, Image);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(`#${iconIndex + 1}`);
                    Text.fontSize(12);
                    Text.fontColor('#999999');
                    Text.margin({ top: 4 });
                }, Text);
                Text.pop();
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, this.iconIndices, forEachItemGenFunction, undefined, true, false);
        }, ForEach);
        ForEach.pop();
        // 图标展示区域
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 控制区域
            Column.create();
            // 控制区域
            Column.margin({ top: 20 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 数量调节
            Row.create();
            // 数量调节
            Row.margin({ bottom: 15 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('展示数量:');
            Text.fontSize(14);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('-');
            Button.width(40);
            Button.height(30);
            Button.fontSize(18);
            Button.margin({ left: 10, right: 10 });
            Button.enabled(this.displayCount > 1);
            Button.onClick(() => {
                if (this.displayCount > 1) {
                    this.displayCount--;
                    this.randomizeAllIcons();
                }
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.displayCount}`);
            Text.fontSize(16);
            Text.fontWeight(FontWeight.Bold);
            Text.width(30);
            Text.textAlign(TextAlign.Center);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('+');
            Button.width(40);
            Button.height(30);
            Button.fontSize(18);
            Button.margin({ left: 10 });
            Button.enabled(this.displayCount < Common.IMAGE_RESOURCE.length);
            Button.onClick(() => {
                if (this.displayCount < Common.IMAGE_RESOURCE.length) {
                    this.displayCount++;
                    this.randomizeAllIcons();
                }
            });
        }, Button);
        Button.pop();
        // 数量调节
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 刷新按钮
            Button.createWithLabel('随机刷新');
            // 刷新按钮
            Button.width(150);
            // 刷新按钮
            Button.height(45);
            // 刷新按钮
            Button.fontSize(16);
            // 刷新按钮
            Button.backgroundColor('#007DFF');
            // 刷新按钮
            Button.onClick(() => {
                this.refreshAllIcons();
            });
        }, Button);
        // 刷新按钮
        Button.pop();
        // 控制区域
        Column.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
