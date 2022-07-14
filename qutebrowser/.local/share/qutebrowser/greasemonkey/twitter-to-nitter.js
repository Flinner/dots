// ==UserScript==
// @name           Twitter to Nitter redirector
// @namespace      mamg22's userscripts
// @match          http://twitter.com/*
// @match          https://twitter.com/*
// @match          http://www.twitter.com/*
// @match          https://www.twitter.com/*
// @run-at         document-start
// ==/UserScript==

location.href=location.href.replace("twitter.com","nitter.net");

