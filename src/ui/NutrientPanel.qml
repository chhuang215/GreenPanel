import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelNutrient"
    signal nutrientAdded(int days)
    property int days: 0
    visible: false

    Text{
        id: "txtStatus"
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter : parent.verticalCenter
        text: days + " days until add nutrient."
        font.pointSize: 38
    }

    Button{
        id: btnResetNutrientDays
        anchors.top : txtStatus.bottom
        anchors.horizontalCenter:txtStatus.horizontalCenter
        text: "Ok, I added new nutrients"
        onClicked: nutrientAdded(15)
    }
    Button{
        id: btnMinusOne
        anchors.left : btnResetNutrientDays.right
        anchors.leftMargin: 5
        anchors.top : btnResetNutrientDays.top
        text: "-1 day"
        onClicked: nutrientAdded(days-1)
        visible: days > 0
    }
    Button{
        anchors.left : btnMinusOne.right
        anchors.leftMargin: 5
        anchors.top : btnMinusOne.top
        text: "UNDO"
        // onClicked: nutrientAdded(days-1)
        // visible: days > 0
    }
}