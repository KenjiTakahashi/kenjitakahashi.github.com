(function() {
  var tags;

  tags = {
    "testtag1": [["A Test", "/2012/01/01/a-test.html"]]
  };

  $(document).ready(function() {
    var callback, options;
    options = {
      duration: 'medium',
      easing: 'easeOutQuart'
    };
    callback = function($base, text) {
      var $href, p, _i, _len, _ref;
      $base.empty();
      _ref = tags[text];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        $href = $("<a class='tag' href='#" + p[1] + "'>").text(p[0]);
        $href.click(function() {
          return ajax(p[1]);
        });
        $base.append($href);
      }
      $base.css({
        bottom: 'auto',
        top: parseInt($("#cloud").css('height')) + 3
      });
      $base.attr('id', 'events_tag');
      options['direction'] = 'up';
      return $base.toggle('slide', options);
    };
    return $("#cloud > a").click(function() {
      var $base, text;
      $base = $(".events");
      text = $(this).text();
      if ($base.css('display') !== 'none') {
        if ($base.children('a').hasClass('event')) options['direction'] = 'down';
        return $base.toggle('slide', options, function() {
          return callback($base, text);
        });
      } else {
        return callback($base, $(this).text());
      }
    });
  });

}).call(this);
