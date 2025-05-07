import QtQuick 2.0
import QtWebView 1.1

Item {

    property string subscribe_url: "";

    function createSubscriber() {
        http.request('/req_paymentnew', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var js = JSON.parse(o.responseText);
                    console.log(o.responseText);
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

//    function createSubscriber() {
//        var xhr = new XMLHttpRequest();
//        var url = "https://api.scanpay.dk/v1/new"
//        xhr.open('POST', url, true);
//        xhr.withCredentials = true;
//        xhr.setRequestHeader("Authorization", 'Basic ' + Qt.btoa("46017:Pu+cHI6RsPNexlIIRyrZ4ZiRMqFNYXP8t7KNEkpXYNMkanK4LrK0B4/nuTCyoSDf"));

//        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
//        xhr.onreadystatechange = (function(myxhr) {
//            return function() {

//                print("response:", myxhr.response);
//                print("readyState:", myxhr.readyState);

//                if(myxhr.readyState === XMLHttpRequest.DONE){

//                    if(myxhr.status === 200) {
//                        console.log("response:", myxhr.response)
//                        var js = JSON.parse(myxhr.response);
//                        subscribe_url = js.url;
//                        webviewloader.sourceComponent = webview;
//                    }
//                    else{
//                        console.log("ERROR", myxhr.status, myxhr.response);
//                    }
//                }
//            }
//        })(xhr);
//        xhr.send("{  \"subscriber\": {}    }");
//    }

    Loader{
        id: webviewloader;
        anchors.fill: parent;
    }

    Component{
        id: webview;
        WebView {
            anchors.fill: parent
            url: subscribe_url
            onLoadingChanged: {
                if (loadRequest.errorString)
                    console.error(loadRequest.errorString);
            }
        }
    }


    Component.onCompleted: {
        createSubscriber();
    }
}
