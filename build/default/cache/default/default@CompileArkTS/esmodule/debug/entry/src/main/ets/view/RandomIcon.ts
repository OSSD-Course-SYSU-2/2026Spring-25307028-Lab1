if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface RandomIcon_Params {
    currentIconIndex?: number;
    isAnimating?: boolean;
}
import Common from "@bundle:com.example.animation/entry/ets/common/constants/Const";
export class RandomIcon extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__currentIconIndex = new ObservedPropertySimplePU(0, this, "currentIconIndex");
        this.__isAnimating = new ObservedPropertySimplePU(false, this, "isAnimating");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: RandomIcon_Params) {
        if (params.currentIconIndex !== undefined) {
            this.currentIconIndex = params.currentIconIndex;
        }
        if (params.isAnimating !== undefined) {
            this.isAnimating = params.isAnimating;
        }
    }
    updateStateVars(params: RandomIcon_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentIconIndex.purgeDependencyOnElmtId(rmElmtId);
        this.__isAnimating.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentIconIndex.aboutToBeDeleted();
        this.__isAnimating.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __currentIconIndex: ObservedPropertySimplePU<number>;
    get currentIconIndex() {
        return this.__currentIconIndex.get();
    }
    set currentIconIndex(newValue: number) {
        this.__currentIconIndex.set(newValue);
    }
    private __isAnimating: ObservedPropertySimplePU<boolean>;
    get isAnimating() {
        return this.__isAnimating.get();
    }
    set isAnimating(newValue: boolean) {
        this.__isAnimating.set(newValue);
    }
    aboutToAppear() {
        // 初始化时随机选择一个图标
        this.randomizeIcon();
    }
    // 随机选择图标
    private randomizeIcon() {
        const totalIcons = Common.IMAGE_RESOURCE.length;
        this.currentIconIndex = Math.floor(Math.random() * totalIcons);
    }
    // 刷新随机图标（带动画效果）
    private refreshRandomIcon() {
        this.isAnimating = true;
        setTimeout(() => {
            this.randomizeIcon();
            this.isAnimating = false;
        }, 300);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.justifyContent(FlexAlign.Center);
            Column.alignItems(HorizontalAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 随机图标展示区域
            Image.create(Common.IMAGE_RESOURCE[this.currentIconIndex]);
            Context.animation({
                duration: 300,
                curve: Curve.EaseInOut,
                playMode: PlayMode.Normal
            });
            // 随机图标展示区域
            Image.width(80);
            // 随机图标展示区域
            Image.height(80);
            // 随机图标展示区域
            Image.objectFit(ImageFit.Contain);
            // 随机图标展示区域
            Image.rotate({ angle: this.isAnimating ? 180 : 0 });
            // 随机图标展示区域
            Image.scale({
                x: this.isAnimating ? 0.5 : 1,
                y: this.isAnimating ? 0.5 : 1
            });
            // 随机图标展示区域
            Image.opacity(this.isAnimating ? 0.3 : 1);
            Context.animation(null);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 图标索引显示
            Text.create(`图标 ${this.currentIconIndex + 1} / ${Common.IMAGE_RESOURCE.length}`);
            // 图标索引显示
            Text.fontSize(14);
            // 图标索引显示
            Text.fontColor('#666666');
            // 图标索引显示
            Text.margin({ top: 12 });
        }, Text);
        // 图标索引显示
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 刷新按钮
            Button.createWithLabel('随机切换');
            // 刷新按钮
            Button.width(120);
            // 刷新按钮
            Button.height(40);
            // 刷新按钮
            Button.fontSize(16);
            // 刷新按钮
            Button.margin({ top: 20 });
            // 刷新按钮
            Button.onClick(() => {
                this.refreshRandomIcon();
            });
        }, Button);
        // 刷新按钮
        Button.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
