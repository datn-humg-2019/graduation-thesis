$(document).ready(function() {
  $('body').on('click', '.close_tag', function(){
    $(this).parent().remove();
  });
});
$( function() {
  var availableTags = dataTags.getTags().split(" ");
  function split(val) {
    return val.split(/ \s*/);
  }
  function extractLast(term) {
    return split(term).pop();
  }
  $("#tags")
    .on("keydown", function(event) {
      if (event.keyCode === $.ui.keyCode.TAB && $(this).autocomplete("instance").menu.active) {
        event.preventDefault();
      }
    })
    .autocomplete({
      minLength: 0,
      source: function(request, response) {
        response($.ui.autocomplete.filter(
          availableTags, extractLast(request.term)));
      },
      focus: function() {
        return false;
      },
      select: function(event, ui) {
        var terms = split(this.value);
        console.log(availableTags);
        terms.pop();
        terms.push(ui.item.value);
        terms.push("");
        availableTags.remove(ui.item.value)
        this.value = terms.join(" ");
        return false;
      }
    });
});
