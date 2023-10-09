window.onload = append_fn window.onload, ->
  module("Application")

  test "localise_date", ->
    equals(localise_date("2010-09-20", "en-GB"), "20/09/2010")
