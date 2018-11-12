$(window).load(function(){
  $(".chosen-select").chosen(
    {
      allow_single_deselect: true,
      width: '300px',
      placeholder_text_multiple: '選択してください'
    });
});
