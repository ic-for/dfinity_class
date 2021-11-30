import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Text "mo:base/Text";

shared(msg) actor class Quicksort() = this {

    public type HttpRequest = {
        body: Blob;
        headers: [HeaderField];
        method: Text;
        url: Text;
    };

    public type StreamingCallbackToken =  {
        content_encoding: Text;
        index: Nat;
        key: Text;
        sha256: ?Blob;
    };
    public type StreamingCallbackHttpResponse = {
        body: Blob;
        token: ?StreamingCallbackToken;
    };
    public type ChunkId = Nat;

    public type Path = Text;
    public type Key = Text;

    public type HttpResponse = {
        body: Blob;
        headers: [HeaderField];
        status_code: Nat16;
        streaming_strategy: ?StreamingStrategy;
    };

    public type StreamingStrategy = {
        #Callback: {
            callback: query (StreamingCallbackToken) ->
            async (StreamingCallbackHttpResponse);
            token: StreamingCallbackToken;
        };
    };

    public type HeaderField = (Text, Text);


    public func greet(name : Text) : async Text {
        return "Hello, " # name # "!";
    };
    
    private func extractQueryString(str : Text) : Text {
        let querystring = Text.split(str, #char '?');
        ignore querystring.next(); 
        getOrEmptyText(querystring.next()) 
    };

    public query func http_request(req: HttpRequest) : async HttpResponse {
        let querystring = extractQueryString(req.url);
        Debug.print("querystring is : " # querystring);
        var content = "";
        let contents = Text.split(querystring, #char '&');
        let space = "%20";
        
        for (c in contents) {
            let cc = Text.split(c, #char '=');
            if (cc.next() == ?"content") {
                content := Text.replace(getOrEmptyText(cc.next()), #text space, " ");
            };
        };

        Debug.print("The request body: " # content);

        return {
            body = Text.encodeUtf8(content);
            headers = [];
            status_code = 200;
            streaming_strategy = null;
        };
    };

    public func qsort(arr: [Int]) : async [Int] {
        let mutArr = Array.thaw<Int>(arr);
        quicksort(mutArr);
        Array.freeze<Int>(mutArr)
    };
    
    private func quicksort(arr: [var Int]) {
        sortBy_(arr, 0, arr.size() - 1)
    };

    private func getOrEmptyText(str: ?Text) : Text {
        switch (str) {
            case (?s) s;
            case (null) "";
        }
    };

    private func sortBy_(arr: [var Int], l: Int, h: Int) {
        if (l < h) {
            var i = l;
            var j = h;
            var temp = arr[0];
            var pivot = arr[Int.abs(l + h) / 2];
            while (i <= j) {
                while (arr[Int.abs(i)] < pivot) {
                    i += 1;
                };
                while (arr[Int.abs(j)] > pivot) {
                    j -= 1;
                };

                if (i <= j) {
                    temp := arr[Int.abs(i)];
                    arr[Int.abs(i)] := arr[Int.abs(j)];
                    arr[Int.abs(j)] := temp;

                    i += 1;
                    j -= 1;
                };
            };

            if (l < j) {
                sortBy_(arr, l, j);
            };
            if (i < h) {
                sortBy_(arr, i, h);
            };
        };
    };  

    
};

