#!/bin/bash

iptables -P INPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
