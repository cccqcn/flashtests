<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<?php
$SaeLocationObj = new SaeLocation();
$ip_to_geo_arr = array('ip'=>'124.163.223.179');
$ip_to_geo = $SaeLocationObj->getIpToGeo($ip_to_geo_arr);
echo 'ip_to_geo: ';
print_r($ip_to_geo);
echo '</br>';
 // Ê§°ÜÊ±Êä³ö´íÎóÂëºÍ´íÎóÐÅÏ¢
if ( $ip_to_geo === false)
        var_dump($SaeLocationObj->errno(), $SaeLocationObj->errmsg());
?>