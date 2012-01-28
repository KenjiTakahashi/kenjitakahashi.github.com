(function() {
  var dates;

  dates = {
    "2012-01-01": [["A Test...", "/2012/01/01/a-test.html"]],
    "2012-01-02": [["a very long title to test side-pane...", "/2012/01/02/a-long-title.html"]],
    "2012-01-14": [["Another test...", "/2012/01/14/test-2.html"], ["testing 2-on-1...", "/2012/01/14/test-3.html"]]
  };

  jQuery.datepicker.oldAdjustDate = jQuery.datepicker._adjustDate;

  jQuery.datepicker._adjustDate = function(id, offset, period) {
    jQuery.datepicker.oldAdjustDate(id, offset, period);
    return this._notifyChange(this._getInst($(id)[0]));
  };

  jQuery.datepicker.oldSelectDate = jQuery.datepicker._selectDate;

  jQuery.datepicker._selectDate = function(id, dateStr) {
    jQuery.datepicker.oldSelectDate(id, dateStr);
    return this._notifyChange(this._getInst($(id)[0]));
  };

  $(document).ready(function() {
    var arrowsWidth, callback, options;
    options = {
      direction: 'down',
      duration: 'medium',
      easing: 'easeOutQuart'
    };
    arrowsWidth = function() {
      var $title, width;
      $title = $(".ui-datepicker-title");
      width = (252 - parseInt($title.css('width'))) / 2;
      $(".ui-datepicker-next, .ui-datepicker-prev").width(width);
      return $title.css('display', 'block');
    };
    callback = function($base, dateText) {
      var $href, date, v, _i, _len, _ref, _ref2;
      $base.empty();
      date = dateText.split('/').reverse();
      _ref = [date[2], date[1]], date[1] = _ref[0], date[2] = _ref[1];
      _ref2 = dates[date.join('-')];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        v = _ref2[_i];
        $href = $("<a class='event' href='#" + v[1] + "'>").text(v[0]);
        $href.click(function() {
          return $.ajax({
            url: v[1],
            success: function(html) {
              var $center;
              $center = $("#center");
              return $center.hide('highlight', {
                color: "#FFFFFF"
              }, function() {
                $center.empty();
                $center.append(html);
                $center.children().hide();
                $center.show();
                return $center.children(".title").show('slide', function() {
                  return $center.children(".content").show('blind');
                });
              });
            }
          });
        });
        $base.append($href);
      }
      $base.css('bottom', $("#calendar").css('height'));
      return $base.toggle('slide', options);
    };
    $("#calendar").datepicker({
      showOtherMonths: true,
      selectOtherMonths: true,
      beforeShowDay: function(date) {
        var d, _;
        for (d in dates) {
          _ = dates[d];
          if (new Date(Date.parse(d)).setHours(0, 0, 0, 0) === date.setHours(0, 0, 0, 0)) {
            return [true, ''];
          }
        }
        return [false, ''];
      },
      onSelect: function(dateText, inst) {
        var $base;
        $base = $("#events");
        if ($base.css('display') !== 'none') {
          return $base.toggle('slide', options, function() {
            return callback($base, dateText);
          });
        } else {
          return callback($base, dateText);
        }
      },
      onChangeMonthYear: function(year, month, inst) {
        var $base;
        $base = $("#events");
        if ($base.css('display') !== 'none') {
          $base.css('bottom', $("#calendar").css('height'));
        }
        return arrowsWidth();
      }
    });
    return arrowsWidth();
  });

}).call(this);