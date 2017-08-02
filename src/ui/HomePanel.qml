import QtQuick 2.3
import QtQuick.Controls 1.2

Item{
    id:"panelHome"
    objectName:"panelHome"
    property alias changeColor:helloText.color
    
    Column{
        width: parent.width
        spacing:40
        Row{
            // anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
            anchors.bottomMargin:10
            Button{
                id:"btnSetting"
                objectName:"btnSetting"
                text:"Setting"
                anchors.verticalCenter: parent.verticalCenter
            }
            Button{
                signal ispressed()
                signal isreleased()
                id:"btnRotateLeft"
                objectName:"btnRotateLeft"
                text:"<-"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: parent.clicked()
                    onPressed: parent.ispressed()
                    onReleased: parent.isreleased()
                }
            }

            Button{
                signal ispressed()
                signal isreleased()
                id:"btnRotateRight"
                objectName:"btnRotateRight"
                text:"->"
                anchors.verticalCenter: parent.verticalCenter
                
                MouseArea{
                    anchors.fill: parent
                    onClicked: parent.clicked()
                    onPressed: parent.ispressed()
                    onReleased: parent.isreleased()
                }
            }

            Text{
                objectName:"txtClock"
                width: parent.width - btnSetting.width - btnSetting.width 
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 38
            }


        }
        Row {
            x: 119
            spacing: 60
            
             Button {
                width:226
                height:130
                text: "water"
                objectName: "btnWater"             
            }

            Button {
                width:226
                height:130
                text: "nutrient"
                // objectName: "swtLight"            
                
            }

        }

        Row {
            x: 30
            spacing: 30
            
            Button {
                id:"btnLight"
                objectName:"btnLight"
                width:226
                height:130
                text: "Set Light Timer"

            }

            Text {
                
                anchors.verticalCenter: parent.verticalCenter
                id: helloText
                objectName: "txtTemp"
                text: "-1"

                font.pointSize: 40; font.bold: true
                MouseArea { 
                    anchors.fill: parent 
                }
            }

            Button {
                width:226
                height:130
                id:"btnRobot"
                objectName:"btnRobot"
                text: "Robot Guy" 
            }

        }
    }

}

