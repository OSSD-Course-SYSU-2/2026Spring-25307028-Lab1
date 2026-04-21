if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AnimationWidgets_Params {
    mainFlag?: boolean;
    quantity?: number;
    iconModel?: IconsModel;
    rotationAngle?: number;
    rotationTimer?: number;
}
import type { IconsModel } from '../viewmodel/IconsModel';
import { IconAnimation } from "@bundle:com.example.animation/entry/ets/view/IconAnimation";
import Common from "@bundle:com.example.animation/entry/ets/common/constants/Const";
import type IconItem from '../viewmodel/IconItem';
export class AnimationWidgets extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__mainFlag = new ObservedPropertySimplePU(false, this, "mainFlag");
        this.__quantity = new SynchedPropertySimpleTwoWayPU(params.quantity, this, "quantity");
        this.__iconModel = this.initializeConsume("iconModel", "iconModel");
        this.__rotationAngle = new ObservedPropertySimplePU(0, this, "rotationAngle");
        this.rotationTimer = -1;
        this.setInitiallyProvidedValue(params);
        this.declareWatch("quantity", this.onQuantityChange);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AnimationWidgets_Params) {
        if (params.mainFlag !== undefined) {
            this.mainFlag = params.mainFlag;
        }
        if (params.rotationAngle !== undefined) {
            this.rotationAngle = params.rotationAngle;
        }
        if (params.rotationTimer !== undefined) {
            this.rotationTimer = params.rotationTimer;
        }
    }
    updateStateVars(params: AnimationWidgets_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__mainFlag.purgeDependencyOnElmtId(rmElmtId);
        this.__quantity.purgeDependencyOnElmtId(rmElmtId);
        this.__iconModel.purgeDependencyOnElmtId(rmElmtId);
        this.__rotationAngle.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__mainFlag.aboutToBeDeleted();
        this.__quantity.aboutToBeDeleted();
        this.__iconModel.aboutToBeDeleted();
        this.__rotationAngle.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __mainFlag: ObservedPropertySimplePU<boolean>;
    get mainFlag() {
        return this.__mainFlag.get();
    }
    set mainFlag(newValue: boolean) {
        this.__mainFlag.set(newValue);
    }
    private __quantity: SynchedPropertySimpleTwoWayPU<number>;
    get quantity() {
        return this.__quantity.get();
    }
    set quantity(newValue: number) {
        this.__quantity.set(newValue);
    }
    private __iconModel: ObservedPropertyAbstractPU<IconsModel>;
    get iconModel() {
        return this.__iconModel.get();
    }
    set iconModel(newValue: IconsModel) {
        this.__iconModel.set(newValue);
    }
    private __rotationAngle: ObservedPropertySimplePU<number>; // 持续旋转角度
    get rotationAngle() {
        return this.__rotationAngle.get();
    }
    set rotationAngle(newValue: number) {
        this.__rotationAngle.set(newValue);
    }
    private rotationTimer: number; // 旋转定时器
    onQuantityChange() {
        this.iconModel.addImage(this.quantity);
    }
    aboutToAppear() {
        this.onQuantityChange();
    }
    aboutToDisappear() {
        // 组件销毁时清除定时器
        if (this.rotationTimer !== -1) {
            clearInterval(this.rotationTimer);
            this.rotationTimer = -1;
        }
    }
    // 开始持续旋转动画 - 优化：增加间隔减少重绘频率
    private startRotation() {
        if (this.rotationTimer !== -1) {
            clearInterval(this.rotationTimer);
        }
        // 每100毫秒旋转2度，实现流畅但性能更优的旋转效果
        this.rotationTimer = setInterval(() => {
            this.rotationAngle = (this.rotationAngle + 2) % 360;
        }, 100);
    }
    // 停止旋转动画
    private stopRotation() {
        if (this.rotationTimer !== -1) {
            clearInterval(this.rotationTimer);
            this.rotationTimer = -1;
        }
    }
    // 平滑重置旋转角度到0度（收起时使用）
    private smoothResetAngle() {
        this.getUIContext().animateTo({
            duration: Common.DURATION_500,
            curve: Curve.Smooth,
            playMode: PlayMode.Normal
        }, () => {
            this.rotationAngle = 0;
        });
    }
    animate() {
        this.getUIContext().animateTo({
            delay: Common.DELAY_10,
            tempo: Common.TEMPO,
            iterations: 1,
            duration: Common.DURATION_500,
            curve: Curve.Smooth,
            playMode: PlayMode.Normal
        }, () => {
            this.mainFlag = !this.mainFlag;
            // 展开时开始旋转，收起时停止旋转
            if (this.mainFlag) {
                // 延迟启动旋转，等待展开动画完成
                setTimeout(() => {
                    this.startRotation();
                }, Common.DURATION_500);
            }
            else {
                // 停止旋转定时器
                this.stopRotation();
                // 同时启动角度归零动画，与收起动画同步
                this.smoothResetAngle();
            }
        });
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.width(Common.DEFAULT_FULL_WIDTH);
            Stack.layoutWeight(1);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.width(Common.DEFAULT_FULL_WIDTH);
            Stack.height(Common.DEFAULT_FULL_HEIGHT);
            Stack.rotate({
                x: 0,
                y: 0,
                z: 1,
                angle: this.rotationAngle
            });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new IconAnimation(this, {
                                item: item,
                                mainFlag: this.__mainFlag,
                                containerRotationAngle: this.__rotationAngle
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/view/AnimationWidgets.ets", line: 107, col: 11 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    item: item,
                                    mainFlag: this.mainFlag,
                                    containerRotationAngle: this.rotationAngle
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                item: item
                            });
                        }
                    }, { name: "IconAnimation" });
                }
            };
            this.forEachUpdateFunction(elmtId, this.iconModel.imagerArr, forEachItemGenFunction, (item: IconItem) => item.index.toString(), false, false);
        }, ForEach);
        ForEach.pop();
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.mainFlag ? { "id": 16777246, "type": 20000, params: [], "bundleName": "com.example.animation", "moduleName": "entry" } : { "id": 16777247, "type": 20000, params: [], "bundleName": "com.example.animation", "moduleName": "entry" });
            Image.width({ "id": 16777238, "type": 10002, params: [], "bundleName": "com.example.animation", "moduleName": "entry" });
            Image.height({ "id": 16777238, "type": 10002, params: [], "bundleName": "com.example.animation", "moduleName": "entry" });
            Image.objectFit(ImageFit.Contain);
            Image.scale({
                x: this.mainFlag ? Common.INIT_SCALE : 1,
                y: this.mainFlag ? Common.INIT_SCALE : 1
            });
            Image.onClick(() => {
                // 收起时停止旋转
                if (this.mainFlag) {
                    this.stopRotation();
                }
                // 每次展开时重新随机选择图标
                if (!this.mainFlag) {
                    this.iconModel.refreshRandomIcons();
                }
                this.iconModel.reset();
                this.animate();
            });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777222, "type": 10003, params: [], "bundleName": "com.example.animation", "moduleName": "entry" });
            Text.fontSize({ "id": 16777232, "type": 10002, params: [], "bundleName": "com.example.animation", "moduleName": "entry" });
            Text.opacity(Common.OPACITY_06);
            Text.fontColor({ "id": 16777225, "type": 10001, params: [], "bundleName": "com.example.animation", "moduleName": "entry" });
            Text.fontWeight(Common.FONT_WEIGHT_500);
            Text.margin({
                top: { "id": 16777228, "type": 10002, params: [], "bundleName": "com.example.animation", "moduleName": "entry" }
            });
        }, Text);
        Text.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
