<?php

session_start();
include_once( 'config.php' );
include_once( 'saet.ex.class.php' );


$c = new SaeTClient( WB_AKEY , WB_SKEY , $_SESSION['last_key']['oauth_token'] , $_SESSION['last_key']['oauth_token_secret']  );
$ms  = $c->home_timeline(); // done

?>
<html><head><meta http-equiv=content-type content="text/html; charset=utf-8"> </head>
<body>
<h2>发送新微博</h2>
<form action="weibolist.php" >
<input type="text" name="text" style="width:300px" />
&nbsp;<input type="submit" />
</form>
<?php

if( isset($_REQUEST['text']) )
{
// 发送微博
	$c->update($_REQUEST['text']);
	echo $_REQUEST['text']."<p>发送完成</p>";

}
$user = $c->verify_credentials();
//var_dump($user); 
echo "<div>user:".$user["id"]."</div>";
?>

<?php if( is_array( $ms ) ): ?>
<?php foreach( $ms as $item ): ?>
<div style="padding:10px;margin:5px;border:1px solid #ccc">
<?=$item['text'];?>
</div>
<?php endforeach; ?>
<?php endif; ?>




</body>
</html>