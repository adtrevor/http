import CHTTP
import Core
import Foundation

/// Parses requests from a readable stream.
public final class RequestParser: Core.Stream, CParser {
    // Internal variables to conform
    // to the C HTTP parser protocol.
    var parser: http_parser
    var settings: http_parser_settings
    var state:  CHTTPParserState

    /// Creates a new Request parser.
    public init() {
        self.parser = http_parser()
        self.settings = http_parser_settings()
        self.state = .ready
        http_parser_init(&parser, HTTP_REQUEST)
        initialize(&settings)
    }

    /// Parses a Request from the stream.
    public func parse(from buffer: ByteBuffer) throws -> Request? {
        let results: CParseResults

        switch state {
        case .ready:
            // create a new results object and set
            // a reference to it on the parser
            let newResults = CParseResults.set(on: &parser)
            results = newResults
            state = .parsing
        case .parsing:
            // get the current parse results object
            guard let existingResults = CParseResults.get(from: &parser) else {
                return nil
            }
            results = existingResults
        }

        /// parse the message using the C HTTP parser.
        try executeParser(max: buffer.count, from: buffer)

        guard results.isComplete else {
            return nil
        }

        // the results have completed, so we are ready
        // for a new request to come in
        state = .ready
        CParseResults.remove(from: &parser)


        /// switch on the C method type from the parser
        let method: Method
        switch http_method(parser.method) {
        case HTTP_DELETE:
            method = .delete
        case HTTP_GET:
            method = .get
        case HTTP_POST:
            method = .post
        case HTTP_PUT:
            method = .put
        case HTTP_OPTIONS:
            method = .options
        case HTTP_PATCH:
            method = .patch
        default:
            /// custom method detected,
            /// convert the method into a string
            /// and use Engine's other type
            guard
                let pointer = http_method_str(http_method(parser.method)),
                let string = String(validatingUTF8: pointer)
                else {
                    throw "ParserError.invalidMessage"
            }
            method = Method(string)
        }

        // parse the uri from the url bytes.
        var uri = URIParser.shared.parse(bytes: results.url!)


        let headers = Headers(dictionaryElements: results.headers)

        // set the host on the uri if it exists
        // in the headers
        if let hostname = headers["host"] {
            let (host, port) = parse(host: hostname.stringValue)
            uri.hostname = host
            uri.port = port ?? uri.port
        }

        // if there is no scheme, use http by default
        if uri.scheme.isEmpty == true {
            uri.scheme = "http"
        }

        // require a version to have been parsed
        guard let version = results.version else {
            throw "ParserError.invalidMessage"
        }

        let body: Body
        if let data = results.body {
            var copied = Data(data)
            let buffer = UnsafeMutableBufferPointer<Byte>.init(start: copied.withUnsafeMutableBytes { $0 }, count: data.count)
            body = Body.init(pointingTo: buffer, deallocating: false)
        } else {
            body = Body([])
        }


        // create the request
        let request = Request(
            method: method,
            uri: uri,
            version: version,
            headers: headers,
            body: body
        )

        return request
    }

    func parse(host: String) -> (host: String, port: Port?) {
        let components = host.split(
            separator: ":",
            maxSplits: 1,
            omittingEmptySubsequences: true
        )
        if components.count == 2 {
            let host = String(components[0])
            let port = UInt16(String(components[1]))
            return (host, port)
        } else {
            return (host, nil)
        }
    }

    // MARK: Stream

    public typealias Output = Request
    public typealias RequestHandler = (Request) throws -> (Void)
    var closures: [RequestHandler] = []

    public func then(_ closure: @escaping RequestHandler) {
        closures.append(closure)
    }
}

