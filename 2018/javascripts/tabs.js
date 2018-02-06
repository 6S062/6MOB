function switchTab(tab) {
	var s = 'tab' + tab;

	// update displayed tabs
	var tabs = document.getElementsByClassName("tabcontent");
	for(var i = 0; i < tabs.length; i++) {
		if(tabs[i].className.indexOf(s) != -1) {
			tabs[i].style.display = "block";
		} else {
			tabs[i].style.display = "none";
		}
	}

	// and same for tab active
	tablinks = document.getElementsByClassName("tablinks");
	for(var i = 0; i < tablinks.length; i++) {
		tablinks[i].className = tablinks[i].className.replace(" active", "");
		if(tablinks[i].className.indexOf(s) != -1) {
			tablinks[i].className += " active";
		}
	}
}
