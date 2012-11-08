// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "UI"

Rectangle { id: frame
    width: 500
    height: 550

    property string curContext: "targeting"


    Rectangle { id:toolBar
        x: 0
        y: 0
        width: parent.width
        height: 50
        color: "#333333"

        Row {
            x: 5
            y: 5
            width: parent.width - 10
            height: parent.height - 10


            Button {
                width: 50
                text: "Block"
                function onClicked(mouse) {
                    frame.curContext = "block";
                }
            }

            Button {
                width: 50
                text: "River"
                function onClicked(mouse) {
                    frame.curContext = "river";
                }
            }

            Button {
                width: 50
                text: "Go"
                function onClicked(mouse) {
                    frame.curContext = "targeting";
                }
            }

        }
    }

    Rectangle {  id:gameView
        x: 0
        y: 50
        width: 500
        height: 500

        property variant selected : pawn

        Rectangle { id: pawn
            x: 0
            y: 0

            property int targetX: 0
            property int targetY: 0

            property variant path

            //Behavior on x { SmoothedAnimation { velocity: 200 ; easing.type: Easing.Linear} }
            //Behavior on y { SmoothedAnimation { velocity: 200 ; easing.type: Easing.Linear} }
            Behavior on x {
                NumberAnimation {
                    id: bx
                    duration: 10

                    onRunningChanged: {
                        if(running == false)
                            pawn.completed();
                    }
                }
            }
            Behavior on y {
                NumberAnimation {
                    id: by
                    duration: 10
                    onRunningChanged: {
                        if(running == false)
                            pawn.completed();
                    }
                }
            }
            /*
            onXChanged: {
                onPositionChanged();
            }

            onYChanged: {
                onPositionChanged();
            }
            */

            function completed() {
                console.log("moved 1 comma :" + x + "," + y);
                if (x == targetX && y == targetY) {
                    goToNextPos();
                }
            }
            /*
            function onPositionChanged() {
                console.log("xy:" + x + "," + y);
                if (x == targetX && y == targetY) {
                    goToNextPos();
                }
            }
            */
            function goToNextPos() {



                if(path.length > 0) {
                    var p = path[0];
                    targetX = p.x;
                    targetY = p.y;

                    x = p.x;
                    y = p.y;

                    if(p.geo == "river") {
                        bx.duration = 90;
                        by.duration = 90;
                    }else {
                        bx.duration = 30;
                        by.duration = 30;
                    }

                    var ppath = path;
                    ppath.shift();
                    path = ppath;

                    console.log('goTo ' + x + "," + y + " path.length :" + path.length);

                    return true
                } else {
                    return false
                }
            }

            function move(){

                var ppath = path;
                console.log("path size : " + ppath.length);
                var p = ppath.shift();
                path = ppath;
                console.log("path p : " + p.x + "," + p.y);
                console.log("path size : " + path.length);

                for(var i = 0; i < path.length; i++)
                    console.log("move path pos : " + path[i].x + "," + path[i].y);
                goToNextPos();
            }

            z: 10
            Item {
                x: 3
                y: 3

                Rectangle {
                    x: - width / 2
                    y: - height
                    width: 13
                    height: 20

                    radius: 5

                    color: "gray"
                    border.color: "darkgray"
                }
            }
        }

        Rectangle { id:testcells

            function paintRect(x1, y1, x2, y2, geo) {
                var bx = Math.min(x1, x2);
                var by = Math.min(y1, y2);

                var ex = Math.max(x1, x2);
                var ey = Math.max(y1, y2);

                for(var iy = by; iy < ey; iy++) {
                    for(var ix = bx; ix < ex; ix++) {
                        var idx = getIndex(ix, iy);
                        children[idx].changeGeo(geo);
                    }
                }
            }

            function getIndex(ix, iy) {
                var index = Math.floor(iy * 100 + ix);
                return index;
            }
        }


        //columns:100
        //rows:100



        MouseArea { id: contextDrawing
            visible: frame.curContext == "block" || frame.curContext == "river" ? true : false

            property string paintingGeo : frame.curContext

            anchors.fill: parent
            hoverEnabled: false

            property int startX
            property int startY

            property int curX
            property int curY

            onPressed: {
                startX = mouse.x;
                startY = mouse.y;

                curX = mouse.x;
                curY = mouse.y;
            }

            onPositionChanged: {
                curX = mouse.x;
                curY = mouse.y;
            }

            onReleased: {
                var sX = Math.floor(startX / 5);
                var sY = Math.floor(startY / 5);
                var cX = Math.floor(curX / 5);
                var cY = Math.floor(curY / 5);
                testcells.paintRect(sX, sY, cX, cY, paintingGeo);
            }

            Rectangle {
                visible: parent.pressed

                property int sSX: steped(parent.startX)
                property int sSY: steped(parent.startY)
                property int sCX: steped(parent.curX + 5)
                property int sCY: steped(parent.curY + 5)

                x: Math.min(sSX, sCX)
                y: Math.min(sSY, sCY)

                width: Math.abs(parent.curX - parent.startX)
                height: Math.abs(parent.curY - parent.startY)

                border.color: frame.curContext == "block"? "red" : "blue"
                color: frame.curContext == "block"? "red" : "blue"

                function steped(val) {
                    return Math.floor(val / 5) * 5;
                }
            }
        }

        MouseArea { id: contextTargeting
            visible: frame.curContext == "targeting" ? true : false

            anchors.fill: parent

            onClicked: {
                console.log("clicked :" + mouse.x + "," + mouse.y);

                var cx = mouse.x / 5;
                var cy = mouse.y / 5;

                if(geoMap.getGeo(cx, cy) == "block") {
                    console.log()
                }

                var rs = geoMap.findPath(pawn.x, pawn.y, mouse.x, mouse.y);



                var path = [];

                for(var i = 0; i < geoMap.getPathSize(); i++) {
                    var p = geoMap.getPathAt(i);
                    var rsGeo = geoMap.getGeo(p.x, p.y);
                    var point = {x:p.x * 5, y:p.y * 5, geo: rsGeo};
                    console.log("pathPoint:" + point.x + " " + point.y);
                    path.push(point);
                }

                pawn.path = path;

                console.log(pawn.path[0].x);

                //pawn.x = mouse.x;
                //pawn.y = mouse.y;
                pawn.move();

            }

            function steped(val) {
                return Math.floor(val / 5) * 5;
            }
        }


        Component {id: cell
            Rectangle{
                width:5
                height:5
                color: "#EEEEDD"
                border.color: "#DDDDBB"
                property string geo
                property int ix
                property int iy

                x: ix * 5
                y: iy * 5

                function changeColor(){
                    color = "#DDDDFF";
                }

                function changeGeo(g) {
                    geo = g;
                    geoMap.setGeo(ix, iy, geo)
                    if(geo == "block") {
                        color = "red";
                        border.color = "#DD0000";
                    }else if(geo == "river"){
                        color = "#3333FF";
                        border.color = "#0000DD";
                    } else {//if(geo == "ground") {
                        color = "#EEEEDD";
                        border.color = "#DDDDBB";
                    }

                }


            }
        }

        Component.onCompleted: {
            for(var iy = 0; iy < 100; iy++) {
                for(var ix = 0; ix < 100; ix++){
                    var geo = geoMap.getGeo(ix, iy);
                    cell.createObject(testcells, {"ix": ix, "iy": iy, "geo": geo});
                }
            }
        }
    }
}
