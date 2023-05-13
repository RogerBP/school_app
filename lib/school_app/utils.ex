defmodule SchoolApp.Utils do
  def nvl(nil, value), do: value
  def nvl(value, _), do: value
end
