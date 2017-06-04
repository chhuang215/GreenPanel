import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item{

    property int buttonHeight: 100
    property int buttonWidth: 100

    id:"panelLight"
    visible: false
    signal btnBackClicked()
    Column{
        width: parent.width
        spacing:40
        Row{
            // anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
            anchors.bottomMargin:10
            Button {
                text: "<-back"
                objectName: "btnBack"
                onClicked: panelLight.btnBackClicked()
            }
        }
        Row {
            x: 30
            spacing: 30
            Text {
                
                anchors.verticalCenter: parent.verticalCenter
                objectName: "txtHourLabel"
                text: "Hour:"
                font.pointSize: 40; font.bold: true

            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                objectName: "txtHour"
                text: "7"
                font.pointSize: 40; font.bold: true
            }
            Button {
                width:buttonWidth
                height:buttonHeight
                text: "+"
                objectName: "btnWater"            
            
            }
            Button {
                width:buttonWidth
                height:buttonHeight
                text: "-"
                objectName: "btnWater"            
            
            }

        }

        Row {
            x: 30
            spacing: 30
            
            Text {
                
                anchors.verticalCenter: parent.verticalCenter
                
                objectName: "txtDurationLabel"
                text: "Duration:"

                font.pointSize: 40; font.bold: true
            }

            Text {
                
                anchors.verticalCenter: parent.verticalCenter
                
                objectName: "txtDuration"
                text: "17"

                font.pointSize: 40; font.bold: true

            }

            Button {
                width:buttonWidth
                height:buttonHeight
                text: "+"
                objectName: "btnWater"            
            
            }

            Button {
                width:buttonWidth
                height:buttonHeight
                text: "-"
                // objectName: "swtLight"            
                
            }
        }
    }

}

