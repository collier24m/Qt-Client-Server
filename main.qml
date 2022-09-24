import QtQuick 2.15
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import connectionStatusEnum 1.0
Window{
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("WiFi Setup")
    minimumHeight: 300
    minimumWidth: 300

    Rectangle{
        id: window_header
        height: parent.height * 0.15
        width: parent.width
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        color: "white"

        Text{
            id: wiFi_text
            width: parent.width * 0.50
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#63c4ec"
            minimumPixelSize: 10
            font.pixelSize: 120
            fontSizeMode: Text.Fit
            text: "WiFi Setup"


        }
        Image {
            id: wifi_image
            source: imageSource(Client.connectionStatus)
            height: parent.height * .70
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: wiFi_text.right
            anchors.leftMargin: parent.width * 0.1
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.05
            fillMode: Image.PreserveAspectFit


        }


        Rectangle{
            id: bottom_line
            width: parent.width * .90
            anchors.top: wiFi_text.bottom
            anchors.topMargin: parent.height * .20
            anchors.horizontalCenter: parent.horizontalCenter
            height: 2
            color: "black"
        }


    }

    Item {
        id: app
        anchors.top: window_header.bottom
        anchors.topMargin: window_header.height * .2
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        anchors.right: parent.right


        ComboBox{
            id: wifi_network
            width: parent.width * .6
            height: parent.height * .10
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            model: Server.wifiIDs
            background: Rectangle{
                color: "#eeeeee"
                border.color: "#63c4ec"
                border.width: 2
            }

            delegate: ItemDelegate {
                id: wifi_network_delegate
                height: wifi_network.height
                width: wifi_network.width


                contentItem: Text {
                    id: delegate_text
                    height: wifi_network.height * 2 //* 0.8
                    width: wifi_network.width
                    text: modelData
                    color: "black"
                    fontSizeMode: Text.VerticalFit
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter

                }
                highlighted: wifi_network.highlightedIndex === index
            }
            popup: Popup{
                y: wifi_network.height - 1
                width: wifi_network.width
                implicitHeight: contentItem.implicitHeight
                background: Rectangle{
                    anchors.fill: parent
                    border.color: "#63c4ec"
                    color: "white"
                    border.width: 2
                }
                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight * 1.2
                    model: wifi_network.popup.visible ? wifi_network.delegateModel : null
                    currentIndex: wifi_network.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }
            }


            Text {
                id: wifi_network_text
                height: parent.height * 0.75
                width: parent.width * .5
                text: qsTr("WiFi Network")
                minimumPixelSize: 10
                font.pixelSize: 120
                anchors.left: parent.left
                anchors.bottom: parent.top
                fontSizeMode: Text.Fit
            }

        }


        TextField{
            id: user_input
            width: parent.width * .6
            height: parent.height * .10
            anchors.top: wifi_network.bottom
            anchors.topMargin: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            placeholderText: qsTr("16 Character Minimum")
            echoMode: TextField.Password
            selectByMouse: true
            Text{
                id: password_text
                height: parent.height * 0.75
                width: parent.width * .5
                text: qsTr("Password")
                minimumPixelSize: 10
                font.pixelSize: 120
                anchors.left: parent.left
                anchors.bottom: parent.top
                fontSizeMode: Text.Fit
            }

            Image {
                id: view_password
                source: "qrc:/images/eye.png"
                height: parent.height * .9
                width: height
                anchors.right: parent.right
                anchors.rightMargin: parent.width * .01
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit


                MouseArea{
                    id: view_password_click
                    anchors.fill: parent
                    onClicked:{
                        if(user_input.echoMode == TextField.Password){
                            user_input.echoMode = TextField.Normal}
                        else{
                            user_input.echoMode = TextField.Password
                        }

                    }
                    onPressed: view_password.opacity = 0.5
                    onReleased: view_password.opacity = 1
                }
            }
            background: Rectangle{
                color: "white"
                border.color: "#63c4ec"
                border.width: 2
            }

        }

        Button{
            id: connect_button
            height: parent.height * 0.10
            width: parent.width * .25
            anchors.top: user_input.top
            anchors.topMargin: parent.height * 0.20
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Connect"

            background: Rectangle {
                opacity: enabled ? 1 : 0.3
                border.color: connect_button.down ? "#63c4ec" : "#eeeeee"
                border.width: 2
                radius: parent.height * .1
                color: "#63c4ec"
            }

            contentItem: Text {
                id: connect_button_text
                height: parent.height * .01
                width: parent.width * .02
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                minimumPixelSize: 10
                font.pixelSize: 120
                fontSizeMode: Text.Fit


            }

            onClicked: {
                Client.connectToServer(wifi_network.currentText,user_input.text);
            }

        }
    }

    Image{
        id: web_icon
        height: parent.height * 0.15
        width: height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/world-web.png"
    }

    Popup{
        id: error_popup
        height: parent.height/2
        width: parent.width/2
        parent: Overlay.overlay
        anchors.centerIn: parent

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
        }
        contentItem: Item{
            id: errorMessage
            anchors.fill: parent
            anchors.centerIn: parent

            Rectangle{
                id:popup_background
                color: "white"
                anchors.fill: parent
                border.color: "red"
                border.width: parent.height * 0.005

            }
            Text {
                id: error_text
                text: qsTr("")
                height: parent.height * 0.8
                width: parent.width * 0.8
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                minimumPixelSize: 10
                font.pixelSize: 80
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
            }

        }


    }

    Connections{
        target: Client

        function onError(msg) {
            error_text.text = msg;
            error_popup.open();
        }
        function onConnectionStatusChanged() {

            imageSource(Client.connectionStatus);
        }
    }

    function imageSource(status) {
        console.log("imageSource(status): " + status)
        switch (status) {

        case ConnectionStatus.Successful:
            return wifi_image.source = "qrc:/images/wifi-green.png"
        case ConnectionStatus.Failed:
            return wifi_image.source = "qrc:/images/wifi-red.png"
        case ConnectionStatus.Initial:
            return wifi_image.source = "qrc:/images/wifi-black.png"
        default:
            return "qrc:/images/wifi-black.png"
        }
    }

}
