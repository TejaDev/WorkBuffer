//in Included Scriots add utilities.js and coach_ng_controls.css
//In AMD Dependencies add com.ibm.bpm.coach.controls/utilities

//Load Script
var baseTextDirection = this.context.options._metadata.baseTextDirection && 
                        this.context.options._metadata.baseTextDirection.get("value") ? this.context.options._metadata.baseTextDirection.get("value").utilities.BiDi.BASE_TEXT_DIRECTION._default;
var generalPrefTextDirection = this.context.bpm.system.baseTextDirection;

if(this.context.binding != undefined && this.context.binding.get("value")!=undefined){
    var span = this.context.element.getElementsByTagName("span")[0];
    span.innerHTML = "";
    for(var i = 0; i<this.context.binding.get("value").items.length;i++){
        span.innerHTML += this.context.binding.get("value").items[i].name + "</br><br>";
    }
    utilities.BiDi.applyTextDir(span,span.innerHTML,baseTextDirection,generalPrefTextDirection);
}

if(this.context.options._metadata.label && this.context.options._metadata.label.get("value")!=""){
    var label = this.context.element.querySelector(".outputTextLabel > label");
    label.innerHTML = this.context.htmlEscape(this.context.options._metadata.label.get("value"));
    utilities.BiDi.applyTextDir(label,label.innerHTML,baseTextDirection,generalPrefTextDirection);
}

if(this.context.options._metadata.helpText && this.context.options._metadata.helpText.get("value")!=""){
    var label = this.context.element.querySelector(".outputTextLabel>label");
    label.title = this.context.options._metadata.helpText.get("value");
}

//view Script
var labelDiv = this.context.element.querySelector(".outputTextLabel");
if(this.context.options._metadata.label == undefined ||
    this.context.options._metadata.label.get("value")=="" ||
    (this.context.options._metadata.labelVisibility != undefined &&
        this.context.options._metadata.labelVisibility.get("value") == "HIDE" ||
        this.context.options._metadata.labelVisibility.get("value") == "NONE")){
            this.context.setDisplay(false,labelDiv);
        }else{
            this.context.setDisplay(true,labelDiv);
        }
var visibility = utilities.handleVisibility(this.context);


//change Script

if(event.type == "config"){
    this.context.log("change",["config change:",event.property,event.newVal]);
    if(event.property == "_metadata.label"){
        var labelElement = this.context.element.querySelector(".outputTextLabel>label");
        labelElement.innerHTML = this.context.htmlEscape(event.newVal);
        var baseTextDirection = this.context.options._metadata.baseTextDirection && this.context.options._metadata.baseTextDirection.get("value") ? this.context.options._metadata.baseTextDirection.get("value"):utilities.BiDi.BASE_TEXT_DIRECTION._default;
        var generalPrefTextDirection = this.context.bpm.system.baseTextDirection;
        utilities.BiDi.applyTextDir(labelElement,labelElement.innerHTML,baseTextDirection,generalPrefTextDirection);
    }else if(event.property == "_metadata.helpText"){
        var label = this.context.element.querySelector(".outputTextLabel > label");
        label.title = event.newVal;
    }
}else{
    this.context.log("change", ["change:", event.property,event.newVal]);
    var newData;
    if(event.newVal != undefined){
        newData = event.newVal;
    }else{
        newData = "";
    }
    if(this.context.binding != undefined && this.context.binding.get("value") != undefined){
        var span = this.context.element.getElementsByTagName("span")[0];
        span.innerHTML = "";
        for(var i=0; i<this.context.binding.get("value").items.length;i++){
            span.innerHTML += this.context.binding.get("value").items[i].name + "</br><br>";
        }
        utilities.BiDi.applyTextDir(span,span.innerHTML,baseTextDirection,generalPrefTextDirection);
    }
    var baseTextDirection = this.context.options._metadata.baseTextDirection && this.context.options._metadata.baseTextDirection.get("value") ? this.context.options._metadata.baseTextDirection.get("value") : utilities.BiDi.BASE_TEXT_DIRECTION._default;
    var generalPrefTextDirection = this.context.bpm.system.baseTextDirection;
    utilities.BiDi.applyTextDir(span,span.innerHTML,baseTextDirection,generalPrefTextDirection);
}

this.view();

//add div tag to the layout session
<div class="outputTextLabel">
    <label class="text controlLabel"></label>
</div>
<span class="text"></span>