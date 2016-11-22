$(document).ready(function(){
  var suggestionDiv = document.getElementsByClassName("suggestion-diff")[0];

  if(suggestionDiv) {
    var diffString = suggestionDiv.textContent;
    var diff2htmlUi = new Diff2HtmlUI({diff: diffString});
    diff2htmlUi.draw("div.suggestion-diff", {inputFormat: 'diff', showFiles: true, matching: 'lines'});
  }

});
