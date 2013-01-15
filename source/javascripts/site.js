$(document).ready(function(){
  if (location.pathname.match(/rankings/)) {
    $('li.rankings').addClass('current');
  } else if (location.pathname.match(/rank-history/)) {
    $('li.rank-history').addClass('current');
  } else if (location.pathname.match(/tournaments/)) {
    $('li.tournaments').addClass('current');
  }
});
