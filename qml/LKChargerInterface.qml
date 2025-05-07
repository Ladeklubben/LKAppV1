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

        callback(result.success, result.data);
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

    function req_stats(chargepoint, year=null, month=null, day=null, callback) {
        const querystring = buildQueryString({
            year: year,
            month: month,
            day: day
        });

        http.request(
            `/cp/${chargepoint}/stats${querystring}`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function set_smart_charge(chargepoint, enable, setup, callback) {
        const querystring = enable ? '?enable=1' : '';

        http.put(
            `/cp/${chargepoint}/smart${querystring}`,
            JSON.stringify(setup),
            response => handleHttpResponse(response, callback)
        );
    }

    function get_smart_charge_setup(chargepoint, callback) {
        http.request(
            `/cp/${chargepoint}/smart`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function get_charger_smart_schedule(chargepoint, callback) {
        http.request(
            `/cp/${chargepoint}/smart_schedule`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function set_charger_smart_pause(chargepoint, callback) {
        http.put(
            `/cp/${chargepoint}/smart_pause`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function set_charger_smart_play(chargepoint, callback) {
        http.put(
            `/cp/${chargepoint}/smart_play`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function set_charger_smart_recalc(chargepoint, callback) {
        http.put(
            `/cp/${chargepoint}/smart_recalc`,
            "",
            response => handleHttpResponse(response, callback)
        );
    }
}
