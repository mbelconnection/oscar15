dojo.require("dojo.widget.validate");
dojo.provide("dojo.widget.validate.AlphaTextBox");

/*
 	  ****** AlphaTextBox *

 	  A subclass of ValidationTextbox.
 	  Over-rides isValid to test if input is alpha characters only, no numbers allowed.
*/
dojo.widget.validate.AlphaTextBox = function(node) {}

dojo.inherits(dojo.widget.validate.ValidationTextBox);

dojo.lang.extend(dojo.widget.validate.ValidationTextBox, {
// new subclass properties
    widgetType: "AlphaTextBox",

    isValid: function() {
        return dojo.validate.us.isText(this.textbox.value);
    }
});

dojo.widget.tags.addParseTreeHandler("dojo:AlphaTextBox");