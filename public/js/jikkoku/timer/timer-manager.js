"use strict";

(function () {

  jikkoku.namespace('timer.TimerManager');

  jikkoku.timer.TimerManager = function () {
    this.timers = [];
  };

  var PROTOTYPE = jikkoku.timer.TimerManager.prototype;

  PROTOTYPE.addTimer = function (dom) {
    var timer = new jikkoku.timer.Timer(dom);
    this.timers.push(timer);
  };

  PROTOTYPE.loop = function () {
    setInterval(function () {
      this.timers = this.timers.filter(function (timer) {
        return timer.loopWork();
      });
    }.bind(this), 1000);
  };

  PROTOTYPE.registFunctions = function () {
    Array.prototype.forEach.call(document.getElementsByClassName('timer'), function (elem) {
      this.addTimer(elem);
    }.bind(this));
  };

  PROTOTYPE.init = function () {
    this.timers.forEach(function (timer) {
      timer.initDom();
    });
  };

}());

