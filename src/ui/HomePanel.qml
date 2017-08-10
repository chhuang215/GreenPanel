import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item{
  
    id:"panelHome"
    objectName:"panelHome"
    // property alias changeColor:helloText.color

    function updateTemperature(c, f){
        txtTempC.text = c;
        txtTempF.text = f;
    }

    Column{
        width: parent.width
        
        spacing:40
        Row{
            // anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
            height: 50
            anchors.bottomMargin:10
            Button{
                id:"btnSetting"
                objectName:"btnSetting"
                text:"Setting"
                anchors.verticalCenter: parent.verticalCenter
            }
            Button{
                id:"btnRotateLeft"
                objectName:"btnRotateLeft"
                text:"<-"
                anchors.verticalCenter: parent.verticalCenter
            }

            Button{

                id:"btnRotateRight"
                objectName:"btnRotateRight"
                text:"->"
                anchors.verticalCenter: parent.verticalCenter

            }

            Text{
                objectName:"txtClock"
                width: parent.width - btnSetting.width*2 - btnRotateRight.width*4
                // anchors.fill: parent
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

            Rectangle{
                objectName: "tempDisplay"
                width: 226
                height: 130
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                // anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: "txtTempC"
                    objectName: "txtTempC"
                    text: "-1"

                    font.pointSize: 40; font.bold: true
                
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: "txtTempF"
                    objectName: "txtTempF"
                    text: "100"

                    font.pointSize: 40; font.bold: true
                    visible: false
                }
                
                MouseArea { 
                    anchors.fill: parent 
                    onClicked: {
                        txtTempC.visible = !txtTempC.visible
                        txtTempF.visible = !txtTempF.visible
                    }
                }
            }

            Button {
                width:226
                height:130
                id:"btnRobot"
                objectName:"btnRobot"
                text: qsTr("Robot Guy")    
            }

        }
    }

}

