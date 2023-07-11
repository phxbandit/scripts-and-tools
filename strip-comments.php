<?php

// strip-comments.php

// https://stackoverflow.com/questions/503871/best-way-to-automatically-remove-comments-from-php-code

$fileStr = file_get_contents($argv[1]);

foreach (token_get_all($fileStr) as $token ) {
    if ($token[0] != T_COMMENT) {
        continue;
    }
    $fileStr = str_replace($token[1], '', $fileStr);
}

echo $fileStr;
