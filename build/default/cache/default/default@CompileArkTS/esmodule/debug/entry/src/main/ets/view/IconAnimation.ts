if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface IconAnimation_Params {
    mainFlag?: boolean;
    item?: IconItem;
    containerRotationAngle?: number;
}
import type IconItem from '../viewmodel/IconItem';
import Common from "@bundle:com.example.animation/entry/ets/common/constants/Const";
export class IconAnimation extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__mainFlag = new SynchedPropertySimpleTwoWayPU(params.mainFlag, this, "mainFlag");
        this.__item = new SynchedPropertyNesedObjectPU(params.item, this, "item");
        this.__containerRotationAngle = new SynchedPropertySimpleTwoWayPU(params.containerRotationAngle, this, "containerRotationAngle");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: IconAnimation_Params) {
        this.__item.set(params.item);
    }
    updateStateVars(params: IconAnimation_Params) {
        this.__item.set(params.item);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__mainFlag.purgeDependencyOnElmtId(rmElmtId);
        this.__item.purgeDependencyOnElmtId(rmElmtId);
        this.__containerRotationAngle.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__mainFlag.aboutToBeDeleted();
        this.__item.aboutToBeDeleted();
        this.__containerRotationAngle.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __mainFlag: SynchedPropertySimpleTwoWayPU<boolean>;
    get mainFlag() {
        return this.__mainFlag.get();
    }
    set mainFlag(newValue: boolean) {
        this.__mainFlag.set(newValue);
    }
    private __item: SynchedPropertyNesedObjectPU<IconItem>;
    get item() {
        return this.__item.get();
    }
    private __containerRotationAngle: SynchedPropertySimpleTwoWayPU<number>; // 容器旋转角度
    get containerRotationAngle() {
        return this.__containerRotationAngle.get();
    }
    set containerRotationAngle(newValue: number) {
        this.__containerRotationAngle.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.translate(this.mainFlag ? { x: this.item.point.x, y: this.item.point.y } : { x: 0, y: 0 });
            Column.rotate({
                x: 0,
                y: 0,
                z: 1,
                angle: -this.containerRotationAngle
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.item.image);
            Context.animation({
                delay: Common.DELAY_10,
                duration: Common.DURATION_1000,
                iterations: 1,
                curve: Curve.Smooth,
                playMode: PlayMode.Normal
            });
            Image.width(Common.ICON_WIDTH);
            Image.height(Common.ICON_HEIGHT);
            Image.objectFit(ImageFit.Contain);
            Image.rotate({
                x: 0,
                y: 1,
                z: 0,
                angle: this.item.clicked ? Common.ROTATE_ANGLE_360 : 0
            });
            Image.scale(this.item.clicked ? { x: Common.SCALE_RATIO, y: Common.SCALE_RATIO } : { x: 1, y: 1 });
            Image.opacity(this.item.clicked ? Common.OPACITY_06 : 1);
            Image.onClick(() => {
                this.item.clicked = !this.item.clicked;
            });
            Context.animation(null);
        }, Image);
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
