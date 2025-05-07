import QtQuick 2.14

QtObject {
    property string token;

    function request(url, body, callback) {
        var xhr = new XMLHttpRequest();
        url = serveraddr + url
        xhr.open('GET', url, true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.setRequestHeader("Authorization", 'Bearer ' + token);
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                callback(myxhr);
            }
        })(xhr);
        xhr.send(body);
    }

    function post_login(url, body, callback) {
        var xhr = new XMLHttpRequest();
        url = serveraddr + url
        xhr.open('POST', url, true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                callback(myxhr);
            }
        })(xhr);
        xhr.send(body);
    }

    function post(url, body, callback) {
        var xhr = new XMLHttpRequest();
        url = serveraddr + url
        xhr.open('POST', url, true);
        xhr.setRequestHeader("Authorization", 'Bearer ' + token);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                callback(myxhr);
            }
        })(xhr);
        xhr.send(body);
    }

    function patch(url, body, callback) {
        var xhr = new XMLHttpRequest();
        url = serveraddr + url
        xhr.open('PATCH', url, true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.setRequestHeader("Authorization", 'Bearer ' + token);
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                callback(myxhr);
            }
        })(xhr);
        xhr.send(body);
    }

    function put(url, body, callback) {
        var xhr = new XMLHttpRequest();
        url = serveraddr + url
        xhr.open('PUT', url, true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.setRequestHeader("Authorization", 'Bearer ' + token);
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                callback(myxhr);
            }
        })(xhr);
        xhr.send(body);
    }

    function del(url, body, callback) {
        var xhr = new XMLHttpRequest();
        url = serveraddr + url
        xhr.open('DELETE', url, true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.setRequestHeader("Authorization", 'Bearer ' + token);
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                callback(myxhr);
            }
        })(xhr);
        xhr.send(body);
    }

    function set_authentication_token(authtoken){
        token = authtoken;
    }
}
