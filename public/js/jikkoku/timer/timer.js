"use strict";

(function () {

  jikkoku.namespace('timer.Timer');

  jikkoku.timer.Timer = function (dom) {
    this.dom = dom;
    this.showTimeDom = dom.getElementsByClassName('show-time')[0];
    this.timeDom = this.showTimeDom.getElementsByClassName('time')[0];
    this.hiddenContentsDom = dom.getElementsByClassName('hidden-contents')[0];
    this.second = Number( this.timeDom.innerHTML );
  };

  var PROTOTYPE = jikkoku.timer.Timer.prototype;

  PROTOTYPE.initDom = function () {
    this.hiddenContentsDom.style.display = 'none';
  };

  PROTOTYPE.loopWork = function () {
    this.second -= 1;
    this.timeDom.innerHTML = this.second;
    if (this.second <= 0) {
      this.showTimeDom.style.display = 'none';
      this.hiddenContentsDom.style.display = 'inline-block';
      return false;
    } else {
      return true;
    }
  };

}());

