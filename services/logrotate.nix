{
  services.logrotate = {
    enable = true;
    config = ''
      weekly
      rotate 4
      create

      /var/log/wtmp {
          monthly
          create 0664 root utmp
          minsize 1M
          rotate 1
      }

      /var/log/btmp {
          missingok
          monthly
          create 0660 root utmp
          rotate 1
      }
    '';
  };
}
