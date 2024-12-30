import QtQuick
import QtQuick.Shapes 1.4
import QtQuick3D
import QtQuick.Controls
import QtQuick.Layouts
import Example


Window {
    width: 1920
    height: 1280
    visible: true
    title: qsTr("Hello World")
    property var vecs:[Qt.vector3d(-75,-50,0),Qt.vector3d(-15,75,0),Qt.vector3d(15,75,0),
                             Qt.vector3d(75,-50,0),Qt.vector3d(50,-50,0),Qt.vector3d(25,0,0),Qt.vector3d(-25,0,0),
                                Qt.vector3d(-50,-50,0),Qt.vector3d(-75,-50,0),Qt.vector3d(18.5,7.5,0),Qt.vector3d(0,50,0),Qt.vector3d(-18.5,7.5,0),Qt.vector3d(18.5,7.5,0)]

    property var test:[Qt.vector3d(-100,-100,-100),Qt.vector3d(100,100,100)]
    function round(value, precision)
    {
        var multiplier = Math.pow(10, precision || 0);
        return Math.round(value * multiplier) / multiplier;
    }


    function recalc(){
        var mat = dummy.sceneTransform;
        var scale = dummy.sceneScale
        var vecs1copy = [];
        var vecs2copy = [];
        for(var i = 0; i < vecs.length;i++)
        {

            var vec = Qt.vector4d(vecs[i].x,vecs[i].y,vecs[i].z,1);
            vec = mat.times(vec);
            vecs1copy.push(vec.toVector3d());
            vecs2copy.push(vecs[i].times(scale))

        }
        vecs2 = vecs2copy;
        vecs3= vecs1copy
        var text = ""+round(mat.m11,2) + " " + round(mat.m12,2)+ " " + round(mat.m13,2)+ " " + round(mat.m14,2)+
                "\n" + round(mat.m21,2) + " " + round(mat.m22,2)+ " " + round(mat.m23,2)+ " " + round(mat.m24,2)+
                "\n" + round(mat.m31,2) + " " + round(mat.m32,2)+ " " + round(mat.m33,2)+ " " + round(mat.m34,2)+
                "\n" + round(mat.m41,2) + " " + round(mat.m42,2)+ " " + round(mat.m43,2)+ " " + round(mat.m44,2);

        return text;
    }

    View3D {
        id: view
        anchors.fill: parent

        importScene: mainScene
        camera: mainCamera

    }


    Node{
            id:mainScene

            DirectionalLight {
                eulerRotation.x: -30
                eulerRotation.y: -70
            }

            Model{
                id:xy
                position:Qt.vector3d(-1000,0,1000)
                eulerRotation: Qt.vector3d(90,0,0)
                Rectangle{
                    width:2000
                    height:2000
                    color:"transparent"
                    Canvas {
                           id: root1
                           anchors.fill : parent
                           property int wgrid: 50
                           onPaint: {
                               var ctx = getContext("2d")
                               ctx.lineWidth = 1
                               ctx.strokeStyle = "#e0e0e0"
                               ctx.fillStyle = "transparent"
                               ctx.beginPath()
                               var nrows = height/wgrid;
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                                   ctx.moveTo(0, wgrid*i);
                                   ctx.lineTo(width, wgrid*i);
                               }

                               var ncols = width/wgrid
                               for(var j=0; j < ncols+1; j++){
                                   ctx.moveTo(wgrid*j, 0);
                                   ctx.lineTo(wgrid*j, height);
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.strokeStyle = "black"
                               ctx.beginPath()
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                                   ctx.text(i-nrows/2,wgrid*i,height/(2.01),)
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.lineWidth = 5
                               ctx.strokeStyle = "red"
                               ctx.beginPath()
                               ctx.moveTo(0, width/2);
                               ctx.lineTo(width, width/2)
                               ctx.stroke()
                               ctx.strokeStyle = "green"
                               ctx.beginPath()
                               ctx.moveTo(width/2,0);
                               ctx.lineTo(width/2, height);
                               ctx.closePath()
                               ctx.stroke()
                           }
                       }
                }
    }
            Model{
                id:xz
                position:Qt.vector3d(-1000,1000,0)
                Rectangle{
                    width:2000
                    height:2000
                    color:"transparent"
                    Canvas {
                           id: root2
                           anchors.fill : parent
                           property int wgrid: 50
                           onPaint: {
                               var ctx = getContext("2d")
                               ctx.lineWidth = 1
                               ctx.strokeStyle = "#e0e0e0"
                               ctx.fillStyle = "transparent"
                               ctx.beginPath()
                               var nrows = height/wgrid;
                               for(var i=0; i < nrows+1; i++){
                                   ctx.moveTo(0, wgrid*i);
                                   ctx.lineTo(width, wgrid*i);
                               }

                               var ncols = width/wgrid
                               for(var j=0; j < ncols+1; j++){
                                   ctx.moveTo(wgrid*j, 0);
                                   ctx.lineTo(wgrid*j, height);
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.strokeStyle = "black"
                               ctx.beginPath()
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.lineWidth = 5
                               ctx.strokeStyle = "purple"
                               ctx.beginPath()
                               ctx.moveTo(width/2,0);
                               ctx.lineTo(width/2, height);
                               ctx.closePath()
                               ctx.stroke()
                           }
                       }
                }
    }

            Model{
                id:dummy
                position:Qt.vector3d(sliderPosition1.sliderValue,sliderPosition2.sliderValue,sliderPosition3.sliderValue)
                eulerRotation:Qt.vector3d(sliderRotation1.sliderValue,sliderRotation2.sliderValue,sliderRotation3.sliderValue)
                scale:Qt.vector3d(sliderScale1.sliderValue,sliderScale2.sliderValue,sliderScale3.sliderValue)
            }


            Model {
                geometry: ExampleTriangleGeometry {
                    verts:vecs3
                }
                materials: [
                    DefaultMaterial {
                        lighting: DefaultMaterial.NoLighting
                        cullMode: DefaultMaterial.NoCulling
                        diffuseColor: "black"
                    }
                ]
            }
                    PerspectiveCamera {
                        id:mainCamera
                        position: Qt.vector3d(sliderCamPosition1.sliderValue, sliderCamPosition2.sliderValue, sliderCamPosition3.sliderValue)
                        eulerRotation:Qt.vector3d(sliderCamRotation1.sliderValue,sliderCamRotation2.sliderValue,sliderCamRotation3.sliderValue)
                    }

}
    Frame {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 10
        background: Rectangle {
            color: "#e0e0e0"
            border.color: "#000000"
            border.width: 1
            opacity: 0.8
        }
        Column {
            id: settingsArea
            Label{
                text:"Position"
            }
            CustomSlider {
                id: sliderPosition1
                text:"x"
                sliderValue: 0
                fromValue: -500
                toValue: 500
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderPosition2
                text:"z"
                sliderValue: 0
                fromValue: -500
                toValue: 500
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderPosition3
                text:"y"
                sliderValue: 0
                fromValue: -500
                toValue: 500
                onMove: {
                    recalc();
                }
            }
            Item { width: 1; height: 20 }
            Label{
                text:"Rotation"
            }
            CustomSlider {
                id: sliderRotation1
                text:"x"
                sliderValue: 0
                fromValue: -180
                toValue: 180
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderRotation2
                text:"z"
                sliderValue: 0
                fromValue: -180
                toValue: 180
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderRotation3
                text:"y"
                sliderValue: 0
                fromValue: -180
                toValue: 180
                onMove: {
                    recalc();
                }
            }
            Item { width: 1; height: 20 }
            Label{
                text:"Scale"
            }
            CustomSlider {
                id: sliderScale1
                text:"x"
                sliderValue: 1
                fromValue: 0
                toValue: 10
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderScale2
                text:"z"
                sliderValue: 1
                fromValue: 0
                toValue: 10
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderScale3
                text:"y"
                sliderValue: 1
                fromValue: 0
                toValue: 10
                onMove: {
                    recalc();
                }
            }
            Label{
                text:"Camera Position"
            }
            CustomSlider {
                id: sliderCamPosition1
                text:"x"
                sliderValue: -200
                fromValue: -500
                toValue: 500
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderCamPosition2
                text:"z"
                sliderValue: 200
                fromValue: -500
                toValue: 500
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderCamPosition3
                text:"y"
                sliderValue: 300
                fromValue: -500
                toValue: 500
                onMove: {
                    recalc();
                }
            }
            Label{
                text:"Camera Rotation"
            }
            CustomSlider {
                id: sliderCamRotation1
                text:"x"
                sliderValue: -30
                fromValue: -180
                toValue: 180
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderCamRotation2
                text:"z"
                sliderValue: -30
                fromValue: -180
                toValue: 180
                onMove: {
                    recalc();
                }
            }
            CustomSlider {
                id: sliderCamRotation3
                text:"y"
                sliderValue: 0
                fromValue: -180
                toValue: 180
                onMove: {
                    recalc();
                }
            }
        }
    }

    Frame {

        id:mat

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 10
        width:150
        height:75
        background: Rectangle {
            color: "#e0e0e0"
            border.color: "#000000"
            border.width: 1
            opacity: 0.8
        }
        Text {
            text: recalc()
            font.family: "Helvetica"
            font.pointSize: 10
        }
    }

    property var vecs2:[Qt.vector3d(-75,-50,0),Qt.vector3d(-15,75,0),Qt.vector3d(15,75,0),
        Qt.vector3d(75,-50,0),Qt.vector3d(50,-50,0),Qt.vector3d(25,0,0),Qt.vector3d(-25,0,0),
           Qt.vector3d(-50,-50,0),Qt.vector3d(-75,-50,0),Qt.vector3d(18.5,7.5,0),Qt.vector3d(0,50,0),Qt.vector3d(-18.5,7.5,0)]

    property var vecs3:[Qt.vector3d(-75,-50,0),Qt.vector3d(-15,75,0),Qt.vector3d(15,75,0),
        Qt.vector3d(75,-50,0),Qt.vector3d(50,-50,0),Qt.vector3d(25,0,0),Qt.vector3d(-25,0,0),
           Qt.vector3d(-50,-50,0),Qt.vector3d(-75,-50,0),Qt.vector3d(18.5,7.5,0),Qt.vector3d(0,50,0),Qt.vector3d(-18.5,7.5,0)]

    Column{
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 10
    Rectangle{
        width: 200
        height: 150
        border.color: "black"
        View3D{
            anchors.fill: parent

            OrthographicCamera {
                id:mainCamer
                position: Qt.vector3d(0, 0, 500)
                verticalMagnification: 0.5
                horizontalMagnification: 0.5
            }
            Model{
                id:xzFront
                position:Qt.vector3d(-1000,1000,0)
                Rectangle{
                    width:2000
                    height:2000
                    color:"transparent"
                    Canvas {
                           anchors.fill : parent
                           property int wgrid: 50
                           onPaint: {
                               var ctx = getContext("2d")
                               ctx.lineWidth = 1
                               ctx.strokeStyle = "#e0e0e0"
                               ctx.fillStyle = "transparent"
                               ctx.beginPath()
                               var nrows = height/wgrid;
                               for(var i=0; i < nrows+1; i++){
                                   ctx.moveTo(0, wgrid*i);
                                   ctx.lineTo(width, wgrid*i);
                               }

                               var ncols = width/wgrid
                               for(var j=0; j < ncols+1; j++){
                                   ctx.moveTo(wgrid*j, 0);
                                   ctx.lineTo(wgrid*j, height);
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.strokeStyle = "black"
                               ctx.beginPath()
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                                   ctx.text(i-nrows/2,wgrid*i,height/(2.01))
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.lineWidth = 2
                               ctx.strokeStyle = "red"
                               ctx.beginPath()
                               ctx.moveTo(0, width/2);
                               ctx.lineTo(width, width/2)
                               ctx.stroke()
                               ctx.strokeStyle = "purple"
                               ctx.beginPath()
                               ctx.moveTo(width/2,0);
                               ctx.lineTo(width/2, height);
                               ctx.closePath()
                               ctx.stroke()
                           }
                       }
                }
            }
        Model
        {
                Shape {
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "black"
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 0

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: vecs3[0].x
                startY: -vecs3[0].y
                PathLine { x: vecs3[1].x; y: -vecs3[1].y }
                PathLine { x: vecs3[2].x; y: -vecs3[2].y }
                PathLine { x: vecs3[3].x; y: -vecs3[3].y }
                PathLine { x: vecs3[4].x; y: -vecs3[4].y }
                PathLine { x: vecs3[5].x; y: -vecs3[5].y }
                PathLine { x: vecs3[6].x; y: -vecs3[6].y }
                PathLine { x: vecs3[7].x; y: -vecs3[7].y }
                PathLine { x: vecs3[8].x; y: -vecs3[8].y }
            }
            ShapePath {
                strokeColor: "black"
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 0

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: vecs3[9].x
                startY: -vecs3[9].y
                PathLine { x: vecs3[10].x; y: -vecs3[10].y }
                PathLine { x: vecs3[11].x; y: -vecs3[11].y }
                PathLine { x: vecs3[9].x; y: -vecs3[9].y }
            }


            }
            }
        }

    }
    Rectangle{
        width: 200
        height: 150
        border.color: "black"

        View3D{
            anchors.fill: parent
            OrthographicCamera {
                id:mainCame
                position: Qt.vector3d(0, 0, 300)
                verticalMagnification: 0.5
                horizontalMagnification: 0.5
                clipNear:0
            }
            Model{
                position:Qt.vector3d(-1000,1000,0)
 //               eulerRotation: Qt.vector3d(90,0,0)
                Rectangle{
                    width:2000
                    height:2000
                    color:"transparent"
                    Canvas {
                           anchors.fill : parent
                           property int wgrid: 50
                           onPaint: {
                               var ctx = getContext("2d")
                               ctx.lineWidth = 1
                               ctx.strokeStyle = "#e0e0e0"
                               ctx.fillStyle = "transparent"
                               ctx.beginPath()
                               var nrows = height/wgrid;
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                                   ctx.moveTo(0, wgrid*i);
                                   ctx.lineTo(width, wgrid*i);
                               }

                               var ncols = width/wgrid
                               for(var j=0; j < ncols+1; j++){
                                   ctx.moveTo(wgrid*j, 0);
                                   ctx.lineTo(wgrid*j, height);
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.strokeStyle = "black"
                               ctx.beginPath()
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                                   ctx.text(i-nrows/2,wgrid*i,height/(2.01))
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.lineWidth = 2
                               ctx.strokeStyle = "green"
                               ctx.beginPath()
                               ctx.moveTo(0, width/2);
                               ctx.lineTo(width, width/2)
                               ctx.stroke()
                               ctx.strokeStyle = "purple"
                               ctx.beginPath()
                               ctx.moveTo(width/2,0);
                               ctx.lineTo(width/2, height);
                               ctx.closePath()
                               ctx.stroke()
                           }
                       }
                }
    }
        Model
        {
             Shape
             {
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "black"
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 0

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: vecs3[0].z
                startY: -vecs3[0].y
                PathLine { x: vecs3[1].z; y: -vecs3[1].y }
                PathLine { x: vecs3[2].z; y: -vecs3[2].y }
                PathLine { x: vecs3[3].z; y: -vecs3[3].y }
                PathLine { x: vecs3[4].z; y: -vecs3[4].y }
                PathLine { x: vecs3[5].z; y: -vecs3[5].y }
                PathLine { x: vecs3[6].z; y: -vecs3[6].y }
                PathLine { x: vecs3[7].z; y: -vecs3[7].y }
                PathLine { x: vecs3[8].z; y: -vecs3[8].y }
            }
            ShapePath {
                strokeColor: "black"
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 0

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: vecs3[9].z
                startY: -vecs3[9].y
                PathLine { x: vecs3[10].z; y: -vecs3[10].y }
                PathLine { x: vecs3[11].z; y: -vecs3[11].y }
                PathLine { x: vecs3[9].z; y: -vecs3[9].y }
            }


            }
            }
        }
    }
    Rectangle{
        width: 200
        height: 150
        border.color: "black"

        View3D{
            anchors.fill: parent
            OrthographicCamera {
                id:mainCam
                position: Qt.vector3d(0, 0, 300)
                verticalMagnification: 0.5
                horizontalMagnification: 0.5
                clipNear:0
            }
            Model{
                position:Qt.vector3d(-1000,1000,0)
 //               eulerRotation: Qt.vector3d(90,0,0)
                Rectangle{
                    width:2000
                    height:2000
                    color:"transparent"
                    Canvas {
                           anchors.fill : parent
                           property int wgrid: 50
                           onPaint: {
                               var ctx = getContext("2d")
                               ctx.lineWidth = 1
                               ctx.strokeStyle = "#e0e0e0"
                               ctx.fillStyle = "transparent"
                               ctx.beginPath()
                               var nrows = height/wgrid;
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                                   ctx.moveTo(0, wgrid*i);
                                   ctx.lineTo(width, wgrid*i);
                               }

                               var ncols = width/wgrid
                               for(var j=0; j < ncols+1; j++){
                                   ctx.moveTo(wgrid*j, 0);
                                   ctx.lineTo(wgrid*j, height);
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.strokeStyle = "black"
                               ctx.beginPath()
                               for(var i=0; i < nrows+1; i++){
                                   ctx.text(i-nrows/2,height/2,wgrid*i)
                                   ctx.text(i-nrows/2,wgrid*i,height/(2.01),)
                               }
                               ctx.closePath()
                               ctx.stroke()
                               ctx.lineWidth = 2
                               ctx.strokeStyle = "red"
                               ctx.beginPath()
                               ctx.moveTo(0, width/2);
                               ctx.lineTo(width, width/2)
                               ctx.stroke()
                               ctx.strokeStyle = "green"
                               ctx.beginPath()
                               ctx.moveTo(width/2,0);
                               ctx.lineTo(width/2, height);
                               ctx.closePath()
                               ctx.stroke()
                           }
                       }
                }
    }
        Model
        {
                Shape {
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "black"
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 0

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: vecs3[0].x
                startY: vecs3[0].z
                PathLine { x: vecs3[1].x; y: vecs3[1].z }
                PathLine { x: vecs3[2].x; y: vecs3[2].z }
                PathLine { x: vecs3[3].x; y: vecs3[3].z }
                PathLine { x: vecs3[4].x; y: vecs3[4].z }
                PathLine { x: vecs3[5].x; y: vecs3[5].z }
                PathLine { x: vecs3[6].x; y: vecs3[6].z }
                PathLine { x: vecs3[7].x; y: vecs3[7].z }
                PathLine { x: vecs3[8].x; y: vecs3[8].z }
            }
            ShapePath {
                strokeColor: "black"
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 0

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: vecs3[9].x
                startY: vecs3[9].z
                PathLine { x: vecs3[10].x; y: vecs3[10].z }
                PathLine { x: vecs3[11].x; y: vecs3[11].z }
                PathLine { x: vecs3[9].x; y: vecs3[9].z }
            }
            }
            }
        }
    }
}
}
