// ==UserScript==
// @name           reddit to old.reddit redirector
// @namespace      mamg22's userscripts
// @match          http://www.reddit.com/*
// @match          https://www.reddit.com/*
// @match          http://reddit.com/*
// @match          https://reddit.com/*
// @run-at         document-start
// ==/UserScript==

location.href = location.href.replace("www.reddit.com", "old.reddit.com");
