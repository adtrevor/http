#if !canImport(ObjectiveC)
import XCTest

extension HTTPClientTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__HTTPClientTests = [
        ("testClientDefaultConfig", testClientDefaultConfig),
        ("testClientProxyPlaintext", testClientProxyPlaintext),
        ("testClientProxyTLS", testClientProxyTLS),
        ("testExampleCom", testExampleCom),
        ("testGoogleAPIsFCM", testGoogleAPIsFCM),
        ("testGoogleWithTLS", testGoogleWithTLS),
        ("testHTTPBin418", testHTTPBin418),
        ("testHTTPBinAnything", testHTTPBinAnything),
        ("testHTTPBinRobots", testHTTPBinRobots),
        ("testQuery", testQuery),
        ("testRemotePeer", testRemotePeer),
        ("testSNIWebsite", testSNIWebsite),
        ("testUncleanShutdown", testUncleanShutdown),
        ("testVaporWithTLS", testVaporWithTLS),
        ("testZombo", testZombo),
    ]
}

extension HTTPCookieTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__HTTPCookieTests = [
        ("testCookieIsSerializedCorrectly", testCookieIsSerializedCorrectly),
        ("testCookieParse", testCookieParse),
        ("testMultipleCookiesAreSerializedCorrectly", testMultipleCookiesAreSerializedCorrectly),
    ]
}

extension HTTPHeaderTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__HTTPHeaderTests = [
        ("testAcceptHeader", testAcceptHeader),
    ]
}

extension HTTPServerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__HTTPServerTests = [
        ("testLargeResponseClose", testLargeResponseClose),
        ("testRFC1123Flip", testRFC1123Flip),
    ]
}

extension MultipartTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MultipartTests = [
        ("testBasics", testBasics),
        ("testDocBlocks", testDocBlocks),
        ("testFormDataDecoderFile", testFormDataDecoderFile),
        ("testFormDataDecoderMultiple", testFormDataDecoderMultiple),
        ("testFormDataDecoderW3", testFormDataDecoderW3),
        ("testFormDataEncoder", testFormDataEncoder),
        ("testMultifile", testMultifile),
        ("testMultipleFile", testMultipleFile),
    ]
}

extension URLEncodedFormCodableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__URLEncodedFormCodableTests = [
        ("testCodable", testCodable),
        ("testDecode", testDecode),
        ("testDecodeIntArray", testDecodeIntArray),
        ("testEncode", testEncode),
        ("testGH3", testGH3),
        ("testRawEnum", testRawEnum),
    ]
}

extension URLEncodedFormParserTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__URLEncodedFormParserTests = [
        ("testArray", testArray),
        ("testBasic", testBasic),
        ("testBasicWithAmpersand", testBasicWithAmpersand),
        ("testDictionary", testDictionary),
        ("testNestedParsing", testNestedParsing),
        ("testOptions", testOptions),
        ("testPercentDecoding", testPercentDecoding),
    ]
}

extension URLEncodedFormSerializerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__URLEncodedFormSerializerTests = [
        ("testNested", testNested),
        ("testPercentEncoding", testPercentEncoding),
        ("testPercentEncodingWithAmpersand", testPercentEncodingWithAmpersand),
    ]
}

extension WebSocketTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__WebSocketTests = [
        ("testClient", testClient),
        ("testClientTLS", testClientTLS),
        ("testServer", testServer),
        ("testServerContinuation", testServerContinuation),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HTTPClientTests.__allTests__HTTPClientTests),
        testCase(HTTPCookieTests.__allTests__HTTPCookieTests),
        testCase(HTTPHeaderTests.__allTests__HTTPHeaderTests),
        testCase(HTTPServerTests.__allTests__HTTPServerTests),
        testCase(MultipartTests.__allTests__MultipartTests),
        testCase(URLEncodedFormCodableTests.__allTests__URLEncodedFormCodableTests),
        testCase(URLEncodedFormParserTests.__allTests__URLEncodedFormParserTests),
        testCase(URLEncodedFormSerializerTests.__allTests__URLEncodedFormSerializerTests),
        testCase(WebSocketTests.__allTests__WebSocketTests),
    ]
}
#endif
