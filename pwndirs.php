<?php

# pwndirs.php - Write file to every dir below __DIR__
# v. 2018-04-16

$dir = __DIR__;
$filesArray = scandir($dir);
$dirsArray = [];
$fileName = 'test.txt';
$fileContent = "This is a test.\n";

foreach ($filesArray as $file) {
    $dirsPath = $dir . '/' . $file;

    if ($file === '.' or $file === '..') {
        continue;
    } elseif ( is_dir($dirsPath) ) {
        array_push($dirsArray, $dirsPath);
    }
}

foreach ($dirsArray as $pwned) {
    $file = $pwned . '/' . $fileName;
    file_put_contents($file, $fileContent);
}
