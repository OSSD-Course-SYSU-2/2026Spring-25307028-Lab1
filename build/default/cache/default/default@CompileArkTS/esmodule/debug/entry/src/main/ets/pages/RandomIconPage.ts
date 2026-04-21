if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface RandomIconPage_Params {
    currentMode?: number;
}
import { RandomIcon } from "@bundle:com.example.animation/entry/ets/view/RandomIcon";
import { MultipleRandomIcons } from "@bundle:com.example.animation/entry/ets/view/MultipleRandomIcons";
class RandomIconPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__currentMode = new ObservedPropertySimplePU(0, this, "currentMode");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: RandomIconPage_Params) {
        if (params.currentMode !== undefined) {
            this.currentMode = params.currentMode;
        }
    }
    updateStateVars(params: RandomIconPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentMode.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentMode.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __currentMode: ObservedPropertySimplePU<number>; // 0: 单个图标, 1: 多个图标
    get currentMode() {
        return this.__currentMode.get();
    }
    set currentMode(newValue: number) {
        this.__currentMode.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F5F5F5');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 标题
            Text.create('随机图标展示');
            // 标题
            Text.fontSize(24);
            // 标题
            Text.fontWeight(FontWeight.Bold);
            // 标题
            Text.margin({ bottom: 20 });
        }, Text);
        // 标题
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 模式切换按钮
            Row.create();
            // 模式切换按钮
            Row.margin({ bottom: 20 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('单个图标');
            Button.width(100);
            Button.height(35);
            Button.fontSize(14);
            Button.backgroundColor(this.currentMode === 0 ? '#007DFF' : '#E0E0E0');
            Button.fontColor(this.currentMode === 0 ? '#FFFFFF' : '#333333');
            Button.onClick(() => {
                this.currentMode = 0;
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('多个图标');
            Button.width(100);
            Button.height(35);
            Button.fontSize(14);
            Button.margin({ left: 20 });
            Button.backgroundColor(this.currentMode === 1 ? '#007DFF' : '#E0E0E0');
            Button.fontColor(this.currentMode === 1 ? '#FFFFFF' : '#333333');
            Button.onClick(() => {
                this.currentMode = 1;
            });
        }, Button);
        Button.pop();
        // 模式切换按钮
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 根据模式显示不同组件
            if (this.currentMode === 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new RandomIcon(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/RandomIconPage.ets", line: 59, col: 9 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {};
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, { name: "RandomIcon" });
                    }
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new MultipleRandomIcons(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/RandomIconPage.ets", line: 61, col: 9 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {};
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, { name: "MultipleRandomIcons" });
                    }
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "RandomIconPage";
    }
}
registerNamedRoute(() => new RandomIconPage(undefined, {}), "", { bundleName: "com.example.animation", moduleName: "entry", pagePath: "pages/RandomIconPage", pageFullPath: "entry/src/main/ets/pages/RandomIconPage", integratedHsp: "false", moduleType: "followWithHap" });
