import QtQuick 2.3
import QtQuick.Controls 1.2

Item{
    Column{
        width: parent.width
        spacing:40
        Row{
            // anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
            anchors.bottomMargin:10
            Text{
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text:"The time and setting and stuff should be here"
                font.pointSize: 30
                
            }
        }
        Row {
            x: 119
            spacing: 60
            
            Button {
                width:226
                height:130
                text: "Light Switch"
                objectName: "swtLight"            
                checked: true
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

        }

        Row {
            x: 30
            spacing: 30
            
            Button {
                width:226
                height:130
                text: "water"
                objectName: "btnWater"            
            
            }

            Button {
                width:226
                height:130
                text: "light"
                // objectName: "swtLight"            
                
            }

            Button {
                width:226
                height:130
                text: "nutrient"
                // objectName: "swtLight"            
                
            }

        }
    }

}

