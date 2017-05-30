import QtQuick 2.3
import QtQuick.Controls 1.2


Rectangle {
    id: page
    width: 800; height: 480
    color: "lightgray"
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
            }

        }

        Row {
            x: 30
            spacing: 30
            
            Button {
                width:226
                height:130
                text: "water"
                // objectName: "swtLight"            
            
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

    
    


    Grid {
        id: grid
        x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
        rows: 1; columns: 6; spacing: 3            

        Cell { cellColor: "red"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "green"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "blue"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "yellow"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "steelblue"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "black"; onClicked: helloText.color = cellColor }
    }

    Button{
        anchors.bottom:page.bottom
        anchors.right:page.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        text:"quit"
        objectName:"btnQuit"
    }

}
