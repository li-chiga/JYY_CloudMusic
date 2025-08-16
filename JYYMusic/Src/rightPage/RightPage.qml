import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import "../title"

Rectangle {
    //搜索框
    Search{
        id:searchRow
        spacing: 10
        anchors.left: parent.left
        anchors.leftMargin: 36
        anchors.verticalCenter: otherRow.verticalCenter
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

