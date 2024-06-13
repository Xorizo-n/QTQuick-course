import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {
    property int selectedColorIndex: -1 // Индекс выбранного цвета, -1 если ничего не выбрано
    property int selectedSizeIndex: -1 // Индекс выбранного размера, -1 если ничего не выбрано
    property real basePrice: 5
    property int primaryColorAmt: 1
    property int secondaryColorAmt: 0
    property int orderAmt: 1000
    property real priceForOne: 0
    property real priceForAll: 0
    property real additions: 0
    function calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice) {
        priceForOne = ((primaryColorAmt + secondaryColorAmt) * (1200/orderAmt + 6) + basePrice).toFixed(2)
        priceForAll = (priceForOne * orderAmt).toFixed(2)
        additions = 0
        additions += shippingNeeded.checked === true ? 400 : 0
        additions += prototypeNeeded.checked === true ? 1000 : 0
        additions += colorProofNeeded.checked === true ? 1000 : 0
        additions += urgentOrder.checked === true ? priceForAll*0.5 : 0
    }
    title: "Калькулятор цены заказа"
    objectName: "MainWindow"
    visible: true
    width: 480
    height: { sizeSelectionPanel.height + colorSelectionPanel.height + colorAmountPanel.height +
              orderQuantitySelectionPanel.height + priceForSingleItemPanel.height + totalPricePanel.height +
              goToImgSelectorButton.height + additionsPanel.height + 4*8 + 40 }
    StackLayout {
        id: stackLayout
        anchors.fill: parent
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
                                            calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
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
                                            duration: 170
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
                                    color: modelData
                                    border.color: index === selectedColorIndex ? "lightblue" : "darkgray"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Set color:", modelData)
                                            colorSelectClickAnimation.start()
                                            selectedColorIndex = index
                                            calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
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
                                            duration: 170
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
                                        if (primaryColorAmt > 1) {
                                            primaryColorAmt--
                                            console.log("-1 primary color amt, currently is " + primaryColorAmt)
                                        } else primaryShakeAnimation.start()
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
                                onTextChanged: calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
                                SequentialAnimation {
                                    id: primaryShakeAnimation
                                    running: false
                                    loops: 1
                                    PropertyAnimation {
                                        target: primary_color_amt
                                        property: "x"
                                        from: primary_color_amt.x
                                        to: primary_color_amt.x + 5
                                        duration: 50
                                        easing.type: Easing.InOutQuad
                                    }
                                    PropertyAnimation {
                                        target: primary_color_amt
                                        property: "x"
                                        from: primary_color_amt.x + 5
                                        to: primary_color_amt.x - 5
                                        duration: 50
                                        easing.type: Easing.InOutQuad
                                        loops: 2
                                    }
                                    PropertyAnimation {
                                        target: primary_color_amt
                                        property: "x"
                                        from: primary_color_amt.x - 5
                                        to: primary_color_amt.x
                                        duration: 50
                                        easing.type: Easing.InOutQuad
                                    }
                                }
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
                                        if(primaryColorAmt<5) {
                                            primaryColorAmt++
                                            console.log("+1 primary color amt, currently is " + primaryColorAmt)
                                        }
                                        else primaryShakeAnimation.start()
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
                                        if(secondaryColorAmt>0) {
                                            secondaryColorAmt--
                                            console.log("-1 secondary color amt, currently is " + secondaryColorAmt)
                                        }
                                        else secondaryShakeAnimation.start()
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
                                onTextChanged: calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
                                SequentialAnimation {
                                    id: secondaryShakeAnimation
                                    running: false
                                    loops: 1
                                    PropertyAnimation {
                                        target: secondary_color_amt
                                        property: "x"
                                        from: secondary_color_amt.x
                                        to: secondary_color_amt.x + 5
                                        duration: 50
                                        easing.type: Easing.InOutQuad
                                    }
                                    PropertyAnimation {
                                        target: secondary_color_amt
                                        property: "x"
                                        from: secondary_color_amt.x + 5
                                        to: secondary_color_amt.x - 5
                                        duration: 50
                                        easing.type: Easing.InOutQuad
                                        loops: 2
                                    }
                                    PropertyAnimation {
                                        target: secondary_color_amt
                                        property: "x"
                                        from: secondary_color_amt.x - 5
                                        to: secondary_color_amt.x
                                        duration: 50
                                        easing.type: Easing.InOutQuad
                                    }
                                }
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
                                        if(secondaryColorAmt<5) {
                                            secondaryColorAmt++
                                            console.log("+1 secondary color amt, currently is " + secondaryColorAmt)
                                        }
                                        else secondaryShakeAnimation.start()
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
                                        if(orderAmt>0) orderAmt -= 50
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
                            TextInput {
                                id: order_quantity
                                x: parent.width/2 - contentWidth/2
                                y: parent.height/2 - contentHeight/2 - 1
                                text: orderAmt
                                font.pointSize: 20
                                onTextChanged:
                                {
                                    if (order_quantity.acceptableInput) {
                                        order_quantity.color = "black"
                                        orderAmt = order_quantity.text
                                        calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
                                    }
                                    else order_quantity.color = "red"
                                }
                                validator: IntValidator{bottom: 1000; top: 10000;}
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
                                        orderAmt += 50
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
                            onTextChanged: console.log("Calculated price for single item is " + priceForOne)
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
                        Text {
                            id: totalPrice
                            x: parent.width/2 - contentWidth/2 - 20
                            y: parent.height/2 - contentHeight/2
                            color: "red"
                            text: priceForAll+additions
                            font.pointSize: 30
                            font.bold: true
                            Text {
                                anchors.left: parent.right
                                anchors.leftMargin: 7
                                y: parent.height/2 - contentHeight/2 + 4
                                text: "руб."
                                font.pointSize: 15
                            }
                            Text {
                                anchors.right: parent.left
                                anchors.leftMargin: 7
                                y: parent.height/2 - contentHeight/2 + 4
                                text: "Итого: "
                                font.bold: true
                                font.pointSize: 15
                            }
                            onTextChanged: console.log("Total = " + priceForAll + " + Additions = " + additions + " = " + text)
                        }
                    }
                    //---------------------------------------------------------------// Additions panel
                    Rectangle {
                        id: additionsPanel
                        color: "lightgray"
                        width: 460
                        height: 135
                        radius: 3
                        Text {
                            text: "Дополнительные услуги"
                            anchors.top: parent.top
                            x: parent.width/2 - width/2
                            color: "black"
                            font.pointSize: 10
                            font.letterSpacing: 1
                        }
                        Column {
                            id: additionsLayout
                            x: parent.width/2 - width/2
                            anchors.top: parent.top
                            anchors.topMargin: 20
                            anchors.fill: parent
                            Switch {
                                id: shippingNeeded
                                anchors.left: parent.left
                                onCheckedChanged: {
                                    calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
                                }
                                Text {
                                    anchors.left: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Доставка по Екатеринбургу (400р.)"
                                    font.pointSize: 11
                                }
                            }
                            Switch {
                                id: prototypeNeeded
                                anchors.left: parent.left
                                onCheckedChanged: {
                                    calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
                                }
                                Text {
                                    anchors.left: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Требуется изготовление макета (1000р.)"
                                    font.pointSize: 11
                                }
                            }
                            Switch {
                                id: colorProofNeeded
                                anchors.left: parent.left
                                onCheckedChanged: {
                                    calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
                                }

                                Text {
                                    anchors.left: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Требуется цветопроба (1000р.)"
                                    font.pointSize: 11
                                }
                            }
                            Switch {
                                id: urgentOrder
                                anchors.left: parent.left
                                onCheckedChanged: {
                                    calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice)
                                }
                                Text {
                                    anchors.left: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Изготовление в течении 48 часов (+50% к стоимости)"
                                    font.pointSize: 11
                                }
                            }
                        }
                    }
                    //---------------------------------------------------------------// Image selector button
                    Rectangle {
                        id: goToImgSelectorButton
                        width: parent.width
                        height: 35
                        radius: 4
                        color: "lightgray"
                        border.color: "darkgray"
                        border.width: 2
                        Text {
                            text: "Загрузить дизайн"
                            font.pointSize: 11
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                stackLayout.currentIndex = 1
                                parent.border.color = "darkgray"
                            }
                            onPressed: parent.border.color = "lightblue"
                        }
                    }
                }
            }
        }
        //---------------------------------------------------------------// Image selector
        Rectangle {
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
                    id: title2
                    text: "Выбор дизайна"
                    anchors.top: parent.top
                    x: parent.width/2 - width/2
                    color: "black"
                    font.pointSize: 15
                    font.bold: true
                    font.letterSpacing: 2
                }
                Column {
                    x: parent.width/2 - width/2
                    anchors.top: title2.bottom
                    anchors.topMargin: 5
                    spacing: 4
                    Rectangle {
                        width: parent.width
                        height: 35
                        radius: 4
                        color: "lightgray"
                        border.color: "darkgray"
                        border.width: 2
                        Text {
                            text: "Загрузить изображение"
                            font.pointSize: 11
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                fileDialog.open()
                                parent.border.color = "darkgray"
                            }
                            onPressed: parent.border.color = "lightblue"
                        }
                    }
                    Image {
                        id: imgDisp
                        source: "https://icons.veryicon.com/png/o/education-technology/alibaba-cloud-iot-business-department/image-load-failed.png"
                        width: 400
                        height: 400
                        fillMode: Image.PreserveAspectFit
                    }
                    Rectangle {
                        width: parent.width
                        height: 35
                        radius: 4
                        color: "lightgray"
                        border.color: "darkgray"
                        border.width: 2
                        Text {
                            text: "Вернуться назад"
                            font.pointSize: 11
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                stackLayout.currentIndex = 0
                                parent.border.color = "darkgray"
                            }
                            onPressed: parent.border.color = "lightblue"
                        }
                    }
                }
                FileDialog {
                    id: fileDialog
                    title: "Выберите изображение"
                    nameFilters: ["Изображения (*.png *.jpg *.jpeg)"]
                    onAccepted: {
                        imgDisp.source = selectedFile
                        console.log("Загружено изображение: " + selectedFile)
                    }
                }
            }
        }
    }
}

