import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    property int selectedColorIndex: -1 // Индекс выбранного цвета, -1 если ничего не выбрано
    property int selectedSizeIndex: -1 // Индекс выбранного размера, -1 если ничего не выбрано
    property real basePrice: 5
    property int primaryColorAmt: 1
    property int secondaryColorAmt: 0
    property int orderAmt: 1000
    property real priceForOne: 0
    title: "Module 2 Test"
    objectName: "TestWindow"
    visible: true
    width: 480
    height: { sizeSelectionPanel.height + colorSelectionPanel.height + colorAmountPanel.height +
              orderQuantitySelectionPanel.height + priceForSingleItemPanel.height + totalPricePanel.height + 65}
    Rectangle {
        id: border
        color: "steelblue"
        width: parent.width
        height: parent.height
        radius: 10
        anchors.centerIn: parent
        Rectangle {
            color: "white"
            width: parent.width - 10
            height: parent.height - 10
            radius: 5
            anchors.centerIn: parent
            Text {
                id: title
                text: "Рассчет стоимости заказа"
                anchors.top: parent.top
                x: parent.width/2 - width/2
                color: "black"
                font.pointSize: 15
                font.bold: true
                font.letterSpacing: 2
            }
            Column {
                x: parent.width/2 - width/2
                anchors.top: title.bottom
                anchors.topMargin: 5
                spacing: 4
//----------------------------------------------------------------// Size selection panel
                Rectangle {
                    id: sizeSelectionPanel
                    color: "lightgray"
                    width: 460
                    height: 80
                    radius: 3
                    Text {
                        text: "Размер и плотность пакета"
                        anchors.top: parent.top
                        x: parent.width/2 - width/2
                        color: "black"
                        font.pointSize: 10
                        font.letterSpacing: 1
                    }
                    Row {
                        x: parent.width/2 - width/2
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        spacing: 10
                        Repeater {
                            model: [
                                {text: "20x30\n80мкм", price: 5}, {text: "30x40\n70мкм", price: 8}, {text: "40x50\n70мкм", price: 11.5},
                                {text: "50x60\n70мкм", price: 18}, {text: "60x50\n70мкм", price: 18} ]
                            delegate: Rectangle {
                                width: 80
                                height: 55
                                radius: 7
                                color: "white"
                                border.color: selectedSizeIndex === index ? "lightblue" : "darkgray"
                                Text {
                                    text: modelData.text
                                    font.pointSize: 11
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("Price:", modelData.price)
                                        basePrice = modelData.price
                                        sizeSelectСlickAnimation.start()
                                        selectedSizeIndex = index
                                    }
                                }
                                SequentialAnimation on scale {
                                    id: sizeSelectСlickAnimation
                                    loops: 1
                                    running: false
                                    ScaleAnimator {
                                        from: 1
                                        to: 1.05
                                        duration: 200
                                        easing.type: Easing.OutQuad
                                        target: itemAt(index)
                                    }
                                    ScaleAnimator {
                                        to: 1
                                        duration: 150
                                        easing.type: Easing.InQuad
                                        target: itemAt(index)
                                    }
                                }
                            }
                        }
                    }
                }
//----------------------------------------------------------------// Color selection panel
                Rectangle {
                    id: colorSelectionPanel
                    color: "lightgray"
                    width: 460
                    height: 39 * (color_grid.rows + 1) - 17
                    radius: 3
                    Text {
                        text: "Цвет пакета"
                        anchors.top: parent.top
                        x: parent.width/2 - width/2
                        color: "black"
                        font.pointSize: 10
                        font.letterSpacing: 1
                    }
                    Grid {
                        id: color_grid
                        x: parent.width/2 - width/2
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        columns: 6
                        rows: Math.ceil(color_selection_loader.count/6)
                        spacing: 4
                        Repeater {
                            id: color_selection_loader
                            model: ["white", "black", "blue", "darkblue", "cyan", "hotpink",
                                "red", "orange", "lightyellow", "green", "lightgreen", "yellow"]
                            delegate: Rectangle {
                                width: 70
                                height: 35
                                radius: 5
                                border.width: 1.5
                                color: modelData // Использовать цвет из модели данных
                                border.color: index === selectedColorIndex ? "lightblue" : "darkgray"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("Set color:", modelData)
                                        colorSelectClickAnimation.start()
                                        selectedColorIndex = index
                                    }
                                }
                                SequentialAnimation on scale {
                                    id: colorSelectClickAnimation
                                    loops: 1
                                    running: false
                                    ScaleAnimator {
                                        from: 1
                                        to: 1.05
                                        duration: 200
                                        easing.type: Easing.OutQuad
                                    }
                                    ScaleAnimator {
                                        to: 1
                                        duration: 150
                                        easing.type: Easing.InQuad
                                    }
                                }
                            }
                        }
                    }
                }
//----------------------------------------------------------------// Color amount panel
                Rectangle {
                    id: colorAmountPanel
                    color: "lightgray"
                    width: 460
                    height: 85
                    radius: 3
                    Text {
                        text: "Количество цветов печати"
                        anchors.top: parent.top
                        x: parent.width/2 - width/2
                        color: "black"
                        font.pointSize: 10
                        font.letterSpacing: 1
                    }
//------------------// Primary color //------------------//
                    Rectangle {
                        x: parent.width/2 - width/2 - 70
                        anchors.top: parent.top
                        anchors.topMargin: 30
                        width: 90
                        height: 45
                        border.color: "black"
                        radius: 3
                        Rectangle {
                            x: parent.width/2 - width/2 - 25
                            y: parent.height/2 - height/2
                            width: 15
                            height: 15
                            radius: 360
                            color: "lightgray"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(primaryColorAmt>1) primaryColorAmt--
                                    console.log("-1 primary color amt, currently is " + primaryColorAmt)
                                }
                            }
                        }
                        Text {
                            x: 15.5
                            y: 5.4
                            text: "-"
                            font.pointSize: 16
                        }
                        Text {
                            id: primary_color_amt
                            x: parent.width/2 - contentWidth/2
                            y: parent.height/2 - contentHeight/2 - 1
                            text: primaryColorAmt
                            font.pointSize: 20
                        }
                        Rectangle {
                            x: parent.width/2 - width/2 + 25
                            y: parent.height/2 - height/2
                            width: 15
                            height: 15
                            radius: 360
                            color: "lightgray"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(primaryColorAmt<5) primaryColorAmt++
                                    console.log("+1 primary color amt, currently is " + primaryColorAmt)
                                }
                            }
                        }
                        Text {
                            x: 63
                            y: 6
                            text: "+"
                            font.pointSize: 15
                        }
                    }

//------------------// Separator //------------------//
                    Text {
                        x: parent.width/2 - contentWidth/2
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        text: "+"
                        font.pointSize: 30
                        font.bold: true
                    }
//------------------// Separator end //------------------//

//------------------// Secondary color //------------------//
                    Rectangle {
                        x: parent.width/2 - width/2 + 70
                        anchors.top: parent.top
                        anchors.topMargin: 30
                        width: 90
                        height: 45
                        border.color: "black"
                        radius: 3
                        Rectangle {
                            x: parent.width/2 - width/2 - 25
                            y: parent.height/2 - height/2
                            width: 15
                            height: 15
                            radius: 360
                            color: "lightgray"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(secondaryColorAmt>0) secondaryColorAmt--
                                    console.log("-1 secondary color amt, currently is " + secondaryColorAmt)
                                }
                            }
                        }
                        Text {
                            x: 15.5
                            y: 5.4
                            text: "-"
                            font.pointSize: 16
                        }
                        Text {
                            id: secondary_color_amt
                            x: parent.width/2 - contentWidth/2
                            y: parent.height/2 - contentHeight/2 - 1
                            text: secondaryColorAmt
                            font.pointSize: 20
                        }
                        Rectangle {
                            x: parent.width/2 - width/2 + 25
                            y: parent.height/2 - height/2
                            width: 15
                            height: 15
                            radius: 360
                            color: "lightgray"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(secondaryColorAmt<5) secondaryColorAmt++
                                    console.log("+1 secondary color amt, currently is " + secondaryColorAmt)
                                }
                            }
                        }
                        Text {
                            x: 63
                            y: 6
                            text: "+"
                            font.pointSize: 15
                        }
                    }
                    Text {
                        x: parent.width/2 - contentWidth/2
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        text: "+"
                        font.pointSize: 30
                        font.bold: true
                    }
                }
//----------------------------------------------------------------// Order quantity selection panel
                Rectangle {
                    id: orderQuantitySelectionPanel
                    color: "lightgray"
                    width: 460
                    height: 80
                    radius: 3
                    Text {
                        text: "Тираж"
                        anchors.top: parent.top
                        x: parent.width/2 - width/2
                        color: "black"
                        font.pointSize: 10
                        font.letterSpacing: 1
                    }
                    Rectangle {
                        x: parent.width/2 - width/2
                        anchors.top: parent.top
                        anchors.topMargin: 30
                        width: 180
                        height: 45
                        border.color: "black"
                        radius: 3
                        Rectangle {
                            x: parent.width/2 - width/2 - 70
                            y: parent.height/2 - height/2
                            width: 15
                            height: 15
                            radius: 360
                            color: "lightgray"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(orderAmt>0) orderAmt = orderAmt - 50
                                    console.log("-50 quantity, currently is " + orderAmt)
                                }
                            }
                        }
                        Text {
                            x: 15.5
                            y: 5.4
                            text: "-"
                            font.pointSize: 16
                        }
                        Text {
                            id: order_quantity
                            x: parent.width/2 - contentWidth/2
                            y: parent.height/2 - contentHeight/2 - 1
                            text: orderAmt
                            font.pointSize: 20
                        }
                        Rectangle {
                            x: parent.width/2 - width/2 + 70
                            y: parent.height/2 - height/2
                            width: 15
                            height: 15
                            radius: 360
                            color: "lightgray"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    orderAmt = orderAmt + 50
                                    console.log("+50 quantity, currently is " + orderAmt)
                                }
                            }
                        }
                        Text {
                            x: 153.4
                            y: 6
                            text: "+"
                            font.pointSize: 15
                        }
                    }
                }
//----------------------------------------------------------------// Price for single item panel
                Rectangle {
                    id: priceForSingleItemPanel
                    color: "white"
                    border.color: "black"
                    width: 460
                    height: 70
                    radius: 3
//---------------------------REMOVE LATER---------------------------//
                    Button {
                        width: 70
                        height: 70
                        anchors.right: parent.right
                        text: "Рассчитать\n(временно)"
                        y: parent.height/2 - height/2
                        onClicked: {
                            priceForOne = ((primaryColorAmt + secondaryColorAmt) * (1200/orderAmt + 6) + basePrice).toFixed(2)
                            console.log("Calculated price for single item is " + priceForOne)
                        }
                    }
//---------------------------REMOVE LATER---------------------------//
                    Text {
                        id: priceForSingleItem
                        x: parent.width/2 - contentWidth/2 - 20
                        y: parent.height/2 - contentHeight/2
                        color: "red"
                        text: priceForOne
                        font.pointSize: 30
                        font.bold: true
                        Text {
                            anchors.left: parent.right
                            anchors.leftMargin: 7
                            y: parent.height/2 - contentHeight/2 + 4
                            text: "руб. за шт."
                            font.pointSize: 15
                        }
                    }
                }
//----------------------------------------------------------------// Total price panel
                Rectangle {
                    id: totalPricePanel
                    color: "white"
                    border.color: "black"
                    width: 460
                    height: 70
                    radius: 3
//---------------------------REMOVE LATER---------------------------//
                    Button {
                        width: 70
                        height: 70
                        anchors.right: parent.right
                        text: "Рассчитать\n(временно)"
                        y: parent.height/2 - height/2
                        onClicked: {
                            totalPrice.text = priceForOne * orderAmt
                            console.log("Calculated total price is " + totalPrice.text)
                        }
                    }
//---------------------------REMOVE LATER---------------------------//
                    Text {
                        id: totalPrice
                        x: parent.width/2 - contentWidth/2 - 20
                        y: parent.height/2 - contentHeight/2
                        color: "red"
                        text: "0"
                        font.pointSize: 30
                        font.bold: true
                        Text {
                            anchors.left: parent.right
                            anchors.leftMargin: 7
                            y: parent.height/2 - contentHeight/2 + 4
                            text: "руб."
                            font.pointSize: 15
                        }
                    }
                }
            }
        }
    }
}

