import QtQuick 2.0
import QtWebView 1.15

Item {

    property string subscribe_url: "https://www.google.dk";
    property string success_url: "https://qr.ladeklubben.dk/login";

    signal done();
    signal cancel();

    function back_btn_cancel(){
        cancel();
    }

    function renewSubscriber() {
        http.request('/add_card?successurl=' + success_url, "", function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var js = JSON.parse(o.responseText);
                    subscribe_url = js.url;
                    webviewloader.sourceComponent = webview;
                }
                else if(o.status === 0) {
                    return -1;
                }
                else{
                    console.log("ERROR", o.status);
                    return -1;
                }
            }
        });
    }

    /* Poll the server untill the card revision has changed. */
    function get_card_revision() {
        http.request('/verify_card', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    //activestack.pop();
                    done();
                }
                else{
                    console.log("Wait some more");
                    polltimer.start();
                }
            }
        });
    }


    Loader{
        id: webviewloader;
        anchors.fill: parent;
    }

    Component{
        id: webview;
        WebView {
            anchors.fill: parent
            url: subscribe_url
            onUrlChanged: {
                console.log("Url changed", url);
                if(url.toString().localeCompare(success_url) == 0){
                    webviewloader.sourceComponent = cardupdate_done;
                }
            }
        }
    }

    Component{
        id: cardupdate_done
        CardUpdateFinish{

        }
    }

    Component.onCompleted: {
        renewSubscriber();


    }
}
