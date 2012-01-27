(function() {
  var dates;

  dates = {
    '2012-01-01': ['sth'],
    '2012-01-04': []
  };

  $(document).ready(function() {
    return $("#calendar").datepicker({
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
        return alert(new Date(dateText));
      }
    });
  });

}).call(this);
