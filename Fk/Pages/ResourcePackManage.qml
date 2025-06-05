import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root


    ListModel { id: availablePackModel }
    ListModel { id: enabledPackModel }


    Component.onCompleted: {
        availablePackModel.clear();
        enabledPackModel.clear();
        let allPacks = Backend.ls(AppPath + "/resource_pak/");
        let enabled = config.enabledResourcePacks || [];
        let enabledSet = new Set(enabled.filter(p => allPacks.indexOf(p) !== -1));
        let available = allPacks.filter(p => !enabledSet.has(p));
        enabled.forEach(p => { if (allPacks.indexOf(p) !== -1) enabledPackModel.append({ name: p }); });
        available.forEach(p => availablePackModel.append({ name: p }));
    }

    ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton { text: "刷新"; onClicked: root.Component.onCompleted() }
            //Label { text: "关注猫雷谢谢喵" }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 60
        spacing: 40
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            radius: 16
            color: "#80FFFFFF"
            border.color: "#eeeeee"
            //opacity: 0.5

            border.width: 1
            Layout.fillWidth: true
            Layout.preferredWidth: 340
            height: 420
           
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 24
                Label {
                    text: "可用资源包"
                    font.bold: true
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: availablePackModel
                    delegate: ItemDelegate {
                        width: 372
                        height: 56
                        Row {
                            spacing: 16
                            Rectangle {
                                width: 50; height: 50; radius: 8
                                color: "black"
                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    source: AppPath + "/resource_pak/" + name + "/icon.png"
                                    fillMode: Image.PreserveAspectFit
                                    visible: status === Image.Ready
                                }
                            }
                            Text { text: name; font.bold: true; font.pixelSize: 16 }
                        }
                        onClicked: {
                            enabledPackModel.insert(0, { name: name });
                            availablePackModel.remove(index);
                        }

                    }
                    footer: Label {
                        text: "共 " + availablePackModel.count + " 个可用资源包"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        Rectangle {
            radius: 16
            color: "#80FFFFFF"
            border.color: "#eeeeee"
            //opacity: 0.5

            border.width: 1
            Layout.fillWidth: true
            Layout.preferredWidth: 340
            height: 420
            ColumnLayout {
                  anchors.fill: parent
                anchors.margins: 32
                spacing: 24
                Label {
                    text: "已启用资源包（优先级高在上）"
                    font.bold: true
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
                ListView {
                    id: enabledListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: enabledPackModel
                    delegate: ItemDelegate {
                        width: 372
                        height: 56
                        RowLayout {
                            width: parent.width
                            spacing: 8
                            Rectangle {
                                width: 50
                                height: 50
                                radius: 8
                                color: "black"
                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    source: AppPath + "/resource_pak/" + name + "/icon.png"
                                    fillMode: Image.PreserveAspectFit
                                    visible: status === Image.Ready
                                }
                            }
                            Text { 
                                text: name
                                font.bold: true
                                font.pixelSize: 16
                                Layout.fillWidth: true
                            }
                            
                            // 上移按钮
                            Button {
                                id: upButton
                                text: "↑"
                                enabled: index > 0
                                onClicked: {
                                    enabledPackModel.move(index, index - 1, 1);
                                }
                            }
                            
                            // 下移按钮
                            Button {
                                id: downButton
                                text: "↓"
                                enabled: index < enabledPackModel.count - 1
                                onClicked: {
                                    enabledPackModel.move(index, index + 1, 1);
                                }
                            }
                            
                            // 卸载按钮
                            Button {
                                id: unloadButton
                                text: "×"
                                onClicked: {
                                    availablePackModel.insert(0, { name: name });
                                    enabledPackModel.remove(index);
                                }
                            }
                        }
                        
                        // 点击事件区域，仅覆盖资源包图标和名称，不包括按钮
                        MouseArea {
                            onClicked: {
                                availablePackModel.insert(0, { name: name });
                                enabledPackModel.remove(index);
                            }
                        }
                    }
                    footer: Label {
                        text: "共 " + enabledPackModel.count + " 个已启用资源包"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }

    // 底部按钮
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Button {
            text: "完成"
            onClicked: {
                let enabledList = [];
                for (let i = 0; i < enabledPackModel.count; ++i) {
                    enabledList.push(enabledPackModel.get(i).name);
                }
                config.enabledResourcePacks = enabledList;
                config.saveConf();
                if (mainStack) mainStack.pop();
            }
        }
    }

} 
