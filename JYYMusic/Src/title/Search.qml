import QtQuick 2.15
import QtQuick.Controls 2.15
import "../commonUI"
//搜索框
Row{

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
    //聊天输入框
    JYYSearchBox{
        id:searchTextField
        height: backForwardRect.height
        width: 300
        placeholderText:"晴天"
        font.pixelSize:16
        font.family:"微软雅黑 Light"
        leftPadding:40
        color: "white"
    }

    ListModel{
        id:searchSingModel
        ListElement{singName:"想象之中"}
        ListElement{singName:"泡沫"}
        ListElement{singName:"乌兰巴托的夜"}
        ListElement{singName:"多远都要在一起"}
        ListElement{singName:"张靓颖-我的梦"}
        ListElement{singName:"有爱的云彩-时空错位"}
        ListElement{singName:"苏慧伦-秋天的海"}
        ListElement{singName:"周杰伦-稻香"}
        ListElement{singName:"程响-等你归来"}
        ListElement{singName:"其它"}
    }

    ListModel{
        id:hotSearchSingModel
        ListElement{singName:"让离别开出花"}
        ListElement{singName:"若月亮还没来"}
        ListElement{singName:"巴赫-G弦上的咏叹"}
        ListElement{singName:"莫扎特-第四十号交响曲"}
        ListElement{singName:"石久让-人生的旋转木马"}
        ListElement{singName:"Yanni-nightgale"}
        ListElement{singName:"yanni-心兰相随"}
        ListElement{singName:"Beatlab-coding"}
        ListElement{singName:"GoodTogether"}
        ListElement{singName:"浮光"}
        ListElement{singName:"timestop"}
        ListElement{singName:"MDP - Fake Love"}
        ListElement{singName:"Athletics - III"}
        ListElement{singName:"其它"}
    }
    Popup{
        id:searchPop
        width:parent.width
        height: 800
        clip: true
        y:searchTextField.height + 10
        background: Rectangle{
            anchors.fill: parent
            radius: 8
            color: "#2d2d37"
            clip: true
            Flickable{
                anchors.fill: parent
                contentHeight: 1200
                ScrollBar.vertical: ScrollBar{
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    width: 10
                    contentItem: Rectangle{
                       visible: parent.active
                       implicitWidth: 10
                       radius: 4
                       color: "#42424b"
                    }
                }
                ScrollBar.horizontal:ScrollBar{
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin:  5
                    width: 10
                    contentItem: Rectangle{
                       visible: parent.active
                       implicitWidth: 10
                       radius: 4
                       color: "#42424b"
                    }
                }
                Column{
                    anchors.fill: parent
                    spacing: 40
                    Item {
                        id: historyTotalItem
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: historyItem.implicitHeight + searchHistoryFlow.implicitHeight + 50
                        Item {
                            id: historyItem
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: 30
                            anchors.leftMargin: 30
                            Label{
                                id:searchLab
                                color: "#7f7f85"
                                text: "搜索历史"
                                font.pixelSize: 18
                                font.family: "微软雅黑 Light"
                            }
                            Image{
                                id:removeTconImg
                                scale: 0.7
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.verticalCenter: searchLab.verticalCenter
                                source: "qrc:/img/Resources/searchBox/remove.png"
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        searchSingModel.clear()
                                        // searchSingModel.append({singName:"乌兰巴托的夜",aaa:""})
                                    }
                                }
                            }
                        }
                        Flow{
                            id:searchHistoryFlow
                            anchors.top: historyItem.bottom
                            anchors.left: historyItem.left
                            anchors.right: historyItem.right
                            anchors.topMargin: 40
                            spacing: 20
                            Repeater{
                                id:historyRep
                                anchors.fill:parent
                                model: searchSingModel
                                property bool showAllHistoryText: true
                                delegate: Rectangle{
                                    width: dataLabel.implicitWidth + 20
                                    height: 40
                                    border.width: 1
                                    border.color: "#45454e"
                                    color: "#2d2d37"
                                    radius: 15
                                    visible: index < (historyRep.showAllHistoryText?10:7)
                                    Label{
                                        id:dataLabel
                                        text: (undefined === singName) ? "":(historyRep.showAllHistoryText?(index===9?">":singName):(index === 6?">":singName))
                                        rotation: historyRep.showAllHistoryText?(index===9?-90:0):(index === 6?90:0)
                                        font.pixelSize: 20
                                        anchors.centerIn:parent
                                        color: "#ddd"
                                        font.family: "微软雅黑 Light"
                                        height: 25
                                    }
                                    MouseArea{
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered:{
                                            dataLabel.color = "white"
                                            parent.color = "#393943"
                                            cursorShape = Qt.PointingHandCursor
                                        }
                                        onExited: {
                                            dataLabel.color = "#ddd"
                                            parent.color = "#2d2d37"
                                            cursorShape = Qt.ArrowCursor
                                        }
                                        onClicked: {
                                            if(historyRep.showAllHistoryText && index ===9){
                                                historyRep.showAllHistoryText = false

                                            }else if(!historyRep.showAllHistoryText && (index === 6)){
                                                historyRep.showAllHistoryText = true
                                            }else{
                                                searchTextField.text = singName
                                                searchPop.close()
                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }

                    Item{
                        id:singListItem
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height:searchPop.height - historyTotalItem.implicitHeight
                        //热搜榜
                        Label{
                           id:hotSearchLabel
                           color: "#7f7f85"
                           text: "热搜榜"
                           anchors.left: parent.left
                           anchors.leftMargin: 30
                           height: removeTconImg.implicitHeight
                           font.pixelSize: 18
                           font.family: "微软雅黑 Light"

                        }
                        Column{
                            anchors.top: hotSearchLabel.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.topMargin: 20
                            Repeater{
                                model: hotSearchSingModel
                                //delegate是为了控制每一行数据的显示，每一个显示对象都是Rectangle
                                delegate:Rectangle{
                                    color: "transparent"
                                    width: searchHistoryFlow.implicitWidth
                                    height: 40
                                    Label{
                                        id:hotSearchIndexLabel
                                        color: index<3?"#eb4d44":"#818187"
                                        text: String(index + 1)
                                        anchors.left: parent.left
                                        anchors.leftMargin: 20
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.pixelSize: 18
                                        font.family: "微软雅黑 Light"
                                    }
                                    Label{
                                        id:hitSearchNameLabel
                                        color: "#ddd"
                                        text: singName
                                        anchors.left: hotSearchSingModel.left
                                        anchors.leftMargin: 30
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.pixelSize: 18
                                        font.family: "微软雅黑 Light"
                                    }
                                    MouseArea{
                                        anchors.fill:parent
                                        hoverEnabled: true  //控制鼠标悬停事件
                                        onEntered:{
                                            hitSearchNameLabel.color = "white"
                                            parent.color = "#393943"
                                            cursorShape = Qt.PointingHandCursor
                                        }
                                        onExited: {
                                            hitSearchNameLabel.color = "#ddd"
                                            parent.color = "#2d2d37"
                                            cursorShape = Qt.ArrowCursor
                                        }
                                        onClicked: {
                                            searchTextField.text = singName
                                            searchPop.close()
                                        }
                                    }
                                }
                            }

                        }
                    }
                }

            }
        }
        // closePolicy:
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
        // MouseArea{
        //     anchors.fill: parent
        //     hoverEnabled: true
        //     onEntered: {
        //         soundHoundRect.color = "#36262f"
        //     }
        //     onExited: {
        //         soundHoundRect.color = "241c26"
        //     }
        // }
    }
}


