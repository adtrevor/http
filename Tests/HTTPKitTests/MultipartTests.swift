import HTTPKit
import XCTest

class MultipartTests: XCTestCase {
    let named = """
    test123
    aijdisadi>SDASD<a|

    """
    
    let multinamed = """
    test123
    aijdisadi>dwekqie4u219034u129e0wque90qjsd90asffs


    SDASD<a|

    """
    
    func testBasics() throws {
        let data = """
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn\r\n\
        Content-Disposition: form-data; name="test"\r\n\
        \r\n\
        eqw-dd-sa----123;1[234\r\n\
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn\r\n\
        Content-Disposition: form-data; name="named"; filename=""\r\n\
        \r\n\
        \(named)\r\n\
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn\r\n\
        Content-Disposition: form-data; name="multinamed[]"; filename=""\r\n\
        \r\n\
        \(multinamed)\r\n\
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn--\r\n
        """
        let parts = try! MultipartParser().parse(data: data, boundary: "----WebKitFormBoundaryPVOZifB9OqEwP2fn")
        print(parts)
        XCTAssertEqual(parts.count, 3)
        XCTAssertEqual(parts.firstPart(named: "test")?.data, "eqw-dd-sa----123;1[234")
        XCTAssertEqual(parts.firstPart(named: "named")?.data, named)
        XCTAssertEqual(parts.firstPart(named: "multinamed[]")?.data, multinamed)

        let serialized = try MultipartSerializer().serialize(parts: parts, boundary: "----WebKitFormBoundaryPVOZifB9OqEwP2fn")
        XCTAssertEqual(serialized, data)
    }

    func testMultifile() throws {
        let data = """
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn\r\n\
        Content-Disposition: form-data; name="test"\r\n\
        \r\n\
        eqw-dd-sa----123;1[234\r\n\
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn\r\n\
        Content-Disposition: form-data; name="multinamed[]"; filename=""\r\n\
        \r\n\
        \(named)\r\n\
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn\r\n\
        Content-Disposition: form-data; name="multinamed[]"; filename=""\r\n\
        \r\n\
        \(multinamed)\r\n\
        ------WebKitFormBoundaryPVOZifB9OqEwP2fn--\r\n
        """
        let parts = try MultipartParser().parse(data: data, boundary: "----WebKitFormBoundaryPVOZifB9OqEwP2fn")
        let file = parts.firstPart(named: "multinamed[]")?.data
        XCTAssertEqual(file, named)
        try XCTAssertEqual(MultipartSerializer().serialize(parts: parts, boundary: "----WebKitFormBoundaryPVOZifB9OqEwP2fn"), data)
    }

    func testFormDataEncoder() throws {
        struct Foo: Encodable {
            var string: String
            var int: Int
            var double: Double
            var array: [Int]
            var bool: Bool
        }
        let a = Foo(string: "a", int: 42, double: 3.14, array: [1, 2, 3], bool: true)
        let data = try FormDataEncoder().encode(a, boundary: "hello")
        XCTAssertEqual(data, """
        --hello\r\n\
        Content-Disposition: form-data; name="string"\r\n\
        \r\n\
        a\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="int"\r\n\
        \r\n\
        42\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="double"\r\n\
        \r\n\
        3.14\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="array[]"\r\n\
        \r\n\
        1\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="array[]"\r\n\
        \r\n\
        2\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="array[]"\r\n\
        \r\n\
        3\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="bool"\r\n\
        \r\n\
        true\r\n\
        --hello--\r\n
        """)
    }

    func testFormDataDecoderW3() throws {
        /// Content-Type: multipart/form-data; boundary=12345
        let data = """
        --12345\r\n\
        Content-Disposition: form-data; name="sometext"\r\n\
        \r\n\
        some text sent via post...\r\n\
        --12345\r\n\
        Content-Disposition: form-data; name="files"\r\n\
        Content-Type: multipart/mixed; boundary=abcde\r\n\
        \r\n\
        --abcde\r\n\
        Content-Disposition: file; file="picture.jpg"\r\n\
        \r\n\
        content of jpg...\r\n\
        --abcde\r\n\
        Content-Disposition: file; file="test.py"\r\n\
        \r\n\
        content of test.py file ....\r\n\
        --abcde--\r\n\
        --12345--\r\n
        """

        struct Foo: Decodable {
            var sometext: String
            var files: String
        }

        let foo = try FormDataDecoder().decode(Foo.self, from: data, boundary: "12345")
        XCTAssertEqual(foo.sometext, "some text sent via post...")
        XCTAssert(foo.files.contains("picture.jpg"))
    }

    func testFormDataDecoderMultiple() throws {
        /// Content-Type: multipart/form-data; boundary=12345
        let data = """
        --hello\r\n\
        Content-Disposition: form-data; name="string"\r\n\
        \r\n\
        string\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="int"\r\n\
        \r\n\
        42\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="double"\r\n\
        \r\n\
        3.14\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="array[]"\r\n\
        \r\n\
        1\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="array[]"\r\n\
        \r\n\
        2\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="array[]"\r\n\
        \r\n\
        3\r\n\
        --hello\r\n\
        Content-Disposition: form-data; name="bool"\r\n\
        \r\n\
        true\r\n\
        --hello--\r\n
        """

        struct Foo: Decodable {
            var string: String
            var int: Int
            var double: Double
            var array: [Int]
            var bool: Bool
        }

        let foo = try FormDataDecoder().decode(Foo.self, from: data, boundary: "hello")
        XCTAssertEqual(foo.string, "string")
        XCTAssertEqual(foo.int, 42)
        XCTAssertEqual(foo.double, 3.14)
        XCTAssertEqual(foo.array, [1, 2, 3])
        XCTAssertEqual(foo.bool, true)
    }

    func testFormDataDecoderFile() throws {
        /// Content-Type: multipart/form-data; boundary=12345
        let data = """
        --hello\r\n\
        Content-Disposition: form-data; name="file"; filename=foo.txt\r\n\
        \r\n\
        string\r\n\
        --hello--\r\n
        """

        struct Foo: Decodable {
            var file: HTTPFile
        }

        let foo = try FormDataDecoder().decode(Foo.self, from: data, boundary: "hello")
        XCTAssertEqual(foo.file.data, "string")
        XCTAssertEqual(foo.file.filename, "foo.txt")
        XCTAssertEqual(foo.file.contentType, HTTPMediaType.plainText)
        XCTAssertEqual(foo.file.ext, "txt")
    }

    func testDocBlocks() throws {
        do {
            /// Content-Type: multipart/form-data; boundary=123
            let data = """
            --123\r\n\
            \r\n\
            foo\r\n\
            --123--\r\n
            """
            let parts = try MultipartParser().parse(data: data, boundary: "123")
            XCTAssertEqual(parts.count, 1)
        }
        do {
            let part = MultipartPart(data: "foo")
            let data = try MultipartSerializer().serialize(parts: [part], boundary: "123")
            XCTAssertEqual(data, "--123\r\n\r\nfoo\r\n--123--\r\n")
        }
    }

    func testMultipleFile() throws {
        struct UserFiles: Decodable {
            var upload: [HTTPFile]
        }

        /// Content-Type: multipart/form-data; boundary=123
        let data = """
        --123\r\n\
        Content-Disposition: form-data; name="upload[]"; filename=foo1.txt\r\n\
        \r\n\
        upload1\r\n\
        --123\r\n\
        Content-Disposition: form-data; name="upload[]"; filename=foo2.txt\r\n\
        \r\n\
        upload2\r\n\
        --123\r\n\
        Content-Disposition: form-data; name="upload[]"; filename=foo3.txt\r\n\
        \r\n\
        upload3\r\n\
        --123--\r\n
        """

        let files = try FormDataDecoder().decode(UserFiles.self, from: data, boundary: "123")
        XCTAssertEqual(files.upload.count, 3)
    }
}
