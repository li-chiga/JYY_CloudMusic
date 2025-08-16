import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "./../basic"

Item {
    id:jyyRadioButtonRoot
    height: 25
    width: 155
    property bool enabledState: true
    property string contentText
    property bool checked: false
    property bool showIcon: false
    property string VipText: "VIP开通"
    property color outerCircleColor: "#dadada"
    property color innerCircleColor: "#cecece"
    property color rightRectColor: "#dadada"
    property color textColor: "#f8f9f9"
    property ExclusiveGroup exclusiveGroup
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            cursorShape = parent.enabledState?Qt.PointingHandCursor:Qt.ForbiddenCursor
        }
        onExited: {
            cursorShape = Qt.ArrowCursor
        }
    }
    Component{
        id:radioButtonStyle
        RadioButtonStyle{
            indicator: Rectangle{
                implicitHeight: 24
                implicitWidth: 24
                radius: 12
                color: "transparent"
                border.color:"red"
                border.width: 1
                Rectangle{
                    anchors.fill: parent
                    visible: control.checked
                    // color: "red"
                    color: jyyRadioButtonRoot.enabledState?"#eb4d44":"#532426"
                    radius: width/2
                    anchors.margins: 5
                }
            }
            label: Text{
               color:jyyRadioButtonRoot.enabledState?"#ddd":"#707074"
               font.pixelSize: 18
               font.family: "黑体"
               verticalAlignment: Text.AlignVCenter
               height: jyyRadioButtonRoot.height
               width: control.text
               JYYVipIconItem{
                    width: 50
               }
            }
        }
    }
}
