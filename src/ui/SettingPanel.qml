import QtQuick 2.3
import QtQuick.Controls 1.2

Item{

    id:"panelSetting"
    objectName:"panelSetting"
    visible: false
    Column{
        Button {
            text: "<-back"
            objectName: "btnBack"
        }

        Grid {
            id: grid
            width:parent.width
            rows: 4; columns: 2; spacing: 10

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "languageLabel"
                    text: "Language: "
                    font.pointSize: 30; font.bold: true
                }
            }

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                ComboBox {
                    currentIndex: 0
                    model: ListModel {
                        id: cbItems
                        ListElement { text: "English" }
                        ListElement { text: "French" }
                        ListElement { text: "Chinese" }
                    }
                    onCurrentIndexChanged: console.debug(cbItems.get(currentIndex).text + ", " + cbItems.get(currentIndex).color)
                }
            }
            
            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "timeLabel"
                    text: "Time: "
                    font.pointSize: 30; font.bold: true
                }
            }

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                TextField {
                    placeholderText: qsTr("Hour: Minute")
                }
            }

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "dateLabel"
                    text: "Date: "
                    font.pointSize: 30; font.bold: true
                }
            }

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                TextField {
                    placeholderText: qsTr("mm/dd/yyyy")
                }
            }

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "wifiLabel"
                    text: "Wifi: "
                    font.pointSize: 30; font.bold: true
                }
            }
        }
    }
}