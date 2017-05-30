import QtQuick 2.3
import QtQuick.Controls 1.2


Rectangle {
    id: page
    width: 800; height: 480
    color: "lightgray"
    Column{
        width: parent.width
        spacing:2
        Row{
            // anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
            Text{
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text:"The time and setting and stuff should be here"
                font.pointSize: 25
                
            }
        }
        Row {
            x: 60
            spacing: 30
            
            Button {
                width:130
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
            x: 60
            spacing: 30
            
            Button {
                width:130
                height:130
                text: "btn"
                // objectName: "swtLight"            
            
            }

            Button {
                width:130
                height:130
                text: "btn"
                // objectName: "swtLight"            
                
            }

            Button {
                width:130
                height:130
                text: "btn"
                // objectName: "swtLight"            
                
            }

        }
    }

    
    


    Grid {
        id: grid
        x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
        rows: 2; columns: 3; spacing: 3            

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
