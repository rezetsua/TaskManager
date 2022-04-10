import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.13
import theme 1.0
import components 1.0

Window {
    id: root

    Connections {
        target: task_manager_
        function onTaskProgressChanged(index, progress) {
            listView.itemAtIndex(index).children[1].progress = progress
        }
        function onTaskFinish(index) {
            updateInfo()
        }
    }

    width: 520
    height: 480
    visible: true
    title: "Task Manager"

    // Фон
    Rectangle {
        anchors.fill: parent
        color: TaskTheme.primary10

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: TaskTheme.bigGap
            spacing: TaskTheme.bigGap

            // Панель управления
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: TaskTheme.elementHeight
                Layout.leftMargin: TaskTheme.bigGap
                Layout.rightMargin: TaskTheme.bigGap

                color: TaskTheme.primary40
                radius: TaskTheme.bigRadius

                CustomButton {
                    anchors.left: parent.left
                    anchors.leftMargin: TaskTheme.bigGap
                    anchors.verticalCenter: parent.verticalCenter

                    withImage: true
                    buttonCheckable: true
                    imageSource: "qrc:icon/check.svg"
                    imageSourceChecked: "qrc:icon/cancel.svg"
                    tipText: buttonChecked ? "Снять выделение" : "Выбрать все"

                    onButtonCheckedChanged: setAllTask(buttonChecked)
                }

                Text {
                    id: taskInfo
                    anchors.centerIn: parent
                    text: "Завершены 0 из 10 задач"
                    font.family: "Roboto"
                    font.pixelSize: TaskTheme.contentTextSize
                    color: TaskTheme.primary90
                }

                CustomButton {
                    anchors.right: parent.right
                    anchors.rightMargin: TaskTheme.bigGap
                    anchors.verticalCenter: parent.verticalCenter

                    withImage: true
                    imageSource: "qrc:icon/play.png"
                    tipText: "Запустить выбранное"

                    TapHandler {
                        id: tapHandler
                        onTapped: runTask()
                    }
                }
            }

            // Список
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: TaskTheme.primary40
                radius: TaskTheme.bigRadius

                // Контейнер для закругленной обрезки списка
                Rectangle {
                    id: clipContainer
                    anchors.fill: parent
                    anchors.margins: TaskTheme.bigGap
                    color: TaskTheme.primary40
                    radius: TaskTheme.bigRadius

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: clipContainer.width
                            height: clipContainer.height
                            radius: TaskTheme.bigRadius
                        }
                    }

                    ListView {
                        id: listView
                        anchors.fill: parent
                        spacing: TaskTheme.gap
                        cacheBuffer: TaskTheme.elementHeight * model

                        model: 10
                        delegate: Rectangle {
                            width: parent.width
                            height: TaskTheme.elementHeight
                            color: TaskTheme.primary10
                            radius: TaskTheme.bigRadius

                            CustomButton {
                                id: taskIndexButton
                                anchors.left: parent.left
                                anchors.leftMargin: TaskTheme.bigGap
                                anchors.verticalCenter: parent.verticalCenter

                                buttonEnable: taskProgressBar.progress == 0 || taskProgressBar.progress == 100
                                buttonCheckable: true
                                contentText: index + 1
                            }

                            CustomProgressBar {
                                id: taskProgressBar
                                anchors.left: taskIndexButton.right
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: TaskTheme.bigGap
                                anchors.rightMargin: TaskTheme.bigGap
                                height: TaskTheme.elementHeight / 12
                            }
                        }
                    }
                }
            }
        }
    }

    function setAllTask(state) {
        for (var i = 0; i < listView.count; i++)
            listView.itemAtIndex(i).children[0].buttonChecked = state
    }

    function runTask() {
        for (var i = 0; i < listView.count; i++)
            if (listView.itemAtIndex(i).children[0].buttonTaskable) {
                console.log(i)
                task_manager_.startTaskByIndex(i)
            }
    }

    function updateInfo() {
        var completeTask = 0
        for (var i = 0; i < listView.count; i++)
            if (listView.itemAtIndex(i).children[1].progress === 100)
                completeTask++
        taskInfo.text = "Завершены " + completeTask + " из " + listView.count + " задач"
    }
}
