import QtQuick.Controls 2.15
import QtQuick 2.15

StackView{
    property var laststack;
    objectName: "LKStackView"

    function setHeaderText(){
        if(currentItem == null) return;
        if((currentItem).headertext !== undefined){
            header.headText = (currentItem).headertext;
        }
        if((currentItem).headersubtext !== undefined){
            header.subtext = (currentItem).headersubtext;
        }
//        if((currentItem).name !== undefined){
//            console.log("ActiveStack is", (currentItem).name);
//        }
    }

    function setLastActiveStack(){
        if(laststack !== undefined){
            activestack = laststack;
            laststack = undefined;
            activestack.pop();
        }
        else{
            activestack = rootstack;
            if(activestack.depth > 1){
                activestack.pop()
            }
        }
    }

    function goBack(){

        if((currentItem).back_btn_cancel !== undefined){
            (currentItem).back_btn_cancel();
            return false;
        }

        if(depth > 1){
            pop();
            return false;
        }
        else{
            setLastActiveStack();
        }
        return false;
    }

    onCurrentItemChanged: {
        setHeaderText();
    }

    onDepthChanged: {
        root.showMenuBar = (activestack.laststack === rootstack && rootstack.depth === 1 && activestack.depth===1);
    }

    Component.onCompleted: {
        laststack = activestack;
        activestack = this;
    }

    pushExit: Transition {
        PropertyAnimation{
            from: 1
            to: 0
            duration: 0
        }
    }
}
