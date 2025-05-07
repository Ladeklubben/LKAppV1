import QtQuick

QtObject {
    // Helper function to handle common HTTP response logic
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

        if(callback) callback(result.success, result.data);
    }

    function returnError(res) {
        alertbox.setSource("LKAlertBox.qml", {
            "message": JSON.parse(res).detail.map(item => item.msg).join(", ")
        });
    }

    function buildQueryString(params) {
        const validParams = Object.entries(params)
            .filter(([_, value]) => value !== null)
            .map(([key, value]) => `${key}=${value}`);

        return validParams.length ? '?' + validParams.join('&') : '';
    }

    function req_update_metervalues(chargepoint, callback) {
        http.put(
            `/ocpp/${chargepoint}/update_metervalues`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }
}
