(function(distmap){
    DistAlphaWidgetHelper = function(div){
        div.innerHTML = '';
    
        var sliderDiv = document.createElement('DIV');
        sliderDiv.style.width = '80%';
        sliderDiv.style.height = '5px';
        sliderDiv.style.backgroundColor = 'blue';
        sliderDiv.style.position = 'absolute';
        sliderDiv.style.top = '20px';
        div.appendChild(sliderDiv);
        
        var bollDiv = document.createElement('DIV');
        sliderDiv.style.width = '50px';
        sliderDiv.style.height = '50px';
        sliderDiv.style.background = 'url("images/boll_48.png" no-repeat)';
        sliderDiv.style.position = 'absolute';
        sliderDiv.style.top = '2px';
        div.appendChild(sliderDiv);
        
        $(bollDiv).bind('mousemove touchmove',function(){
        
        
        });
        
        
        this.setTargetLayer = function(){
        
        
        };
        
    }

})(dist.map);