$('.hide-eng').click(function () {
  $('a[href*="en.html"]').parent().parent().not('ul').hide();
  $('a[href*="fr.html"]').parent().parent().not('ul').show();
  $('a[href*=".fr"]').parent().parent().not('ul').show();
});

$('.hide-fr').click(function () {
  $('a[href*="en.html"]').parent().parent().not('ul').show();
  $('a[href*="fr.html"]').parent().parent().not('ul').hide();
  $('a[href*=".fr"]').parent().parent().not('ul').hide();
  //   $('a:contains(.fr)').parent().parent().not('ul').hide();
});

$('.show-all').click(function () {
  $('a[href*="en.html"]').parent().parent().not('ul').show();
  $('a[href*="fr.html"]').parent().parent().not('ul').show();
  $('a[href*=".fr"]').parent().parent().not('ul').show();
});

var links = document.links;

for (var i = 0, linksLength = links.length; i < linksLength; i++) {
  if (links[i].hostname != window.location.hostname) {
    links[i].target = '_blank';
  }
}

// var _hmt = _hmt || [];
// (function() {
//   var hm = document.createElement("script");
//   hm.src = "https://hm.baidu.com/hm.js?753f79e58eab10bb1df8a1345846d364";
//   var s = document.getElementsByTagName("script")[0];
//   s.parentNode.insertBefore(hm, s);
// })();

//rubbon
// ---------------------------------------------------------------------------------------------------------
