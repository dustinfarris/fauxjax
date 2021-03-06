module "unhandled array tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "unhandled array correctly collects real ajax calls", (assert) ->
  done = assert.async()

  $.ajax
    method: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      unhandled = $.fauxjax.unhandled()
      assert.equal(unhandled.length, 1, "incorrect number of real ajax calls in unhandled array")
      assert.equal(unhandled[0].method, "GET", "request has incorrect method")
      assert.equal(unhandled[0].url, "/faux-request", "real ajax call has incorrect url")
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "unhandled array is cleared when fauxjax.clear is called", (assert) ->
  done = assert.async()

  $.ajax
    method: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      unhandled = $.fauxjax.unhandled()
      assert.equal(unhandled.length, 1, "incorrect number of real ajax calls in unhandled array")
      assert.equal(unhandled[0].method, "GET", "request has incorrect method")
      assert.equal(unhandled[0].url, "/faux-request", "real ajax call has incorrect url")
      $.fauxjax.clear()
      unhandled = $.fauxjax.unhandled()
      assert.equal(unhandled.length, 0, "unhandled was not properly cleared")
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "unhandled array returns nothing when no actual ajax calls occur", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "GET"
    url: "/faux-request"

  $.ajax
    method: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      unhandled = $.fauxjax.unhandled()
      assert.equal(unhandled.length, 0, "No unhandled should have occured")
      done()
