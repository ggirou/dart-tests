import 'dart:async';
import 'package:guinness/guinness.dart';

void main() {
  it("contains spec with an expectation", () {
    expect(true).toBe(true);
    expect(1 + 1).toEqual(2);
  });

  bePositive(i) => i > 0;

  it("should expect a positive number", () {
    expect(42).to(bePositive);
  });

  it("should expect an exception", () {
    expect(() => throw "BOOM").toThrowWith(message: 'BOOM');
  });

  it("should expect async result", () {
    return queryDatabase().then((results) {
      expect(results).toEqual([]);
    });
  });

  describe("A suite", () {
    beforeEach(() {
      startServer();
    });

    afterEach(() {
      stopServer();
    });

    it("should ...", () {});

    describe("nested suite", () {
      // ...
    });
  });
}

Future queryDatabase() => new Future.value([]);

void stopServer() {
}

void startServer() {
}
