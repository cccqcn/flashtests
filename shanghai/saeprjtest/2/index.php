<?php

session_start();
if( isset($_SESSION['roll_last_key']) ) header("Location: roll.php");
include_once( 'config.php' );
include_once( 'saet.ex.class.php' );



$o = new SaeTOAuth( WB_AKEY , WB_SKEY  );

$keys = $o->getRequestToken();
$aurl = $o->getAuthorizeURL( $keys['oauth_token'] ,false , 'http://' . $_SERVER['HTTP_APPNAME'] . '.sinaapp.com/callback.php');

$_SESSION['keys'] = $keys;



$mysql = new SaeMysql();
 
$sql = "select count(*) from rolldata";
$data = $mysql->getData( $sql );
$sql = "SELECT COUNT(*) FROM (SELECT usergroup FROM rolldata GROUP BY usergroup)gg";
$groups = $mysql->getData( $sql );
$mysql->closeDb();
?>
<html><head><meta http-equiv=content-type content="text/html; charset=utf-8"> </head>
<body>
本应用可为每个用户生成一个随机点数，可用于在一个组内对多个用户进行排序，每个用户先设置自己的组的标识符。
<br /><br />
总共有<?=$data[0]["count(*)"]?>人获得过点数<br /><br />
分为<?=$groups[0]["COUNT(*)"]?>组<br /><br />
<a href="<?=$aurl?>">微博授权</a>
</body>
</html>