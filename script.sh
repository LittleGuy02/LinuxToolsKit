#!/bin/bash

VERSION="3.0"
LOG="$HOME/.ltp.log"

# ===== COLORS =====
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

log(){ echo "$(date '+%F %T') | $1" >> "$LOG"; }

logo(){
clear
echo -e "${CYAN}"
echo "██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
echo "██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
echo "██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ "
echo "██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ "
echo "███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
echo "╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"
echo -e "        Linux Toolkit Pro v$VERSION"
echo -e "${RESET}"
}

progress(){
echo -ne "${BLUE}["
for i in {1..25}; do
echo -ne "#"
sleep 0.02
done
echo -e "]${RESET}"
}

pause(){ read -p "Press Enter..."; }

# ===== TOOLS =====

sys_info(){
logo; progress
echo -e "${YELLOW}System Info${RESET}"
hostnamectl | head -n 6
free -h
df -h | head -n 6
log "System info"
pause
}

cpu_monitor(){
logo; progress
top -b -n1 | head -n 15
log "CPU monitor"
pause
}

disk_analyzer(){
logo; progress
du -h --max-depth=1 | sort -hr | head -n 10
log "Disk analyze"
pause
}

net_check(){
logo; progress
echo "Local IP: $(hostname -I)"
echo "Public IP: $(curl -s ifconfig.me)"
ping -c 3 8.8.8.8
log "Network check"
pause
}

port_scan(){
logo; progress
ss -tuln
log "Port scan"
pause
}

process_kill(){
logo
read -p "Process name: " p
pkill "$p" && echo -e "${GREEN}Killed${RESET}" || echo -e "${RED}Not found${RESET}"
log "Kill $p"
pause
}

password_gen(){
logo
read -p "Length: " l
tr -dc A-Za-z0-9 </dev/urandom | head -c "$l"
echo
log "Password gen"
pause
}

backup_tool(){
logo
read -p "Folder: " f
name="backup_$(date +%F_%H%M).tar.gz"
progress
tar -czf "$name" "$f"
echo -e "${GREEN}Saved as $name${RESET}"
log "Backup $f"
pause
}

file_organizer(){
logo; progress
mkdir -p Images Videos Docs
mv *.jpg *.png Images 2>/dev/null
mv *.mp4 Videos 2>/dev/null
mv *.pdf Docs 2>/dev/null
echo -e "${GREEN}Organized${RESET}"
log "Organize files"
pause
}

junk_clean(){
logo; progress
rm -rf ~/.cache/*
find /tmp -type f -delete
echo -e "${GREEN}Cleaned${RESET}"
log "Clean junk"
pause
}

update_system(){
logo; progress
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
log "Update"
pause
}

duplicate_finder(){
logo
read -p "Folder: " f
progress
find "$f" -type f -exec md5sum {} + | sort | uniq -w32 -d
log "Duplicate scan"
pause
}

ram_usage(){
logo; progress
free -h
log "RAM usage"
pause
}

user_list(){
logo; progress
cut -d: -f1 /etc/passwd
log "User list"
pause
}

weather_check(){
logo
read -p "City: " c
progress
curl wttr.in/$c
log "Weather check"
pause
}

# ===== MENU =====

menu(){
while true; do
logo
echo -e "${GREEN}=========== MENU ===========${RESET}"
echo "1) System Info"
echo "2) CPU Monitor"
echo "3) Disk Analyzer"
echo "4) Network Check"
echo "5) Open Ports"
echo "6) Kill Process"
echo "7) Password Generator"
echo "8) Backup"
echo "9) File Organizer"
echo "10) Junk Cleaner"
echo "11) Update System"
echo "12) Duplicate Finder"
echo "13) RAM Usage"
echo "14) User List"
echo "15) Weather"
echo "0) Exit"
echo
read -p "Select: " opt

case $opt in
1) sys_info ;;
2) cpu_monitor ;;
3) disk_analyzer ;;
4) net_check ;;
5) port_scan ;;
6) process_kill ;;
7) password_gen ;;
8) backup_tool ;;
9) file_organizer ;;
10) junk_clean ;;
11) update_system ;;
12) duplicate_finder ;;
13) ram_usage ;;
14) user_list ;;
15) weather_check ;;
0) exit ;;
*) echo "Invalid"; sleep 1 ;;
esac
done
}

menu