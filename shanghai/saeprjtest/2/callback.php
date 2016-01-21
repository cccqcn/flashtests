<?php

session_start();
include_once( 'config.php' );
include_once( 'saet.ex.class.php' );



$o = new SaeTOAuth( WB_AKEY , WB_SKEY , $_SESSION['keys']['oauth_token'] , $_SESSION['keys']['oauth_token_secret']  );

$roll_last_key = $o->getAccessToken(  $_REQUEST['oauth_verifier'] ) ;

$_SESSION['roll_last_key'] = $roll_last_key;


?>
<html><head><meta http-equiv=content-type content="text/html; charset=utf-8"> </head>
<body>
授权完成,<a href="roll.php">开始</a>

</body>
</html>