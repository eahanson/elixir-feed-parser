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
  end
end
