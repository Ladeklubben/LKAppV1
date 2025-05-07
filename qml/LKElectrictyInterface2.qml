import QtQuick 2.13

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

        if(callback) callback(result.success, result.data);
    }


    function returnError(res){
        alertbox.setSource("LKAlertBox.qml", {"message": JSON.parse(res).detail.map(item => item.msg).join(", ")});
    }

    function request_member_stored_settlements(callback) {
        http.request(
            '/user/esettlements',
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function remove_member_stored_settlement(hash_string, callback){
        http.put(
            '/user/esettlement/remove?ref=' + hash_string,
            '',
            response => handleHttpResponse(response, callback)
        );
    }

    function update_stored_settlement(hash_string, fixed_type, name, tariff, callback){
        var body = {
            'name': name,
            'type': fixed_type === true ? 'fixed' : 'variable',
            'tariff': tariff*0.8,
        }
        http.put(
            '/user/esettlement/update?ref=' + hash_string,
            JSON.stringify(body),
            response => handleHttpResponse(response, callback)
        );
    }

    function request_electricity_settlement(stationid, callback) {
        http.request(
            "/cp/" + stationid + "/electricitysettlement",
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function request_electricity_constants(stationid, callback) {
        http.request(
            "/cp/" + stationid + "/electricitypriceconstants",
            "",
            response => handleHttpResponse(response, callback)
        );
    }

    function req_add_new_settlement(stationid, date, fixed_type, name, tariff, callback){
        var body = {
            'name': name,
            'from': date,
            'type': fixed_type === true ? 'fixed' : 'variable',
            'tariff': tariff*0.8,
        }
        http.put(
            "/cp/" + stationid + "/electricitysettlement",
            JSON.stringify(body),
            response => handleHttpResponse(response, callback)
        );
    }

    function set_user_stored_settlement(stationid, date, ref_dict, callback){
        var body = {
            'from': date,
            'ref': ref_dict['hash'],
        }
        http.put(
            "/cp/" + stationid + "/electricitysettlement_ref",
            JSON.stringify(body),
            response => handleHttpResponse(response, callback)
        );
    }

    /* Remove is done based on the epoch timestamp - nothing else*/
    function delete_settlement_ref(stationid, date, callback){
        var body = {
            'from': date,
        }
        http.put(
            "/cp/" + stationid + "/electricitysettlement_ref/remove",
            JSON.stringify(body),
            response => handleHttpResponse(response, callback)
        );
    }

    function get_electricity_tax_settlements(stationid, callback) {
        http.request(
            "/cp/" + stationid + "/taxreductionsettlement",
            "",
            response => handleHttpResponse(response, callback)
        );
    }


    function add_electricity_tax_settlement(stationid, date, tax_reduction_on, tax_reduction_by_ladeklubben, callback){
        var body = {
            'from': date,
            'enabled': tax_reduction_on,
            'lk_handled': tax_reduction_by_ladeklubben
        }
        http.put(
            "/cp/" + stationid + "/taxreductionsettlement",
            JSON.stringify(body),
            response => handleHttpResponse(response, callback)
        );
    }


    function delete_tax_reduction_settlement(stationid, date, callback) {
        var body = {
            'from': date,
        }
        http.put(
            "/cp/" + stationid + "/taxreductionsettlement/remove",
            JSON.stringify(body),
            response => handleHttpResponse(response, callback)
        );
    }
}
