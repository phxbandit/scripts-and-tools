<?php

// putdata.php - Stores arbitrary files in selfdestruct.pw
// VVestron Phoronix

// Check the environment
if ( ! function_exists('curl_init') ) {
    die("ERROR: cURL not available\n");
}

if ( ! isset($argv[1]) ) {
    die("ERROR: Provide file as argument\n");
} else {
    $file = $argv[1];
}

// Function to get hash for each 256 byte chunk
function getHash($str) {
    $passData = $str;
    $data = array('password' => $passData, 'submit' => 'Submit');

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, "https://selfdestruct.pw/");
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

    $response = curl_exec($ch);

    curl_close($ch);

    $regex = '/[0-9a-f]{64}/';
    preg_match($regex, $response, $match);
    print_r($match[0]);
    echo "\n";
}

// Read, normalize, and get hash for file 256 bytes at a time
$fh = fopen($file, "r") or die("ERROR: Unable to open file\n");

$newlines = array("\r", "\n", "\r\n");

while ( !feof($fh) ) {
    $strTemp1 = fread($fh, 256);
    $strTemp2 = str_replace($newlines, " ", $strTemp1);
    $strTemp3 = str_replace("\t", " ", $strTemp2);
    $str = preg_replace("/\s+/", " ", $strTemp3);
    getHash($str);
}

fclose($fh);

?>
