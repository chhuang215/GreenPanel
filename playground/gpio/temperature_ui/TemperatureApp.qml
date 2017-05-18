import QtQuick 2.0

Rectangle {
    id: page
    width: 320; height: 480
    color: "lightgray"


    function setText(temp){
        helloText.text = temp
    }

    Text {
        id: helloText
        objectName: "txtTemp"
        text: "Temp display here"
        y: 100
        anchors.horizontalCenter: page.horizontalCenter
        font.pointSize: 24; font.bold: true
    }

    // Grid {
    //     id: colorPicker
    //     x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
    //     rows: 2; columns: 3; spacing: 3

    //     Cell { cellColor: "red"; onClicked: helloText.color = cellColor }
    //     Cell { cellColor: "green"; onClicked: helloText.color = cellColor }
    //     Cell { cellColor: "blue"; onClicked: helloText.color = cellColor }
    //     Cell { cellColor: "yellow"; onClicked: helloText.color = cellColor }
    //     Cell { cellColor: "steelblue"; onClicked: helloText.color = cellColor }
    //     Cell { cellColor: "black"; onClicked: helloText.color = cellColor }
    // }
}
