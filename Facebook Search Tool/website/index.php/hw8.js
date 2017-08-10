window.fbAsyncInit = function() {
    FB.init({
      appId      : '500139780161154',
      xfbml      : true,
      version    : 'v2.8'
    });
    FB.AppEvents.logPageView();
};

(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/en_US/sdk.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk')
 );

$(document).ready(function(){
    $('#searchBar').tooltip({
    		title:'Please type a keyword', 
			trigger:'manual', 
			placement: 'bottom'
		});
    $('#searchBar').on('input',function(){
	     	$("#searchBar").tooltip("hide");
	});
});

var myApp = angular.module("myApp",['ngAnimate']);
myApp.controller("myCtrl", ['$scope',function($scope) {
	$scope.current_tab = 'users';
	$scope.userdata = '';
	$scope.pagedata = '';
	$scope.eventdata = '';
	$scope.placedata = '';
	$scope.groupdata = '';
	$scope.favoritedata = [];
	$scope.favoriteIndex = localStorage.length;
	$scope.currentDetailID = null;
	$scope.currentDetailType = null;

	$scope.userIndex = 0;
	$scope.pageIndex = 0;
	$scope.eventIndex = 0;
	$scope.groupIndex = 0;
	$scope.placeIndex = 0 ;

	//$scope.keyword="";
	$scope.showProgressBar = false;
	$scope.showUserList = false;
	$scope.showPageList = false;
	$scope.showEventList = false;
	$scope.showGroupList = false;
	$scope.showPlaceList = false;
	$scope.showFavoriteList = false;
	$scope.showPrevious = false;
	$scope.showNext = false;
	$scope.showDetailPage = false;
	$scope.showList = false;
	$scope.detailProgressBar = false;
	$scope.showNoAlbums = false;
	$scope.showNoPosts = false;
	$scope.showAlbums = false;
	$scope.showPosts = false;
	$scope.showDetailButton = false;
	$scope.changeToDetail = false;

	$scope.latitude = null;
	$scope.longitude = null;
	//localStorage.clear();
	for(var key in localStorage){
		//console.log(key);
		//console.log('count');
		var localData = JSON.parse(localStorage.getItem(key));
		if(localData!=null && localData.index > $scope.favoriteIndex){
			$scope.favoriteIndex = localData.index + 1;
		}
	}
	console.log($scope.favoriteIndex);

	if (navigator.geolocation) {
    	navigator.geolocation.getCurrentPosition(function(position){
      		$scope.$apply(function(){
        		$scope.latitude = position.coords.latitude;
        		$scope.longitude = position.coords.longitude;
				//console.log($scope.latitude);
      		});
    	});
  	}

  	$scope.getLocalTime = function(UTCtime){
  		return moment.utc(UTCtime).local().format("YYYY-MM-DD HH:mm:ss");
  	}

  	$scope.addFavorite = function(id,picture,name,type){
  		//console.log(id+'\n'+picture+'\n'+name+'\n'+type);
  		if (typeof(Storage) !== "undefined") {
  			if(id&&picture&&name&&type){
  				var favorite_data = {
  					id : id,
  					picture: picture,
  					name: name,
  					type: type,
  					index: $scope.favoriteIndex
  				};
  				if(type=='favorites'){
  					favorite_data['type'] = $scope.currentDetailType;
  				}
  				localStorage.setItem(id, JSON.stringify(favorite_data));
  				$scope.favoriteIndex = $scope.favoriteIndex + 1;

  			}
  			//console.log(localStorage);
  			//console.log(localStorage[id]);
  			//console.log(JSON.parse(localStorage.getItem(id)));
		} else {
			window.alert('Sorry, no Web Storage support!');
		}
  	}
  	$scope.removeFavorite = function(id){
  		//console.log(id+'\n'+picture+'\n'+name+'\n'+type);
  		if (typeof(Storage) !== "undefined") {
  			localStorage.removeItem(id);
  			//console.log(localStorage);
		} else {
			window.alert('Sorry, no Web Storage support!');
		}
  	}
  	$scope.removeFavoriteAndUpdate = function(id){
  		//console.log(id+'\n'+picture+'\n'+name+'\n'+type);
  		if (typeof(Storage) !== "undefined") {
  			localStorage.removeItem(id);
  			$scope.changeTab();
  			//console.log(localStorage);
		} else {
			window.alert('Sorry, no Web Storage support!');
		}
  	}
  	$scope.isFavorite = function(id){
  		//return (id in localStorage);
  		return (localStorage[id]);
  		//return true;
  	}
  	$scope.setFavorite = function(id,picture,name,type){
  		if(id in localStorage){
  			$scope.removeFavorite(id);
  		}else{
  			$scope.addFavorite(id,picture,name,type);
  		}
  	}
  	$scope.getColor = function(id){
  		if(id in localStorage){
  			var obj = {'color':'gold'};
  			return obj;
  		}else{
  			var obj={'color':'black'};
  			return obj;
  		}
  	}
  	$scope.getClass = function(id){
  		if(id in localStorage){
  			return "glyphicon-star";
  		}else{
  			return "glyphicon-star-empty";
  		}
  	}

  	$scope.FBPost = function(){
  		//$scope.show=window.location.href;

  		FB.ui({
  			app_id : '500139780161154',
  			method: 'feed',
  			link: window.location.href,
  			picture: $scope.detaildata.picture.url,
  			name: $scope.detaildata.name,
  			caption: 'FB SEARCH FROM USC CSCI571',
  			}, function(response){
  				if(response && !response.error_message){
  					window.alert('Posted Successfully');
  				}else{
  					window.alert('Not Posted');
  				}

  			}
  		);
  	}
	$scope.clickFunc = function(tab){
		$scope.current_tab = tab;
		$scope.changeTab();
	}
	$scope.clickClear = function(){
		$scope.keyword = "";
		$scope.userdata = '';
		$scope.pagedata = '';
		$scope.eventdata = '';
		$scope.placedata = '';
		$scope.groupdata = '';
		$scope.currentDetailID = null;
		$scope.currentDetailType = null;

		$scope.showProgressBar = false;
		$scope.showUserList = false;
		$scope.showPageList = false;
		$scope.showEventList = false;
		$scope.showGroupList = false;
		$scope.showPlaceList = false;
		$scope.showFavoriteList = false;
		$scope.showPrevious = false;
		$scope.showNext = false;
		$scope.showDetailPage = false;
		$scope.showList = false;
		$scope.detailProgressBar = false;
		$scope.showNoAlbums = false;
		$scope.showNoPosts = false;
		$scope.showAlbums = false;
		$scope.showPosts = false;
		$scope.changeToDetail = false;
		$scope.favoritedata = [];
		$scope.changeTab();
	}
	$scope.showDetail = function(detail_id){
		$scope.showDetailPage = true;
		$scope.showList = false;
		$scope.detailProgressBar = true;
		$scope.showNoAlbums = false;
		$scope.showNoPosts = false;
		$scope.showAlbums = false;
		$scope.showPosts = false;
		$scope.currentDetailID = detail_id;
		$scope.showDetailButton = false;
		$scope.changeToDetail = true;
		//console.log($scope.showDetailPage + " " +$scope.changeToDetail);

		var params = {
			'detail_id' : detail_id,
			'detail_type' : $scope.current_tab
		};

		if($scope.current_tab=='favorites' && localStorage.getItem(detail_id)){
			params['detail_type']= JSON.parse(localStorage.getItem(detail_id)).type;
			$scope.currentDetailType = JSON.parse(localStorage.getItem(detail_id)).type;
			//console.log(params['detail_type']);
		}else if($scope.current_tab=='favorites'){
			params['detail_type'] = $scope.currentDetailType;
		}

		$.ajax({
			url: 'search.php',//'http://cs-server.usc.edu:20348/hw8/search.php',
			data: params,
			type: 'GET',
			success: function(response,status, xhr){
				//$scope.show = response;
				//$scope.data = JSON.parse(response);
				$scope.detaildata = JSON.parse(response).detailData;
				//$scope.show = $scope.detaildata.albums;
				//$scope.changeTab();
				if($scope.detaildata.albums){
					$scope.showNoAlbums = false;
					$scope.showAlbums = true;
				}else{
					$scope.showNoAlbums = true;
					$scope.showAlbums = false;
				}
				if($scope.detaildata.posts){
					$scope.showNoPosts = false;
					$scope.showPosts = true;
				}else{
					$scope.showNoPosts = true;
					$scope.showPosts = false;
				}
	
	
				
				$scope.showDetailButton = true;
				$scope.detailProgressBar = false;
				$scope.$apply();
			},
			error: function(xhr, status, error){
				$scope.show = 'error';
				$scope.detailProgressBar = false;
				$scope.$apply();
			},
        	async:true
		});

		

	}
	$scope.hideDetail = function(){
		$scope.showDetailPage = false;
		$scope.showList = true;
		$scope.changeToDetail = false;
		//console.log($scope.showDetailPage + " " +$scope.changeToDetail);
		$scope.changeTab();
	}
	$scope.Search = function(){
		//$scope.click = 'click';
		if($scope.keyword!=null && $scope.keyword!=""){
			if($scope.showDetailPage==true) {
				$scope.changeToDetail = false;
				$scope.showDetailPage = false;
			}
			//console.log($scope.showDetailPage + " " +$scope.changeToDetail);
			//$scope.changeToDetail = false;
			$scope.userIndex = 0;
			$scope.pageIndex = 0;
			$scope.eventIndex = 0;
			$scope.placeIndex = 0;
			$scope.groupIndex = 0;

			$scope.showUserList = false;
			$scope.showPageList = false;
			$scope.showEventList = false;
			$scope.showGroupList = false;
			$scope.showPlaceList = false;
			//$scope.showFavoriteList = false;
			$scope.showProgressBar = true;
			$scope.showList = true;
			$scope.showDetailPage = false;
			$scope.showPrevious = false;
			$scope.showNext = false;
			//console.log($scope.latitude);
			var params = {
				'keyword' : $scope.keyword,
				//'type' : $scope.current_tab,
				'latitude' : $scope.latitude,
				'longitude' : $scope.longitude
			};

			$.ajax({
				url: 'search.php',
				data: params,
				type: 'GET',
				success: function(response,status, xhr){
					//$scope.show = response;
					$scope.data = JSON.parse(response);
					$scope.userdata = $scope.data.userData;
					$scope.pagedata = $scope.data.pageData;
					$scope.eventdata = $scope.data.eventData;
					$scope.placedata = $scope.data.placeData;
					$scope.groupdata = $scope.data.groupData;
					//$scope.show = response;
					$scope.changeTab();

					$scope.showProgressBar = false;
					$scope.$apply();
				},
				error: function(xhr, status, error){
					$scope.show = 'errrrrror';
					$scope.showProgressBar = false;
					$scope.$apply();
				},
     		 	async:true
			});

		}else{
			$scope.showProgressBar = false;
			$("#searchBar").tooltip("show");
		}

	}

	$scope.SearchWithOffset = function(){
		//$scope.click = 'click';

		$scope.showProgressBar = true;
		$scope.showUserList = false;
		$scope.showPageList = false;
		$scope.showEventList = false;
		$scope.showPlaceList = false;
		$scope.showFavoriteList = false;
		$scope.showGroupList = false;
		$scope.showList = true;
		$scope.showDetailPage = false;
		$scope.showPrevious = false;
		$scope.showNext = false;

		var params = {
			'keyword' : $scope.keyword,
			'type' : $scope.current_tab,
			'latitude' : $scope.latitude,
			'longitude' : $scope.longitude
		};
		if($scope.current_tab=='users') {
			params['userOffset'] = $scope.userIndex;
		}
		else if($scope.current_tab=='pages') {
			params['pageOffset'] = $scope.pageIndex;
		}
		else if($scope.current_tab=='events') {
			params['eventOffset'] = $scope.eventIndex;
		}
		else if($scope.current_tab=='places') {
			//$scope.show = 'change place' + $scope.placeIndex;
			params['placeOffset'] = $scope.placeIndex;
		}
		else if($scope.current_tab=='groups') {
			params['groupOffset'] = $scope.groupIndex;
		}

		$.ajax({
			url: 'search.php',//'http://cs-server.usc.edu:20348/hw8/search.php',
			data: params,
			type: 'GET',
			success: function(response,status, xhr){
				//$scope.show = response;
				$scope.data = JSON.parse(response);
				if($scope.data.userData){
					$scope.userdata = $scope.data.userData;
				}
				else if($scope.data.pageData){
					$scope.pagedata = $scope.data.pageData;
				}
				else if($scope.data.eventData){
					$scope.eventdata = $scope.data.eventData;
				}
				else if($scope.data.placeData){
					$scope.placedata = $scope.data.placeData;
					//$scope.show = $scope.placedata;
				}
				else if($scope.data.groupData){
					$scope.groupdata = $scope.data.groupData;
				}
				//$scope.show = response;
				$scope.changeTab();

				$scope.showProgressBar = false;
				$scope.$apply();
			},
			error: function(xhr, status, error){
				$scope.show = 'error';
				$scope.showProgressBar = false;
				$scope.$apply();
			},
        	async:true
		});

	}
	$scope.compare = function(a,b){
		if(a.index < b.index)
			return -1;
		if(a.index > b.index)
			return 1;
		return 0;
	}

	$scope.changeTab = function(){
		if($scope.showDetailPage==true) {
			$scope.changeToDetail = false;
			$scope.showDetailPage = false;
		}
		//console.log($scope.showDetailPage + " " +$scope.changeToDetail);
		$scope.showUserList = false;
		$scope.showPageList = false;
		$scope.showEventList = false;
		$scope.showPlaceList = false;
		$scope.showFavoriteList = false;
		$scope.showGroupList = false;
		$scope.showDetailPage = false;
		$scope.showList = true;
		$scope.showPrevious = false;
		$scope.showNext = false;

		if($scope.current_tab=='users' && $scope.userdata) {
			$scope.showUserList = true; //typeof(Storage) !== "undefined"
			if($scope.userdata.paging){
				if($scope.userdata.paging.previous){
					$scope.showPrevious = true;
				}else{
					$scope.showPrevious = false;
				}
				if($scope.userdata.paging.next){
					$scope.showNext = true;
				}else{
					$scope.showNext = false;
				}
			}else{
				$scope.showPrevious = false;
				$scope.showNext = false;
			}
		}
		else if($scope.current_tab=='pages' && $scope.pagedata) {
			$scope.showPageList = true;
			if($scope.pagedata.paging){
				if($scope.pagedata.paging.previous){
					$scope.showPrevious = true;
				}else{
					$scope.showPrevious = false;
				}
				if($scope.pagedata.paging.next){
					$scope.showNext = true;
				}else{
					$scope.showNext = false;
				}
			}else{
				$scope.showPrevious = false;
				$scope.showNext = false;
			}
		}
		else if($scope.current_tab=='events' && $scope.eventdata) {
			$scope.showEventList = true;
			if($scope.eventdata.paging){
				if($scope.eventdata.paging.previous){
					$scope.showPrevious = true;
				}else{
					$scope.showPrevious = false;
				}
				if($scope.eventdata.paging.next){
					$scope.showNext = true;
				}else{
					$scope.showNext = false;
				}
			}else{
				$scope.showPrevious = false;
				$scope.showNext = false;
			}
		}
		else if($scope.current_tab=='places' && $scope.placedata) {
			$scope.showPlaceList = true;
			if($scope.placedata.paging){
				if($scope.placedata.paging.previous){
					$scope.showPrevious = true;
				}else{
					$scope.showPrevious = false;
				}
				if($scope.placedata.paging.next){
					$scope.showNext = true;
				}else{
					$scope.showNext = false;
				}
			}else{
				$scope.showPrevious = false;
				$scope.showNext = false;
			}
		}
		else if($scope.current_tab=='groups' && $scope.groupdata) {
			$scope.showGroupList = true;
			if($scope.groupdata.paging){
				if($scope.groupdata.paging.previous){
					$scope.showPrevious = true;
				}else{
					$scope.showPrevious = false;
				}
				if($scope.groupdata.paging.next){
					$scope.showNext = true;
				}else{
					$scope.showNext = false;
				}
			}else{
				$scope.showPrevious = false;
				$scope.showNext = false;
			}
		}
		else if($scope.current_tab=='favorites'){
			$scope.showFavoriteList = true;
			$scope.favoritedata = [];
			//console.log(localStorage);
			for(var key in localStorage){
				//console.log(key);
				//console.log('count');
				var localData = JSON.parse(localStorage.getItem(key));
				if(localData!=null) $scope.favoritedata.push(localData);
			}
			$scope.favoritedata.sort($scope.compare);
			//console.log($scope.favoritedata);
		}
	}
	$scope.clickPrev = function(){
		if($scope.current_tab=='users') {
			$scope.userIndex -= 25;
		}
		else if($scope.current_tab=='pages') {
			$scope.pageIndex -= 25;
		}
		else if($scope.current_tab=='events') {
			$scope.eventIndex -= 25;
		}
		else if($scope.current_tab=='places') {
			$scope.placeIndex -= 25;
		}
		else if($scope.current_tab=='groups') {
			$scope.groupIndex -= 25;
		}
		$scope.SearchWithOffset();
	}
	$scope.clickNext = function(){
		if($scope.current_tab=='users') {
			$scope.userIndex += 25;
		}
		else if($scope.current_tab=='pages') {
			$scope.pageIndex += 25;
		}
		else if($scope.current_tab=='events') {
			$scope.eventIndex += 25;
		}
		else if($scope.current_tab=='places') {
			$scope.placeIndex += 25;
		}
		else if($scope.current_tab=='groups') {
			$scope.groupIndex += 25;
		}
		$scope.SearchWithOffset();
	}
}]);