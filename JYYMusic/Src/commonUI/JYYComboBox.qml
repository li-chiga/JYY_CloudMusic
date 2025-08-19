import QtQuick 2.15
import QtQuick.Controls 2.15
import "./../basic"

ComboBox {
    id:cbx
    property int avaHeight: count < 8?count * 40 : 280
    property string text: ""
    property real indicatorRotation: 90
    leftPadding: 10
    background: Rectangle{
        anchors.fill: parent
        radius: parent.height/2
        border.width: 1
        border.color: "#28282e"
        color: "#1a1a20"
        MouseArea{
            anchors.fill: parent
            hoverEnabled:true
            onEntered:{
                cursorShape = Qt.PointingHandCursor
            }
            onExited: {
                cursorShape = Qt.ArrowCursor
            }
            onClicked:{
                cbx.popup.open()
            }
        }
    }
    indicator: Label{
        text: ">"
        font.pixelSize: 22
        font.bold: true
        font.family: "黑体"
        anchors.right: parent.right
        color: "#e9e9e9"
        anchors.verticalCenter: parent.verticalCenter
        rotation: cbx.indicatorRotation
    }
    contentItem: Text{
        text: cbx.text
        color: "white"
        font.pixelSize: 16
        font.family: BasicConfig.commFont
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    popup: Popup{
        x:0
        y:parent.height+5
        width:parent.width
        height: cbx.avaHeight
        onOpened: cbx.indicatorRotation = -90
        onClosed: cbx.indicatorRotation = 90
        background: Rectangle{
            anchors.fill: parent
            radius: 10
            color: "#2d2d37"
            clip: true
            ListView{
                anchors.fill: parent
                model: cbx.model
                ScrollBar.vertical: ScrollBar{//自定义ScrollView滚动条，不然访问不到
                    id: cusScrollBar
                    width: 10
                    policy: cusScrollBar.AsNeeded
                    contentItem: Rectangle{
                        visible: parent.active
                        color: "#42424b"
                    }
                }
                delegate: Rectangle{
                    width:cbx.width-10
                    height: 40
                    color: "transparent"
                    Text {
                        color: "#d6d6d8"
                        text: modelData
                        font.pixelSize: 16
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: BasicConfig.commFont
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.color = "#393943"
                            cursorShape = Qt.PointingHandCursor
                        }
                        onExited: {
                            parent.color = "transparent"
                            cursorShape = Qt.ArrowCursor
                        }
                        onClicked: {
                            cbx.text = modelData
                            cbx.popup.close()
                        }
                    }
                }
            }
        }
    }
}
