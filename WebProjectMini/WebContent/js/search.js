var sizeT='default';
var sizeS='default';
var sizeM='medium';
var sizeL='high';

var str="";
var jsonStr = "";
var jsonObj = "";

var jsonVId = ""; 			// items > id
var jsonMvideoId = ""; 		// items > id > videoId

var jsonVSnippet = ""; 		// items > snippet
var jsonMpublishedAt = ""; 	// items > snippet > publishedAt
var jsonMtitle = ""; 		// items > snippet > title
var jsonMthumbnails = ""; 	// items > snippet > thumbnails
var jsonMchannelTitle = "";	// items > snippet > channelTitle

var jsonSDefault = ""; 		// items > snippet > thumbnails > default

var jsonDurl = ""; 			// items > snippet > thumbnails > default > url
var jsonDwidth = ""; 		// items > snippet > thumbnails > default > width
var jsonDheight = ""; 		// items > snippet > thumbnails > default > height

var fixedtitle = "";
var fixeddate = "";
var phtml="";
var link=""
	
	function sizeThumnail(s) {

		if(s=='s'){
			sizeT=sizeS;
			init();
		}else if(s=='m') {
			sizeT='medium';
			init();
		}else if(s=='h') {
			sizeT='high';
			init();
		}else{
			sizeT=sizeS;
			init();
		}
	}
// Search for a specified string.
	function search() {
	  var q = $('#query').val();
	  var request = gapi.client.youtube.search.list({
	    q: q,
	    part: 'snippet',
	    type: 'video',
	    maxResults: 12
	  });
	
	  request.execute(function(response) {
	    str = JSON.stringify(response.result);
	   // $('#search-container').html('<pre id="jsonValue">' + str + '</pre>');
		jsonStr = str;
		jsonObj = JSON.parse(jsonStr);
		
		init();
	  })
	}
	
	
	function init() {
		phtml="";
		for(var i = 0 ; i < jsonObj['items'].length; i++)
		{
			jsonVId = jsonObj['items'][i].id;
			jsonMvideoId = jsonVId.videoId;
			
			jsonVSnippet = jsonObj['items'][i].snippet;
			jsonMpublishedAt = jsonVSnippet.publishedAt;
			jsonMtitle = jsonVSnippet.title;
			jsonMthumbnails = jsonVSnippet.thumbnails;
			jsonMchannelTitle = jsonVSnippet.channelTitle;
			
			if(sizeT==sizeS) {
				jsonSDefault = jsonVSnippet.thumbnails.default;
				jsonDurl = jsonVSnippet.thumbnails.default.url;
				jsonDwidth = jsonVSnippet.thumbnails.default.width;
				jsonDheight = jsonVSnippet.thumbnails.default.height;
			} else if(sizeT==sizeM) {
				jsonSdefault = jsonVSnippet.thumbnails.medium;
				jsonDurl = jsonVSnippet.thumbnails.medium.url;
				jsonDwidth = jsonVSnippet.thumbnails.medium.width;
				jsonDheight = jsonVSnippet.thumbnails.medium.height;
			} else {
				jsonSDefault = jsonVSnippet.thumbnails.high;
				jsonDurl = jsonVSnippet.thumbnails.high.url;
				jsonDwidth = jsonVSnippet.thumbnails.high.width;
				jsonDheight = jsonVSnippet.thumbnails.high.height;
			}
			
			//alert((i+1) + "번째" + "\n videoId:" + jsonMvideoId + "\n publishedAt:" + jsonMpublishedAt + "\n title:" + jsonMtitle + "\n defaultUrl:" + jsonDurl + "\n defaultWidth:" + jsonDwidth + "\n defaultHeight:" + jsonDheight);
			
			var strValue = jsonMtitle;
			var strLen = strValue.length;
			var totalByte = 0;
			var len = 0;
			var oneChar = "";
			var str2 = "";
			
			for(var j = 0; j < strLen; j++) {
				oneChar = strValue.charAt(j);
				if(escape(oneChar).length > 4) { // 길이가 4초과=유니코드/한글이면
					totalByte +=2; // 2바이트로 넣어주고
				}else {
					totalByte++; // 아니면 1바이트로 처리
				}
				if(sizeT==sizeS) {
					if(totalByte <= 50) {
						len = j+1; // 입력된 데이터의 자리수 기억해주기
					}
				}else if(sizeT==sizeM) {
					if(totalByte <= 30) {
						len = j+1; // 입력된 데이터의 자리수 기억해주기
					}
				}else {
					if(totalByte <= 40) {
						len = j+1; // 입력된 데이터의 자리수 기억해주기
					}
				}
		
			}
			
			fixeddate=jsonMpublishedAt.substr(0,10);
			
			if(sizeT==sizeS) {
				if(totalByte>50) {
					fixedtitle = strValue.substr(0, len)+"..."; // 아까 기억한 자리수까지만큼 잘라서 넣어주기
				}else{
					fixedtitle=jsonMtitle;
				}
				link='<div class="row" onclick=openPopup("'+jsonMvideoId+'");><div class="col-xs-2"><img class=img-thumbnail src='+jsonDurl+' width="'+jsonDwidth+'" height="'+jsonDheight+'"></div>';
				link=link+'<div style="height:92.5px;" class="col-xs-7"><h4 style="margin-top:33px;margin-bottom:33px;" align=left>'+fixedtitle+'</h4></div><div style="height:92.5px;" class="col-xs-2" ><h6 class="text-muted " style="margin-top:43px"><div style="float:left;">'+jsonMchannelTitle;
				link=link+'</div></div><div style="height:92.5px;" class="col-xs-1"><div style="float:left; margin-top:40px">'+fixeddate+'</div></div></h6></div>';
			}else if(sizeT==sizeM){
				if(totalByte>30) {
					fixedtitle = strValue.substr(0, len)+"..."; // 아까 기억한 자리수까지만큼 잘라서 넣어주기
				}else{
					fixedtitle=jsonMtitle;
				}
				link='<a class=btn onclick=openPopup("'+jsonMvideoId+'");><img class=img-thumbnail src='+jsonDurl+' width="'+jsonDwidth+'" height="'+jsonDheight+'">';
				link=link+'<h4 align=left>'+fixedtitle+'</h4><h6 class="text-muted"><div style="float:left;">'+jsonMchannelTitle;
				link=link+'</div><div style="float:right;">'+fixeddate+'</div></h6></a>';
			}else {
				if(totalByte>40) {
					fixedtitle = strValue.substr(0, len)+"..."; // 아까 기억한 자리수까지만큼 잘라서 넣어주기
				}else{
					fixedtitle=jsonMtitle;
				}
				link='<a class=btn onclick=openPopup("'+jsonMvideoId+'");><img class=img-thumbnail src='+jsonDurl+' width="'+jsonDwidth+'" height="'+jsonDheight+'">';
				link=link+'<h4 align=left>'+fixedtitle+'</h4><h6 class="text-muted"><div style="float:left;">'+jsonMchannelTitle;
				link=link+'</div><div style="float:right;">'+fixeddate+'</div></h6></a>';
			}
			
			divinit(link,i);
		}
	}
	function divinit(link,i) {
		if(sizeT==sizeS) {
			phtml=phtml+link;
		}else if(sizeT==sizeM) {
			if(i%4==0) {
				phtml=phtml+'<div class="row">';
				phtml=phtml+'<div class="col-xs-3" style=" padding-left: 0px;padding-right: 0px;">';
				phtml=phtml+link;
				phtml=phtml+'</div>';
			}else if(i%4==3) {
				phtml=phtml+'<div class="col-xs-3" style=" padding-left: 0px;padding-right: 0px;">';
				phtml=phtml+link;
				phtml=phtml+'</div>';
				phtml=phtml+'</div>';
			}else {
				phtml=phtml+'<div class="col-xs-3" style=" padding-left: 0px;padding-right: 0px;">';
				phtml=phtml+link;
				phtml=phtml+'</div>';
			}
		}else {
			if(i%3==0) {
				phtml=phtml+'<div class="row">';
				phtml=phtml+'<div class="col-xs-4" style=" padding-left: 0px;padding-right: 0px;">';
				phtml=phtml+link;
				phtml=phtml+'</div>';
			}else if(i%3==2) {
				phtml=phtml+'<div class="col-xs-4" style=" padding-left: 0px;padding-right: 0px;">';
				phtml=phtml+link;
				phtml=phtml+'</div>';
				phtml=phtml+'</div>';
			}else {
				phtml=phtml+'<div class="col-xs-4" style=" padding-left: 0px;padding-right: 0px;">';
				phtml=phtml+link;
				phtml=phtml+'</div>';
			}
		}
		
		document.getElementById("place").innerHTML=phtml;
	}

	function openPopup(a){
		
		var popupX = (window.screen.width / 2) - (650 / 2);
		// 만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음
		var popupY= (window.screen.height /2) - (390 / 2);
		// 만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음
		
		window.open("result.jsp?videoId="+a, '', 'menubar=no, statusbar=no, height=390, width=650, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
	}