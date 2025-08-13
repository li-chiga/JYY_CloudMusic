import QtQuick 2.15
import QtQuick.Controls 2.15
import "../basic"

//输入框
TextField{

    Connections{
        target: BasicConfig
        //onblankAreaClicked:{}
        function onBlankAreaClicked(){
            innerRect.gradientStopPos = 1
        }
    }
    background: Rectangle{//外部矩形
        anchors.fill: parent
        radius:8
        gradient: Gradient{//外部矩形渐变
            orientation: Gradient.Horizontal    //水平方向渐变
            GradientStop{color: "#21283d";position: 0}
            GradientStop{color: "#382635";position: 1}
        }
        Rectangle{//内部矩形
            id:innerRect
            anchors.fill:parent
            radius:8
            anchors.margins:1
            property real gradientStopPos: 1
            gradient: Gradient{//外部矩形渐变
                orientation: Gradient.Horizontal    //水平方向渐变
                GradientStop{color: "#1a1d29";position: 0}
                GradientStop{color: "#241c26";position: innerRect.gradientStopPos}
            }
        }
    }
    Image {
        id: searchIcon
        scale: 0.6
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
        source: "/img/Resources/title/search.png"
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            innerRect.gradientStopPos = 0
            searchPop.open()
        }
    }
}

