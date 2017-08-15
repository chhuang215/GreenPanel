import QtQuick 2.7
import QtQuick.Controls 2.0

Item{

    property var slots : {"A": [-1, -1, -1], "B": [-1, -1],
                        "C": [-1, -1, -1], "D": [-1, -1],
                        "E": [-1, -1, -1], "F": [-1, -1],
                        "G": [-1, -1, -1], "H": [-1, -1],
                        }

    property var currLeft : 'A'
    property var currRight : 'B'

    id: "panelRobot"
    objectName: "panelRobot"
    visible: false
    // Column{
    //     Button {
    //         text: "<-Back"
    //         objectName: "btnBack"
    //     }
    // }

    Button {
        x: 700
        y: 100
        text: "Add Plant"
        objectName: "btnAddPlant"
    }

    Button {
        x: 700
        y: 150
        text: "Remove Plant"
        objectName: "btnRemovePlant"
    }

    Button {
        x: 400
        y: 25
        text: ">"
        objectName: "btnForward"
        onClicked : {
            currLeft = String.fromCharCode(((currLeft.charCodeAt(0) - 65 + 2) % 8 ) + 65)
            labelA.text = currLeft
            currRight = String.fromCharCode(((currRight.charCodeAt(0) - 65 + 2) % 8 ) + 65)
            labelB.text = currRight
        }
    }

    Button {
        x: 300
        y: 25
        text: "<"
        objectName: "btnBackward"
        onClicked : {
            currLeft = String.fromCharCode(((currLeft.charCodeAt(0) - 65 - 2) % 8 ) + 65)
            labelA.text = currLeft
            currRight = String.fromCharCode(((currRight.charCodeAt(0) - 65 - 2) % 8 ) + 65)
            labelB.text = currRight
        }
    }

    Text {
        id: labelA
        x: 300
        y: 80
        text: "A"
        font.family: "Ariel"
        font.bold: true
        font.pointSize: 36
    }

    Canvas {
        id: panelA
        x: 245
        y: 100
        // canvas size
        width: 200; height: 400
        // handler to override for drawing
        onPaint: {
            // get context to draw with
            var ctx = getContext("2d")
            // setup the stroke
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            // setup the fill
            ctx.fillStyle = "limegreen"
            // begin a new path to draw
            ctx.beginPath()
            // top-left start point
            ctx.moveTo(0,50)
            // upper line
            ctx.lineTo(150,50)
            // right line
            ctx.lineTo(150,300)
            // bottom line
            ctx.lineTo(50,300)
            // left line through path closing
            ctx.closePath()
            // fill using fill style
            ctx.fill()
            // stroke using line width and stroke style
            ctx.stroke()
        }
    }

    Text {
        id: labelB
        x: 440
        y: 80
        text: "B"
        font.family: "Ariel"
        font.bold: true
        font.pointSize: 36
    }

    Canvas {
        id: panelB
        x: 390
        y: 100
        width: 200; height: 400
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            ctx.fillStyle = "limegreen"
            ctx.beginPath()
            ctx.moveTo(3,50)
            ctx.lineTo(153,50)
            ctx.lineTo(103,300)
            ctx.lineTo(3,300)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }
    }

    Popup {
        id: popup1
        x: 80
        y: 60
        width: 640
        height: 360
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        Rectangle {
            x: 20
            y: 10
            height: 20
            Text {
                id: plantNameTxt1
                anchors.verticalCenter: parent.verticalCenter
                text: "Plant A1"
                font.pointSize: 18; font.bold: true
            }
        }

        Image{
            x: 20
            y: 50
            width: 100
            height: 100
            source: "images/placeholder.png"
        }

        Grid {
            id: grid1
            x: 250
            y: 10
            width: 300
            height: 180
            rows: 3; columns: 2; spacing: 10

            Rectangle {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Date Planted: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Rectangle {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "dd/mm/yy"
                    font.pointSize: 12; font.bold: false
                }
            }

            Rectangle {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Planted Duration: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Rectangle {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "00Days"
                    font.pointSize: 12; font.bold: false
                }
            }

            Rectangle {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Ready Date: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Rectangle {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "dd/mm/yy"
                    font.pointSize: 12; font.bold: false
                }
            }
        }

        Rectangle{
            x: 20
            y: 180
            width: 100
            height: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Plant Description: "
                font.pointSize: 16; font.bold: true
            }
        }

        Rectangle{
            x: 20
            y: 210
            width: 600
            height: 130
            Text {
                text: "Empty Text"
                font.pointSize: 10; font.bold: false
            }
        }

    }

    Popup {
        id: popup2
        x: 80
        y: 60
        width: 640
        height: 360
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        Rectangle {
            x: 20
            y: 10
            height: 20
            Text {
                id: plantNameTxt2
                anchors.verticalCenter: parent.verticalCenter
                text: "Plant A2"
                font.pointSize: 18; font.bold: true
            }
        }

        Image{
            x: 20
            y: 50
            width: 100
            height: 100
            source: "images/placeholder.png"
        }

        Grid {
            id: grid2
            x: 250
            y: 10
            width: 300
            height: 180
            rows: 3; columns: 2; spacing: 10

            Rectangle {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Date Planted: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Rectangle {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "dd/mm/yy"
                    font.pointSize: 12; font.bold: false
                }
            }

            Rectangle {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Planted Duration: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Rectangle {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "00Days"
                    font.pointSize: 12; font.bold: false
                }
            }

            Rectangle {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Ready Date: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Rectangle {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "dd/mm/yy"
                    font.pointSize: 12; font.bold: false
                }
            }
        }

        Rectangle{
            x: 20
            y: 180
            width: 100
            height: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Plant Description: "
                font.pointSize: 16; font.bold: true
            }
        }

        Rectangle{
            x: 20
            y: 210
            width: 600
            height: 130
            Text {
                text: "Empty Text"
                font.pointSize: 10; font.bold: false
            }
        }

    }

    RoundMouseArea1 {
        id: roundMouseArea1
        x: 305
        y: 180
        width: 50
        height: 50

        onClicked: popup1.open()

        Rectangle {
            color: "white"
            border.color: "black"
            border.width: 1
            radius: width / 2
            anchors.fill: parent
            Text {
                anchors.centerIn: parent
                text: "1"
                font.pointSize: 12
            }
        }
    }

    RoundMouseArea2 {
        id: roundMouseArea2
        x: 305
        y: 250
        width: 50
        height: 50

        onClicked: popup2.open()

        Rectangle {
            color: "white"
            border.color: "black"
            border.width: 1
            radius: width / 2
            anchors.fill: parent
            Text {
                anchors.centerIn: parent
                text: "2"
                font.pointSize: 12
            }
        }
    }

    /*Rectangle {
        x: 280
        y: 160
        width: 50
        height: 50
        color: "white"
        border.color: "black"
        border.width: 1
        radius: width*0.5
        Text {
            x: 500
            y: 500
            text: "1"
        }
    }*/

}