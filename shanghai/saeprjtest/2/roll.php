<?php

session_start();
include_once( 'config.php' );
include_once( 'saet.ex.class.php' );


$c = new SaeTClient( WB_AKEY , WB_SKEY , $_SESSION['roll_last_key']['oauth_token'] , $_SESSION['roll_last_key']['oauth_token_secret']  );
$user = $c->verify_credentials();

?>
<html><head><meta http-equiv=content-type content="text/html; charset=utf-8"> </head>
<body>
<?php

$hasrolled = 0;
$myroll = 0;
$usergroup = "";

$mysql = new SaeMysql();
 
$sql = "select count(*) from rolldata";
$total = $mysql->getData( $sql );
$sql = "SELECT COUNT(*) FROM (SELECT usergroup FROM rolldata GROUP BY usergroup)gg";
$groups = $mysql->getData( $sql );
if($user["id"] == "" || $user["id"] == null)
{
	$hasrolled = -1;
}
else
{
	$sql = "select * from rolldata where userid=".$user["id"];
	$userdata = $mysql->getData( $sql );
	for ($i = 0;$i < count($userdata); $i++) {
		if($userdata[$i]["userid"] == $user["id"])
		{
			$hasrolled = 1;
			$myroll = $userdata[$i]["roll"];
			$usergroup = $userdata[$i]["usergroup"];
			$sql = "select * from rolldata where usergroup ='".$usergroup."'  order by roll desc limit 50";
			$data = $mysql->getData( $sql );
			$sql = "select count(*) from rolldata where usergroup ='".$usergroup."' ";
			$grouptotal = $mysql->getData( $sql );
		}
	}
}
 

if( isset($_REQUEST['text']) )
{
	// 发送微博
	$c->update($_REQUEST['text']);
	echo "<p>发送完成</p>";
}

if( isset($_REQUEST['roll']) )
{
	if($hasrolled == 0)
	{
		$myroll = (mt_rand()%100)+1;
		$usergroup = $_REQUEST['usergroup'];
		$sql = "INSERT  INTO `rolldata` ( `userid` , `username` , `userhead` , `roll`, `ipaddress`, `usergroup` ) VALUES ( '"  . $user["id"] . "' , '" . $user["name"] . "', '" . $user["profile_image_url"] . "', '" . $myroll . "', '0', '" . $usergroup . "')";
		$mysql->runSql( $sql );
		$sql = "select count(*) from rolldata";
		$total = $mysql->getData( $sql );
		$sql = "SELECT COUNT(*) FROM (SELECT usergroup FROM rolldata GROUP BY usergroup)gg";
		$groups = $mysql->getData( $sql );
		$sql = "select * from rolldata where usergroup ='".$usergroup."'  order by addtime desc limit 50";
		$data = $mysql->getData( $sql );
		$sql = "select count(*) from rolldata where usergroup ='".$usergroup."' ";
		$grouptotal = $mysql->getData( $sql );
		echo "<p>roll ok</p>";
		$hasrolled = 1;
	}
}
if($hasrolled == -1)
{
	echo "<p>无授权</p>";
}
else
{
	if($hasrolled == 0)
	{
		showSubmit();
	}
	else
	{
		echo "<p>已获得点数</p>";
		showResult();
	}
}
$mysql->closeDb();
?>


<?="共有".$total[0]["count(*)"]."人获得过点数，共有".$groups[0]["COUNT(*)"]."个分组。<br /><br />";?>
<?="所在分组".$usergroup."有".$grouptotal[0]["count(*)"]."人获得过点数<br /><br />";?>
<?php if( is_array( $data ) ): ?>
<?php foreach( $data as $item ): ?>
<div style="padding:10px;margin:5px;border:1px solid #ccc">
<?="<img style=\"width:50px;height:50px;border:none\" src=\"".$item["userhead"]."\" /> <a href=\"http://weibo.com/".$item["userid"]."\" target=\"_blank\">".$item['username']."</a>：\t\t".$item['roll'];?>
</div>
<?php endforeach; ?>
<?php endif; ?>


</body>
</html>

<?php
function showResult()
{
	global $myroll, $usergroup;
?>
<form action="roll.php" method="post" >
将结果发送到微博：<br />
<textarea name="text" style="width:300px;height:60px">我的点数是：<?=$myroll;?>（分组<?=$usergroup;?>），在这里参加分组点数：http://prjtest.sinaapp.com</textarea>
<input type="submit" value="提交" />
</form>
<?php
}
?>

<?php
function showSubmit()
{
?>
<form action="roll.php" method="post" >
分组：<input type="text" name="usergroup" value="" />
<input type="hidden" name="roll" value="1" />
<br />
<input type="submit" value="ROLL" />
</form>
<?php
}
?>
