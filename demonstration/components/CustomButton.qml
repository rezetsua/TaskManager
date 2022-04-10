import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import theme 1.0

Rectangle {
    id: root

    property bool withImage: false
    property bool buttonCheckable: false
    property bool buttonChecked: false
    property bool buttonEnable: true
    property bool buttonTaskable: buttonChecked && buttonEnable

    property int size: 30

    property color buttonColor: TaskTheme.primary10
    property color buttonHoveredColor: TaskTheme.primary90
    property color buttonCheckedColor: TaskTheme.primary90
    property color contentColor: TaskTheme.primary40
    property color contentDownColor: TaskTheme.primary90

    property string imageSource: ""
    property string imageSourceChecked: ""
    property string contentText: ""
    property string tipText: ""

    width: size; height: size
    radius: size / 2
    enabled: buttonEnable
    opacity: buttonEnable ? TaskTheme.opacityMax : TaskTheme.opacityMin
    color: {
        if (hoverHandler.hovered) return buttonHoveredColor
        else if (buttonChecked) return buttonCheckedColor
        else return buttonColor
    }

    Image {
        id: image

        anchors.fill: parent
        anchors.margins: TaskTheme.gap + 2
        fillMode: Image.PreserveAspectFit
        source: buttonChecked ? imageSourceChecked : imageSource
        sourceSize: Qt.size(width, height)
        visible: withImage

        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: tapHandler.pressed ? contentDownColor : contentColor
        }
    }

    Text {
        anchors.centerIn: parent
        text: contentText
        font.family: "Roboto"
        font.pixelSize: TaskTheme.contentTextSize
        color: contentColor
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {
        id: tapHandler
        onTapped: if (buttonCheckable) buttonChecked = !buttonChecked
    }

    ToolTip {
        delay: 1000
        visible: hoverHandler.hovered && tipText != ""
        text: tipText
        background: Rectangle {
            color: TaskTheme.primary10
            radius: height / 2
        }
        contentItem: Text {
            text: tipText
            font.family: "Roboto"
            font.pixelSize: TaskTheme.tipTextSize
            color: contentColor
        }
    }
}
