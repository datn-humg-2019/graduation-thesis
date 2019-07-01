$(document).ready(function() {
  if (window.location.pathname.includes("inventories")){
    if(window.location.hash == "") {
      return;
    } else {
      $("tr[data-target='" + window.location.hash + "']").css("background-color", "#e0ebeb");
    }
  }
});
