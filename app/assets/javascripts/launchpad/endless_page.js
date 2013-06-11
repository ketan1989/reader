var currentPage = 1;
var pathname = window.location.pathname;

function checkScroll(pathname) {
  currentPage++;
  $.ajax({
    type : "GET",
    url : pathname + '?page=' + currentPage,
    dataType: "jsonp"
  });
}

$(window).scroll(function(){
  if ($(window).scrollTop() == $(document).height() - $(window).height()){
    if ( currentPage < $('.pagination .page').length ) { $("#loading").show(); checkScroll(pathname); }
  }
});

$(document).ready( function () { 
  $("#loading").hide();
  $(".pagination").hide();
});