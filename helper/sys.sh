#!/bin/bash

ps-top-mem() {
   ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 10
}

ps-top-cpu() {
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 10
}
