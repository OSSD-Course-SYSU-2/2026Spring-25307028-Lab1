if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    quantity?: number;
    iconModel?: IconsModel;
}
import { AnimationWidgets } from "@bundle:com.example.animation/entry/ets/view/AnimationWidgets";
import { CountController } from "@bundle:com.example.animation/entry/ets/view/CountController";
import Common from "@bundle:com.example.animation/entry/ets/common/constants/Const";
import { IconsModel } from "@bundle:com.example.animation/entry/ets/viewmodel/IconsModel";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__quantity = new ObservedPropertySimplePU(Common.IMAGES_MIN, this, "quantity");
        this.__iconModel = new ObservedPropertyObjectPU(new IconsModel(this.quantity, Common.OFFSET_RADIUS), this, "iconModel");
        this.addProvidedVar("iconModel", this.__iconModel, false);
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.quantity !== undefined) {
            this.quantity = params.quantity;
        }
        if (params.iconModel !== undefined) {
            this.iconModel = params.iconModel;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__quantity.purgeDependencyOnElmtId(rmElmtId);
        this.__iconModel.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__quantity.aboutToBeDeleted();
        this.__iconModel.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __quantity: ObservedPropertySimplePU<number>;
    get quantity() {
        return this.__quantity.get();
    }
    set quantity(newValue: number) {
        this.__quantity.set(newValue);
    }
    private __iconModel: ObservedPropertyObjectPU<IconsModel>;
    get iconModel() {
        return this.__iconModel.get();
    }
    set iconModel(newValue: IconsModel) {
        this.__iconModel.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width(Common.DEFAULT_FULL_WIDTH);
            Column.height(Common.DEFAULT_FULL_HEIGHT);
            Column.backgroundColor({ "id": 16777224, "type": 10001, params: [], "bundleName": "com.example.animation", "moduleName": "entry" });
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new AnimationWidgets(this, {
                        quantity: this.__quantity
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 30, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            quantity: this.quantity
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "AnimationWidgets" });
        }
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new CountController(this, {
                        quantity: this.__quantity
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 34, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            quantity: this.quantity
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "CountController" });
        }
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.animation", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
