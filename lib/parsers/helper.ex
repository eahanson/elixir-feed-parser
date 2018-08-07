defmodule ElixirFeedParser.Parsers.Helper do
  alias ElixirFeedParser.XmlNode

  def element(node, selector) do
    node |> XmlNode.find(selector) |> XmlNode.text
  end

  def element(node, selector, [attr: attr]) do
    node |> XmlNode.find(selector) |> XmlNode.attr(attr)
  end

  def elements(node, selector) do
    node |> XmlNode.map_children(selector, fn(e) -> XmlNode.text(e) end)
  end

  def elements(node, selector, [attr: attr]) do
    node |> XmlNode.map_children(selector, fn(e) -> XmlNode.attr(e, attr) end)
  end

  def to_date_time(date_time_string), do: to_date_time(date_time_string, "RFC_1123")
  def to_date_time(nil, _), do: nil

  def to_date_time(date_time_string, "ISO_8601") do
    {:ok, date_time, _} = DateTime.from_iso8601(date_time_string)
    date_time
  end

  def to_date_time(date_time_string, "RFC_1123") do
    formats = [
      "{RFC1123}",
      "{WDshort}, {D} {Mshort} {YYYY} {h24}:{m}:{s} 0000",
      "{D} {Mshort} {YYYY} {h24}:{m}:{s} {Zabbr}"
    ]

    parsed =
      Enum.find_value(formats, fn format ->
        case to_date_time(date_time_string, "RFC_1123", format) do
          {:ok, date_time} -> date_time
          _ -> false
        end
      end)

    parsed || raise "Could not parse #{date_time_string}"
  end

  def to_date_time(date_time_string, "RFC_1123", timex_format) do
    case Timex.parse(date_time_string, timex_format) do
      {:ok, %NaiveDateTime{} = naive_date_time} ->
        {:ok, naive_date_time |> DateTime.from_naive!("Etc/UTC")}
      result ->
        result
    end
  end
end
