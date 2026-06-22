import Point from "@bundle:com.example.animation/entry/ets/viewmodel/Point";
@Observed
export default class IconItem {
    index: number = 0;
    clicked: boolean = false;
    image: Resource = { "id": 16777239, "type": 20000, params: [], "bundleName": "com.example.animation", "moduleName": "entry" };
    point: Point = new Point(0, 0);
    constructor(index: number, image: Resource, clicked: boolean, point: Point) {
        this.index = index;
        this.image = image;
        this.clicked = clicked;
        this.point = point;
    }
}
