(function() {
  window.onload = append_fn(window.onload, function() {
    module("Application");
    return test("localise_date", function() {
      return equals(localise_date("2010-09-20", "en-GB"), "20/09/2010");
    });
  });
})();
