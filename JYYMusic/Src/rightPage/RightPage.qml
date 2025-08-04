import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import "../title"

Rectangle {
    //搜索框
    Row{
        id:searchRow
        spacing: 10
        anchors.left: parent.left
        anchors.leftMargin: 36
        anchors.verticalCenter: otherRow.verticalCenter
        Rectangle{
            id:backForwardRect
            width: 24
            height: 35
            radius: 4
            color: "transparent"
            border.width: 1
            border.color: "#2b2b31"
            Image {
                anchors.centerIn: parent
                source: "/img/Resources/title/arrow.png"
            }
        }
        //输入框
        TextField{
            id:searchTextField
            height: backForwardRect.height
            width: 240
            placeholderText:"晴天"
            font.pixelSize:16
            font.family:"微软雅黑 Light"
            leftPadding:40
            color: "white"
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
                }
            }
        }
        Rectangle{
            id:soundHoundRect
            height: backForwardRect.height
            width: height
            radius: 8
            color: "#241C26"
            border.color: "#36262f"
            border.width: 1
            Image {
                id: musicDiscIcon
                anchors.verticalCenter: parent.verticalCenter
                source: "/img/Resources/title/record.png"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    soundHoundRect.color = "#36262f"
                }
                onExited: {
                    soundHoundRect.color = "241c26"
                }
            }
        }
    }
    //登录
    UserCommonSetting{
        id:otherRow
        spacing: 5
        anchors.verticalCenter: minMAx.verticalCenter
        anchors.right: minMAx.left
        anchors.rightMargin: 10
    }

    //最大化、最小化、退出
    MinAndMax{
        id:minMAx
        width: 180
        //anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height:60
    }
}

