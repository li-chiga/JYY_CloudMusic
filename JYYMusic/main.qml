import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id:mainWindow
    width: 1317
    height: 933
    visible: true
    title: qsTr("Hello World")
    flags:Qt.FramelessWindowHint | Qt.Window | Qt.WindowSystemMenuHint |
          Qt.WindowMaximizeButtonHint | Qt.WindowMinimizeButtonHint        //设置无边框属性
    signal post
    Rectangle{
        id:leftRectangle
        width:255
        anchors.top: parent.top
        anchors.bottom: bottomRect.top
        color:"#1a1a21"

    }
    Rectangle{
        id:rightRect
        anchors.left: leftRectangle.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bottomRect.top
        color:"#13131a"

    }
    Rectangle{
        id:bottomRect
        height: 100
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "#2d2d37"
    }
    //添加窗口可拖动功能
    MouseArea{
        anchors.fill: parent
        //自定义属性：int real string var point ListModel
        property point clickPosition: "0,0"
        onPressed: (mouse)=>{
            clickPosition = Qt.point(mouse.x,mouse.y)
            // console.log(clickPosition)
        }
        onPositionChanged: function(mouse){
            let delta = Qt.point(mouse.x-clickPosition.x,mouse.y-clickPosition.y)
            mainWindow.x += delta.x
            mainWindow.y += delta.y
        }
    }
}
