import QtQuick

QtObject {
    function handleHttpResponse(response, callback) {
        if (response.readyState !== XMLHttpRequest.DONE) return;

        var result = {
            success: false,
            data: null
        };

        if (response.status === 200) {
            result.success = true;
            result.data = JSON.parse(response.responseText);
        } else if (response.status === 0) {
            alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
        } else {
            returnError(response.responseText);
        }

        callback(result.success, result.data);
    }

    function returnError(res) {
        alertbox.setSource("LKAlertBox.qml", {
            "message": JSON.parse(res).detail.map(item => item.msg).join(", ")
        });
    }

    function get_mainmeter(installationid, callback) {
        http.request(
            `/installation/mainmeter_tmp`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }
}
