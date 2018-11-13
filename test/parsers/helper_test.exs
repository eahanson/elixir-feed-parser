defmodule ElixirFeedParser.Test.HelperTest do
  use ExUnit.Case

  import DateTime, only: [to_iso8601: 1]
  import ElixirFeedParser.Parsers.Helper, only: [to_date_time: 1, to_date_time: 2]

  describe "to_date_time" do
    test "returns nil for nil datetimes" do
      assert to_date_time(nil) == nil
    end

    test "can parse ISO_8601 datetimes" do
      assert to_date_time("2015-01-23T23:50:07.123+02:30", "ISO_8601") |> to_iso8601() == "2015-01-23T21:20:07.123Z"
    end

    test "can parse RFC_1123 datetimes" do
      assert to_date_time("Tue, 06 Mar 2013 01:25:19 +0200", "RFC_1123") |> to_iso8601() == "2013-03-06T01:25:19+02:00"
    end

    test "can parse RFC_1123 datetimes with malformed timezones" do
      assert to_date_time("Wed, 17 Apr 2014 12:06:00 0000", "RFC_1123") |> to_iso8601() == "2014-04-17T12:06:00Z"
    end

    test "can parse RFC_1123 datetimes without a weekday" do
      assert to_date_time("7 Mar 2016 18:16:14 GMT", "RFC_1123") |> to_iso8601() == "2016-03-07T18:16:14+00:00"
    end

    test "can parse RFC_1123 datetimes that contain whitespace at the beginning and end" do
      assert to_date_time("""
                  Sun, 11 Nov 2018 19:27:15 GMT
              """, "RFC_1123") |> to_iso8601() == "2018-11-11T19:27:15+00:00"
    end

    test "can parse RFC_1123 datetimes without seconds" do
      assert to_date_time("Sun, 11 Nov 2018 19:20 GMT", "RFC_1123") |> to_iso8601() == "2018-11-11T19:20:00+00:00"
    end

    test "can parse RFC_1123 datetimes with bad DOWs" do
      assert to_date_time("Web, 28 May 2014 00:00:00 +0000", "RFC_1123") |> to_iso8601() == "2014-05-28T00:00:00Z"
    end
  end
end
