$ ->
  $('#videos-container').imagesLoaded ->
    $('#videos-container').masonry
      itemSelector: '.box'
      isFitWidth: true
  $('#videos-container').infinitescroll ->
    navselector: '#page-nav'
    nextselector: '#page-nav a'
    itemSelector: '.box'
    loading: {
      finishedMsg: 'No more pins to load.'
      img: 'http://i.imgur.com/6RMhx.gif'
    }
