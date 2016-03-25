<?php

// getdata.php - Retrieves file from selfdestruct.pw hashes

// Check the environment
if ( ! function_exists('curl_init') ) {
    die("ERROR: cURL not available\n");
}

if ( ! isset($argv[1]) ) {
    die("ERROR: Provide hash file as argument\n");
} else {
    $file = $argv[1];
}

// Function to retrieve data for each hash
function getData($hash) {
    $query = '?' . $hash;

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, 'https://selfdestruct.pw/' . trim($query));
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

    $response = curl_exec($ch);

    curl_close($ch);

    $regex = '/PASSWORD\:<\/b>(.*?)<br \/>/';
    preg_match($regex, $response, $match);
    print_r( html_entity_decode($match[1]) );
}

// Read hash file and call getData for each hash
$fh = fopen($file, "r") or die("ERROR: Unable to open hash file\n");

$sha256regex = '/^[0-9a-f]{64}$/';

while ( !feof($fh) ) {
    $line = fgets($fh);
    if ( preg_match($sha256regex, $line) ) {
        getData($line);
    }
}

fclose($fh);

?>
