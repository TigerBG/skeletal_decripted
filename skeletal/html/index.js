window.onload = function () {
var Visible = false;

$(function () {
    $("#human-body").fadeOut(1);
	window.addEventListener('message', function (event) {
        
		switch (event.data.action) {
            case 'showUI':
                if (Visible == false){
                    $("#human-body").fadeIn(1000);
                }
            break;
            case 'hideUI':
                if (Visible == false){
                    $("#human-body").fadeOut(1000);
                }
            break;

			case 'updatePlayerBones':
			changecolor(event.data.bone, event.data.bonehealth)
            break;
            case 'fullhealth':
            changecolor('head', 100);
            changecolor('left-shoulder', 100);
            changecolor('right-shoulder', 100);
            changecolor('left-arm', 100);
            changecolor('right-arm', 100);
            changecolor('left-hand', 100);
            changecolor('right-hand', 100);
            changecolor('chest', 100);
            changecolor('stomach', 100);
            changecolor('left-leg', 100);
            changecolor('right-leg', 100);
            changecolor('left-foot', 100);
            changecolor('right-foot', 100);
            break;
            case 'showhide':
            if (Visible) { 
                $("#human-body").css('display', 'none');
                Visible = false;
            } else {
                $("#human-body").css('display', 'block');
                Visible = true;
            }
			break;
        }
        
	}, false);
});

function changecolor(boneindex, bonehealth) {
    if(bonehealth >= 98){$("#"+boneindex).css('fill', '#5ECC1F');}
    else if(bonehealth >= 93){$("#"+boneindex).css('fill', '#90CC1F');}
    else if(bonehealth >= 87){$("#"+boneindex).css('fill', '#A5CC1F');}
    else if(bonehealth >= 82){$("#"+boneindex).css('fill', '#B2CC1F');}
    else if(bonehealth >= 78){$("#"+boneindex).css('fill', '#BCCC1F');}
    else if(bonehealth >= 71){$("#"+boneindex).css('fill', '#C9CC1F');}
    else if(bonehealth >= 67){$("#"+boneindex).css('fill', '#CCC71F');}
    else if(bonehealth >= 60){$("#"+boneindex).css('fill', '#CCAF1F');}
    else if(bonehealth >= 55){$("#"+boneindex).css('fill', '#CC9F1F');}
    else if(bonehealth >= 50){$("#"+boneindex).css('fill', '#CC8D1F');}
    else if(bonehealth >= 45){$("#"+boneindex).css('fill', '#CC7B1F');}
    else if(bonehealth >= 40){$("#"+boneindex).css('fill', '#CC681F');}
    else if(bonehealth >= 35){$("#"+boneindex).css('fill', '#CC631F');}
    else if(bonehealth >= 30){$("#"+boneindex).css('fill', '#CC591F');}
    else if(bonehealth >= 25){$("#"+boneindex).css('fill', '#CC511F');}
    else if(bonehealth >= 20){$("#"+boneindex).css('fill', '#CC4C1F');}
    else if(bonehealth >= 15){$("#"+boneindex).css('fill', '#CC461F');}
    else if(bonehealth >= 10){$("#"+boneindex).css('fill', '#CC341F');}
    else if(bonehealth >= 5) {$("#"+boneindex).css('fill', '#CC2F1F');}
    else if(bonehealth >= 0) {$("#"+boneindex).css('fill', '#CC1F1F');}
    else                     {$("#"+boneindex).css('fill', '#CC1F1F');}

};
//#ff7d16


}