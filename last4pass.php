<?php

// last4pass.php - https://isc.sans.edu/forums/diary/Well+Hello+Again+Peppa/23860/

function help() {
    echo "\nUsage: last4pass.php <two-byte hex string>\n\n";
    exit(1);
}

function hashit($target) {
    $chars = ['1','2','3','4','5','6','7','8','9','0','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
    $str = [];

    while (TRUE) {
        for ($i = 1; $i <= 12; $i++) {
            $pos = array_rand($chars, 1);
            array_push($str, $chars[$pos]);
        }
        $pass = implode('', $str);
        $four = substr(sha1(md5($pass)), 36);
        $matchfour = '/' . $four . '/';
        if ( preg_match($matchfour, $target) ) {
            echo "Match: $four == $target ($pass)\n";
            exit();
        } else {
            echo "No match: $four != $target ($pass)\n";
            $str = [];
        }
    }
}

$hex = '/^[0-9A-Fa-f]{4}$/';
( isset($argv[1]) && preg_match($hex, $argv[1]) ) || help();
$target = strtolower($argv[1]);
hashit($target);
