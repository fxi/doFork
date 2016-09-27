
/**
 * Create and manage multiple progression bar
 * @param {otpions} options : anchor, enable, id, percent, text
 */
var progressScreen = function(options) {

  var o = options;

  lAnchor = document.getElementById(o.anchor);

  if(!lAnchor) return;

  lScreen = lAnchor.querySelector(".loading-screen");

  if ( o.enable === false ) {
    if (lScreen) lScreen.remove();
  }else{

    if (!o.id || !o.percent || !o.text) return;

    if (!lScreen) {
      lScreen = document.createElement("div");
      lScreen.className = "loading-screen";
      lScreenContainer = document.createElement("div");
      lScreenContainer.className = "loading-container";
      lScreen.appendChild(lScreenContainer);
      lAnchor.appendChild(lScreen);
    }

    lScreenContainer = lScreen.querySelector(".loading-container");
    lItem = lScreen.querySelector("#"+o.id);

    if ( !lItem  ) {
        lItem = document.createElement("div");
        lItem.className = "loading-item";
        lItem.setAttribute("id", o.id);
        pBarIn = document.createElement("div");
        pBarIn.className = "loading-bar-in";
        pBarOut = document.createElement("div");
        pBarOut.className = "loading-bar-out";
        pBarTxt = document.createElement("div");
        pBarTxt.className = "loading-bar-txt";
        pBarOut.appendChild(pBarIn);
        lItem.appendChild(pBarTxt);
        lItem.appendChild(pBarOut);
        lScreenContainer.appendChild(lItem);
    } else {
      pBarIn = lItem.getElementsByClassName("loading-bar-in")[0];
      pBarTxt = lItem.getElementsByClassName("loading-bar-txt")[0];
    }

    if ( o.percent >= 100 ){
      if (lItem) lItem.remove();
    } else {
      pBarIn.style.width = o.percent + "%";
      pBarTxt.innerHTML = o.text;
    }

  lItems = lScreenContainer.querySelectorAll(".loading-item");

  if (lItems.length < 1){
    lScreen.remove();
  }
}
};

