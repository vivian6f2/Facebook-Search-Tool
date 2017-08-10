<?php
	define('FACEBOOK_SDK_V4_SRC_DIR', __DIR__ . '/facebook-sdk-v5/');
	require_once __DIR__ . '/facebook-sdk-v5/autoload.php';
	date_default_timezone_set('America/Los_Angeles');
	$fb = new Facebook\Facebook([
	  'app_id' => '500139780161154',
	  'app_secret' => 'eb6801ecc8b999971cc6d71a7bc29485',
	  'default_graph_version' => 'v2.8',
	]);
	$fb->setDefaultAccessToken('EAAHG393vPoIBAKvq1NrbI9I8kvdjXSBRKZAfkHLSJCzx7kmrblLLShZADw5mcMAQSx263tZBJtmAxcWKrUAANrOOA6XOT0Ft9UZBRBOZCISwovU86Y6AapVHtOWMsxzvzrwL3utSGT2S4HIWhwbTt0wtoIi26PtAZD');
	//google api key AIzaSyCBCMD7FwN7AnTdFiGMuzxUgCHrzgVelHc
	/*
		get necessary data for searching
	*/
	$version = $_GET['version'];
	$q = $_GET['keyword'];
	$offset = $_GET['offset'];
	$type = $_GET['type'];

	$userOffset = $_GET['userOffset'];
	$pageOffset = $_GET['pageOffset'];
	$eventOffset = $_GET['eventOffset'];
	$placeOffset = $_GET['placeOffset'];
	$groupOffset = $_GET['groupOffset'];
	//$type = $_GET['type'];
	$latitude = $_GET['latitude'];
	$longitude = $_GET['longitude'];
	//detail
	$detail_id = $_GET['detail_id'];
	$detail_type = $_GET['detail_type'];
	//photo
	$photo_id = $_GET['photo_id'];

	/*
		start searching
	*/
	if(isset($version) && $version=='hw9'){
		if(isset($detail_id) && isset($detail_type)){
			if($detail_type!='event'){
				$response = $fb->get("/".$detail_id."?fields=id, name, picture.width(700).height(700), albums.limit(5){name, photos.limit(2){name, picture.width(700).height(700)}}, posts.limit(5)",$_SESSION);
				$data['detailData'] = $response->getGraphNode()->asArray();

				if(isset($data['detailData']['albums'])){
					foreach($data['detailData']['albums'] as &$album){
						if(isset($album['photos'])){
							foreach($album['photos'] as &$photo){
								// echo "old picture url ";
								// echo ($photo['picture']);
								// echo "<br>";
								$photoID = $photo['id'];
								$picurl = $fb->get("$photoID/picture?redirect=false");
								$picurl = $picurl->getGraphNode()->asArray();
								// echo "new picture url ";
								// echo ($picurl['url']);
								// echo "<br>";
								$photo['picture'] = $picurl['url'];
							}
						}
					}
				}
			}else{
				$response = $fb->get("/".$detail_id."?fields=id, name, picture.width(700).height(700)",$_SESSION);
				$data['detailData'] = $response->getGraphNode()->asArray();
				//$data['detailData']['id'] = $detail_id;
			}

			$data = json_encode($data);

		}else if(isset($q) && isset($type) && isset($offset)){
			if($type=='user'){

				$response = $fb->get("/search?q=$q&type=$type&fields=id,name,picture.width(700).height(700)&limit=10&offset=$offset",$_SESSION);
				$userdata = json_decode($response->getBody());
				$data['searchData'] = $userdata;
				$data = json_encode($data);

			}else if($type=='page'){

				$response = $fb->get("/search?q=$q&type=$type&fields=id,name,picture.width(700).height(700)&limit=10&offset=$offset",$_SESSION);
				$pagedata = json_decode($response->getBody());
				$data['searchData'] = $pagedata;
				$data = json_encode($data);

			}else if($type=='event'){

				$response = $fb->get("/search?q=$q&type=$type&fields=id,name,picture.width(700).height(700),place&limit=10&offset=$offset",$_SESSION);
				$eventdata = json_decode($response->getBody());
				$data['searchData'] = $eventdata;
				$data = json_encode($data);

			}else if($type=='place'){

				if($latitude!=null && $longitude!=null){
					$response = $fb->get("/search?q=$q&type=$type&fields=id,name,picture.width(700).height(700)&center=$latitude,$longitude&limit=10&offset=$offset",$_SESSION);
				}else{
					$response = $fb->get("/search?q=$q&type=$type&fields=id,name,picture.width(700).height(700)&limit=10&offset=$offset",$_SESSION);
				}
				$placedata = json_decode($response->getBody());
				$data['searchData'] = $placedata;
				$data = json_encode($data);

			}else if($type=='group'){
				
				$response = $fb->get("/search?q=$q&type=$type&fields=id,name,picture.width(700).height(700)&limit=10&offset=$offset",$_SESSION);
				$groupdata = json_decode($response->getBody());
				$data['searchData'] = $groupdata;
				$data = json_encode($data);
			}

		}
	}else{	
		if(isset($photo_id)){
			$response = $fb->get("{$photo_id}/picture?redirect=false");
			$response = $response->getGraphNode()->asArray();
			$data = $response['url'];

		}else if(isset($detail_id) && isset($detail_type)){
			if($detail_type!='events'){
				$response = $fb->get("/".$detail_id."?fields=id, name, picture.width(700).height(700), albums.limit(5){name, photos.limit(2){name, picture.width(700).height(700)}}, posts.limit(5)",$_SESSION);
				$data['detailData'] = $response->getGraphNode()->asArray();

				if(isset($data['detailData']['albums'])){
					foreach($data['detailData']['albums'] as &$album){
						if(isset($album['photos'])){
							foreach($album['photos'] as &$photo){
								// echo "old picture url ";
								// echo ($photo['picture']);
								// echo "<br>";
								$photoID = $photo['id'];
								$picurl = $fb->get("$photoID/picture?redirect=false");
								$picurl = $picurl->getGraphNode()->asArray();
								// echo "new picture url ";
								// echo ($picurl['url']);
								// echo "<br>";
								$photo['picture'] = $picurl['url'];
							}
						}
					}
				}
			}else{
				$response = $fb->get("/".$detail_id."?fields=id, name, picture.width(700).height(700)",$_SESSION);
				$data['detailData'] = $response->getGraphNode()->asArray();
				//$data['detailData']['id'] = $detail_id;
			}

			$data = json_encode($data);

		}else if(isset($userOffset)){
			//search type==user
			$response = $fb->get("/search?q=$q&type=user&fields=id,name,picture.width(700).height(700)&limit=25&offset=$userOffset",$_SESSION);
			$userdata = json_decode($response->getBody());
			$data['userData'] = $userdata;
			$data = json_encode($data);

		}else if(isset($pageOffset)){
			//search type==page
			$response = $fb->get("/search?q=$q&type=page&fields=id,name,picture.width(700).height(700)&limit=25&offset=$pageOffset",$_SESSION);
			$pagedata = json_decode($response->getBody());
			$data['pageData'] = $pagedata;
			$data = json_encode($data);

		}else if(isset($eventOffset)){
			//search type==event
			$response = $fb->get("/search?q=$q&type=event&fields=id,name,picture.width(700).height(700),place&limit=25&offset=$eventOffset",$_SESSION);
			$eventdata = json_decode($response->getBody());
			$data['eventData'] = $eventdata;
			$data = json_encode($data);

		}else if(isset($placeOffset)){
			//search type==place
			if($latitude!=null && $longitude!=null){
				$response = $fb->get("/search?q=$q&type=place&fields=id,name,picture.width(700).height(700)&center=$latitude,$longitude&limit=25&offset=$placeOffset",$_SESSION);
			}else{
				$response = $fb->get("/search?q=$q&type=place&fields=id,name,picture.width(700).height(700)&limit=25&offset=$placeOffset",$_SESSION);
			}
			$placedata = json_decode($response->getBody());
			$data['placeData'] = $placedata;
			$data = json_encode($data);

		}else if(isset($groupOffset)){
			//search type==group
			$response = $fb->get("/search?q=$q&type=group&fields=id,name,picture.width(700).height(700)&limit=25&offset=$groupOffset",$_SESSION);
			$groupdata = json_decode($response->getBody());
			$data['groupData'] = $groupdata;
			$data = json_encode($data);

		}else{
			//search type==user
			$response = $fb->get("/search?q=$q&type=user&fields=id,name,picture.width(700).height(700)",$_SESSION);
			$userdata = json_decode($response->getBody());
			//search type==page
			$response = $fb->get("/search?q=$q&type=page&fields=id,name,picture.width(700).height(700)",$_SESSION);
			$pagedata = json_decode($response->getBody());
			//search type==event
			$response = $fb->get("/search?q=$q&type=event&fields=id,name,picture.width(700).height(700),place",$_SESSION);
			$eventdata = json_decode($response->getBody());
			//search type==place
			if($latitude!=null && $longitude!=null){
				$response = $fb->get("/search?q=$q&type=place&fields=id,name,picture.width(700).height(700)&center=$latitude,$longitude",$_SESSION); 
			}else{
				$response = $fb->get("/search?q=$q&type=place&fields=id,name,picture.width(700).height(700)",$_SESSION);
			}
			$placedata = json_decode($response->getBody());
			//search type==group
			$response = $fb->get("/search?q=$q&type=group&fields=id,name,picture.width(700).height(700)",$_SESSION);
			$groupdata = json_decode($response->getBody());

			$data['userData'] = $userdata;
			$data['pageData'] = $pagedata;
			$data['eventData'] = $eventdata;
			$data['placeData'] = $placedata;
			$data['groupData'] = $groupdata;
			$data = json_encode($data);

		}
	}
	//echo "test";
	

	echo $data;
	//echo ($response->getBody());
?>