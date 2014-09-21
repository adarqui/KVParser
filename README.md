KVParser
======

An attempt at a simple generic key/value parser. Written initially to parse auditd logs (/var/log/audit.log). Parses input and returns a list of key/value pairs, where each value is: String, Number, Bool.

TODO:
- For each input, fix parsing the last key=value pair.
- Add some lexer options to support: key=value, key:value, etc..
- Handle nested key/value pairs properly.
- Handle nested quotes properly.
- Tests

Example
=======

```
Prelude> import Data.KVParser
```

```
Data.KVParser> kv'parse "type=SYSCALL msg=audit(1411016411.982:8): arch=c000003e syscall=59 success=yes exit=0 a0=16ceca8 a1=16abc68 a2=1602808 a3=7fffcf133b00 items=2 ppid=15583 pid=17085 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts16 ses=199 comm=\"tmux\" exe=\"/usr/bin/tmux\" key=(null) k=True v=False"

[("type",String "SYSCALL"),("msg",String "audit(1411016411.982:8):"),("arch",String "c000003e"),("syscall",String "59"),("success",String "yes"),("exit",String "0"),("a0",String "16ceca8"),("a1",String "16abc68"),("a2",String "1602808"),("a3",String "7fffcf133b00"),("items",String "2"),("ppid",String "15583"),("pid",String "17085"),("auid",String "0"),("uid",String "0"),("gid",String "0"),("euid",String "0"),("suid",String "0"),("fsuid",String "0"),("egid",String "0"),("sgid",String "0"),("fsgid",String "0"),("tty",String "pts16"),("ses",String "199"),("comm",String "tmux")]
```

```
Data.KVParser> kv'to'object  it
fromList [("a3",String "7fffcf133b00"),("a2",String "1602808"),("a1",String "16abc68"),("a0",String "16ceca8"),("egid",String "0"),("exit",String "0"),("euid",String "0"),("fsuid",String "0"),("fsgid",String "0"),("auid",String "0"),("arch",String "c000003e"),("comm",String "tmux"),("items",String "2"),("type",String "SYSCALL"),("ppid",String "15583"),("syscall",String "59"),("sgid",String "0"),("suid",String "0"),("msg",String "audit(1411016411.982:8):"),("gid",String "0"),("tty",String "pts16"),("uid",String "0"),("pid",String "17085"),("ses",String "199"),("success",String "yes")]
```
