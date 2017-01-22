# scss 生成用

use v5.24;
use warnings;
use utf8;

system "sass --watch public/scss:public/css --cache-location public/scss/cache --style expanded";

