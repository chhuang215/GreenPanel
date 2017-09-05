import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    property var wifilist : []
    visible: false
    onVisibleChanged:{
        if (visible) refreshWifiList()
    }

    function refreshWifiList(){}
}