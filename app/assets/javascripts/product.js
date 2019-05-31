$(document).ready(function() {
  if (window.location.pathname.includes("products/new")){
    currency_input();
  }

  $('body').on('click', '.close_tag', function(){
    $(this).parent().remove();
  });

  if (window.location.pathname.includes("warehouses")){
    var availableTags = dataTags.getTags().split(" ");
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
          terms.pop();
          terms.push(ui.item.value);
          terms.push("");
          availableTags.remove(ui.item.value)
          this.value = terms.join(" ");
          return false;
        }
      });
  }
});

function split(val) {return val.split(/ \s*/);}

function extractLast(term) {return split(term).pop();}
