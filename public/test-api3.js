Log.format = function(message) {
  if(message) {
    return message.toString().replace(/</g, '&lt;') + '<br>';
  }
  else {
    return "<br>";
  }
}

Log.debug = function(message) {
  Mojo.Log.info(message)
  this.items.push({message: this.format(message)})

  if(this.items.length > 50) {
    this.items.splice(0, 1)
  }
}

Redbox.initialize = function(url) {
  new Ajax.Request(url || "http://www.redbox.com", {
    method: "get",

    onSuccess: function(response) {
      var match = response.responseText.match(/rb\.api\.key *= * [',"](.*?)[',"]/)

      if(match && match.length > 1) {
        Redbox.key2 = match[1]
        Log.debug("api 2 key = " + Redbox.key2)
      }

      match = response.responseText.match(/__K.*value="(.*)"/)

      if(match && match.length > 1) {
        Redbox.key = match[1]
        Log.debug("api 1 key = " + Redbox.key)
      }

      if(!Redbox.key && !Redbox.key2 && !url) {
        Redbox.initialize("http://www.redbox.com/home");
      }
    }
  });
}

Redbox.initialize();
