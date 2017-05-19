Acquire {
  sftp {
    timeout 40;
    Username repoclient;
    PrivkeyFile /var/srepo/repoclient;
    PubKeyFile /var/srepo/repoclient.pub;
    KnownHosts /etc/ssh/known_hosts;
  };
};
