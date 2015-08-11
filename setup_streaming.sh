#! /bin/sh

(xset -dpms && xset s off) \
    || echo streaming setup failed && echo && xset q
