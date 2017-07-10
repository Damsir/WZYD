/**
 *
 * HTML5 Color Picker
 *
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Copyright 2012, Script Tutorials
 * http://www.script-tutorials.com/
 */

$(function() {
    var bCanPreview = true; // can preview

    // create canvas and context objects
    var canvas = document.getElementById('picker2');
    var ctx = canvas.getContext('2d');

    // drawing active image
    var image = new Image();
    image.onload = function() {
        ctx.drawImage(image, 0, 0, image.width, image.height); // draw the image on the canvas
    }

    // select desired colorwheel
    var imageSrc = 'images/colorwheel1.png';
    switch ($(canvas).attr('var')) {
        case '2':
            imageSrc = 'images/colorwheel2.png';
            break;
        case '3':
            imageSrc = 'images/colorwheel3.png';
            break;
        case '4':
            imageSrc = 'images/colorwheel4.png';
            break;
        case '5':
            imageSrc = 'images/colorwheel5.png';
            break;
    }
    image.src = imageSrc;

    $('#picker2').mousemove(function(e) { // mouse move handler
        if (bCanPreview) {
            // get coordinates of current position
            var canvasOffset = $(canvas).offset();
            var canvasX = Math.floor(e.pageX - canvasOffset.left);
            var canvasY = Math.floor(e.pageY - canvasOffset.top);

            // get current pixel
            var imageData = ctx.getImageData(canvasX, canvasY, 1, 1);
            var pixel = imageData.data;

            // update preview color
            var pixelColor = "rgb(" + pixel[0] + ", " + pixel[1] + ", " + pixel[2] + ")";
            $('.preview2').css('backgroundColor', pixelColor);

            // update controls
            $('#rVal2').val(pixel[0]);
            $('#gVal2').val(pixel[1]);
            $('#bVal2').val(pixel[2]);
            $('#rgbVal2').val(pixel[0] + ',' + pixel[1] + ',' + pixel[2]);

            var dColor = pixel[2] + 256 * pixel[1] + 65536 * pixel[0];
            var cv = '#' + ('0000' + dColor.toString(16)).substr(-6);
            $('#hexVal2').val(cv);

            var layerId = parseInt(document.getElementById('polygonSymbolContainer').getAttribute('layerId'));
            var featurelayer = dist.desktop.currentScreen.map.esrimap.getLayer('themeFeatureLayer' + layerId);
            var featurelayerHelper = new FeatureLayerHelper(featurelayer);
            featurelayerHelper.setSymbolColor(cv);
        }
    });
    $('#picker2').click(function(e) { // click event handler
        bCanPreview = !bCanPreview;
    });
    $('.preview2').click(function(e) { // preview click
        $('.colorpicker2').fadeToggle("slow", "linear");
    });
});