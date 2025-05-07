import QtQuick 2.13

QtObject {
    function parse(tag){
        if(tag.trim().startsWith("www.ladeklubben.dk/start/")){
            const words = tag.split('/');
            if(words.length === 3){
                return words.pop();
            }
        }
        else{
            console.log("Tag not recognized:", tag);
        }
        return null;
    }
}
