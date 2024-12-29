#!/usr/bin/osascript -l JavaScript
var Safari = new Application("/Applications/Safari.app");
Safari.activate();
window = Safari.windows[0];

tab = Safari.Tab({url:"http://www.dr.dk"});
window.tabs.push(tab);
window.currentTab = tab;

// https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/index.html
//# https://developer.apple.com/documentation
// https://developer.apple.com/documentation/JavaScriptCore
// https://mikebian.co/scripting-macos-with-javascript-automation/
