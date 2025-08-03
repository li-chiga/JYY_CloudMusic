# JYYcloudmusic

## 一、搭建项目框架

    flags:Qt.FramelessWindowHint |	#无边框
    Qt.Window |					   #顶级窗口
    Qt.WindowSystemMenuHint |	    #系统菜单支持	
    Qt.WindowMaximizeButtonHint | 
    Qt.WindowMinimizeButtonHint
1. **Qt::FramelessWindowHint**：移除窗口边框和默认标题栏，实现完全自定义界面
2. **Qt::Window**：声明为独立顶级窗口（非子控件），确保窗口行为符合预期（如任务栏显示、窗口管理器交互）。
3. **Qt::WindowSystemMenuHint**：启用系统菜单（右键标题栏菜单），提供 **关闭、移动、大小调整** 等原生选项。
4. **Qt::WindowMaximizeButtonHint | Qt::WindowMinimizeButtonHint**：在标题栏显示 **最大化** 和 **最小化** 按钮。

## 二、实现窗口（在显示屏幕）上可拖动功能

```C++
MouseArea{
    anchors.fill: parent
    //自定义属性：int real string var point ListModel
    //property point clickPosion: "0,0"
    property point clickPos: "0,0"
        
    onPressed: function(mouse){
        clickPos = Qt.point(mouse.x,mouse.y)
        // console.log(clickPosion)
    }
    onPositionChanged: function(mouse){
        //let delta = Qt.point(mouse.x-clickPosion.x,mouse.y-clickPosion.y)
        //Window.x += delta.x
        //Window.y += delta.y
            
        let delta = Qt.point(mouse.x-clickPos.x,mouse.y-clickPos.y)
        mainWindow.x += delta.x
        mainWindow.y += delta.y
    }
}
```
编译错误：

1. `ReferenceError: point is not defined`
2. `ReferenceError: window is not defined`

### 主要修复点：

1. **添加窗口ID**：

   qml

   ```
   id: mainWindow
   ```

   这是解决`window is not defined`错误的关键。在MouseArea中通过`mainWindow`引用窗口。

2. **修复属性名拼写**：

   qml

   ```
   property point clickPos: "0,0"  // 原clickPosion有拼写错误
   ```

3. **使用箭头函数语法**：

   qml

   ```
   onPressed: (mouse) => { ... }
   ```

   更现代的语法，避免作用域问题

### 涉及到的语法使用基本问题：

#### 1、使用let自定义问题： QML 文件中嵌入 **JavaScript 代码段** 时，才可能使用 `let`

```C++
Item {
    function calculateArea(w, h) {
        let area = w * h;  // ✅ 这里是 JavaScript 代码，可以用 let
        return area;
    }

    Component.onCompleted: {
        let message = "Hello from JS";
        console.log(message);
    }
}
```

#### 2、QML 中，使用 `property` 关键字声明自定义属性

基本语法

```
property <type> <name>[: <initialValue>]
```

- **<type>**: 属性的数据类型（如：`int`, `string`, `real`, `var`, `point` 等）

- **<name>**: 属性名称（遵循 JavaScript 变量命名规则）

- **<initialValue>**: 可选的初始值

  ### 支持的数据类型

  QML 支持多种数据类型作为属性：

  1. **基本类型**:
     - `int`: 整数 `property int count: 10`
     - `real`: 浮点数 `property real scale: 1.5`
     - `bool`: 布尔值 `property bool isActive: true`
     - `string`: 字符串 `property string title: "Hello"`
  2. **复杂类型**:
     - `point`: 点坐标 `property point position: Qt.point(100, 200)`
     - `size`: 尺寸 `property size area: Qt.size(300, 400)`
     - `rect`: 矩形 `property rect area: Qt.rect(10, 10, 100, 100)`
     - `color`: 颜色 `property color bgColor: "blue"`
  3. **通用类型**:
     - `var`: 通用类型（可存储任何值）`property var anyData: [1, "text", Qt.point(0,0)]`
     - `list`: 列表 `property list<Item> children`

  ------

  ### 使用要点与最佳实践

  1. **属性绑定**：

     qml

     ```C++
     property int width: parent.width / 2  // 自动更新
     ```

     当 `parent.width` 变化时，此属性会自动重新计算

  2. **属性变更信号**：
     QML 会自动为属性生成 `on<PropertyName>Changed` 信号处理器

     qml

     ```C++
     property point clickPosition: "0,0"
     
     onClickPositionChanged: {
         console.log("Position changed to:", clickPosition.x, clickPosition.y)
     }
     ```

  3. **对象属性**：

     qml

     ```C++
     property Rectangle childRect: Rectangle {
         width: 50
         height: 50
         color: "red"
     }
     ```

  4. **只读属性**：

     qml

     ```C++
     readonly property real aspectRatio: width / height
     ```

  5. **默认属性**：

     qml

     ```C++
     default property alias content: container.children
     ```

  6. **属性别名**：

     qml

     ```C++
     property alias text: innerText.text
     Text { id: innerText }
     ```

  