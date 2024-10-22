
function http_status --argument-names code
    set status_lookup \
        100 100 Continue \
        101 101 "Switching Protocols" \
        102 102 Processing \
        103 199 Unassigned \
        200 200 OK \
        201 201 Created \
        202 202 Accepted \
        203 203 "Non-Authoritative Information" \
        204 204 "No Content" \
        205 205 "Reset Content" \
        206 206 "Partial Content" \
        207 207 Multi-Status \
        208 208 "Already Reported" \
        209 225 Unassigned \
        226 226 "IM Used" \
        227 299 Unassigned \
        300 300 "Multiple Choices" \
        301 301 "Moved Permanently" \
        302 302 Found \
        303 303 "See Other" \
        304 304 "Not Modified" \
        305 305 "Use Proxy" \
        306 306 Reserved \
        307 307 "Temporary Redirect" \
        308 308 "Permanent Redirect" \
        309 399 Unassigned \
        400 400 "Bad Request" \
        401 401 Unauthorized \
        402 402 "Payment Required" \
        403 403 Forbidden \
        404 404 "Not Found" \
        405 405 "Method Not Allowed" \
        406 406 "Not Acceptable" \
        407 407 "Proxy Authentication Required" \
        408 408 "Request Timeout" \
        409 409 Conflict \
        410 410 Gone \
        411 411 "Length Required" \
        412 412 "Precondition Failed" \
        413 413 "Request Entity Too Large" \
        414 414 "Request-URI Too Long" \
        415 415 "Unsupported Media Type" \
        416 416 "Requested Range Not Satisfiable" \
        417 417 "Expectation Failed" \
        422 422 "Unprocessable Entity" \
        423 423 Locked \
        424 424 "Failed Dependency" \
        425 425 Unassigned \
        426 426 "Upgrade Required" \
        427 427 Unassigned \
        428 428 "Precondition Required" \
        429 429 "Too Many Requests" \
        430 430 Unassigned \
        431 431 "Request Header Fields Too Large" \
        432 499 Unassigned \
        500 500 "Internal Server Error" \
        501 501 "Not Implemented" \
        502 502 "Bad Gateway" \
        503 503 "Service Unavailable" \
        504 504 "Gateway Timeout" \
        505 505 "HTTP Version Not Supported" \
        506 506 "Variant Also Negotiates (Experimental)" \
        507 507 "Insufficient Storage" \
        508 508 "Loop Detected" \
        509 509 Unassigned \
        510 510 "Not Extended" \
        511 511 "Network Authentication Required" \
        512 599 Unassigned
    # linear search, sad
    # TODO: binary search!
    set lower 1
    set upper 2
    while test \
            $status_lookup[$lower] -gt $code -o \
            $status_lookup[$upper] -lt $code
        set lower (math "$lower + 3")
        set upper (math "$lower + 1")
    end
    echo $status_lookup[(math "$lower + 2")]
end
