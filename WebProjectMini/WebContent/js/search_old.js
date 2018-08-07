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
	    var str = JSON.stringify(response.result);
	   // $('#search-container').html('<pre id="jsonValue">' + str + '</pre>');
		var jsonStr = str;
		var jsonObj = JSON.parse(jsonStr);
		
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
	
		for(var i = 0 ; i < jsonObj['items'].length; i++)
		{
			jsonVId = jsonObj['items'][i].id;
			jsonMvideoId = jsonVId.videoId;
			
			jsonVSnippet = jsonObj['items'][i].snippet;
			jsonMpublishedAt = jsonVSnippet.publishedAt;
			jsonMtitle = jsonVSnippet.title;
			jsonMthumbnails = jsonVSnippet.thumbnails;
			jsonMchannelTitle = jsonVSnippet.channelTitle;
			
			/* 소형사이즈
			jsonSDefault = jsonVSnippet.thumbnails.default;
			jsonDurl = jsonVSnippet.thumbnails.default.url;
			jsonDwidth = jsonVSnippet.thumbnails.default.width;
			jsonDheight = jsonVSnippet.thumbnails.default.height;
			*/
			
			jsonSdefault = jsonVSnippet.thumbnails.medium;
			jsonDurl = jsonVSnippet.thumbnails.medium.url;
			jsonDwidth = jsonVSnippet.thumbnails.medium.width;
			jsonDheight = jsonVSnippet.thumbnails.medium.height;
			
			/* 대형사이즈
			jsonHigh = jsonVSnippet.thumbnails.high;
			jsonHurl = jsonVSnippet.thumbnails.high.url;
			jsonHwidth = jsonVSnippet.thumbnails.high.width;
			jsonHheight = jsonVSnippet.thumbnails.high.height;
			*/
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
				if(totalByte <= 36) {
					len = j+1; // 입력된 데이터의 자리수 기억해주기
				}
			}
			if(totalByte>36) {
				fixedtitle = strValue.substr(0, len)+"..."; // 아까 기억한 자리수까지만큼 잘라서 넣어주기
			}else{
				fixedtitle=jsonMtitle;
			}
			fixeddate=jsonMpublishedAt.substr(0,10);
			
			var link="<a class=btn onclick=openPopup('"+jsonMvideoId+"');><img class=img-thumbnail src="+jsonDurl+"><br>";
			link=link+"<h4 align=left>"+fixedtitle+"</h4><h6 class='text-muted'><div style='float:left;'>"+jsonMchannelTitle+"</div><div style='float:right;'>"+fixeddate;
			link=link+"</div></h6></a>";
			document.getElementById("link"+(i+1)).innerHTML=link;
		}
	  });
	  
	}
	
	
	function openPopup(a){
		
		var popupX = (window.screen.width / 2) - (650 / 2);
		// 만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음
		var popupY= (window.screen.height /2) - (390 / 2);
		// 만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음
		
		window.open("result.jsp?videoId="+a, '', 'menubar=no, statusbar=no, height=390, width=650, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
	}