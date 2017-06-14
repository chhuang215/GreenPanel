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
            rows: 4; columns: 0; spacing: 3 

            Row {
                x: 30
                spacing: 30
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "languageLabel"
                    text: "Language: "
                    font.pointSize: 40; font.bold: true
                }
            }

            Row {
                x: 30
                spacing: 30
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "timeLabel"
                    text: "Time: "
                    font.pointSize: 40; font.bold: true
                }
            }

            Row {
                x: 30
                spacing: 30
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "dateLabel"
                    text: "Date: "
                    font.pointSize: 40; font.bold: true
                }
            }

            Row {
                x: 30
                spacing: 30
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "wifiLabel"
                    text: "Wifi: "
                    font.pointSize: 40; font.bold: true
                }
            }

        }
    }
}